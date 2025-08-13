import 'dart:async';
import '../../core/services/supabase_service.dart';
import '../models/order.model.dart';
import '../models/sync_status.enum.dart';
import 'database_repository.dart';
import '../../core/services/photo_cache_service.dart';

class OrderRepository {
  final DatabaseRepository _db;
  final SupabaseService _supabaseService;
  final PhotoCacheService _photoCacheService;

  OrderRepository(this._db, this._supabaseService, this._photoCacheService);

  Future<Order> getOrder(int localId) async {
    return _db.getOrder(localId);
  }

  Future<List<Order>> getAllOrders() async {
    return _db.getAllOrders();
  }

  Future<Order> saveOrder(Order order) async {
    SyncStatus newStatus;
    if (order.syncStatus == SyncStatus.synced) {
      newStatus = SyncStatus.needsUpdate;
    } else {
      newStatus = order.syncStatus;
    }
    final orderToSave = order.copyWith(syncStatus: newStatus);
    final savedOrder = await _db.saveOrder(orderToSave);
    return savedOrder;
  }

  Future<List<Order>> getUnsyncedOrders() async {
    return _db.getOrdersWithStatus([
      SyncStatus.localOnly,
      SyncStatus.needsUpdate,
    ]);
  }

  Future<void> updateLocalOrder(Order order) async {
    return _db.updateLocalOrder(order);
  }

  /// Fetches orders from Supabase for the currently logged-in user.
  // Future<void> syncFromServer(String userId) async {
  //   print('[Repo] Starting sync from server for user $userId');
  //   final serverOrdersData = await _supabaseService.fetchOrdersForUser();

  //   for (final orderData in serverOrdersData) {
  //     final photoPaths = List<String>.from(orderData['photo_paths'] ?? []);
  //     for (final url in photoPaths) {
  //       _photoCacheService.cacheImageFromUrl(url);
  //     }
  //   }

  //   final serverOrders = serverOrdersData
  //       .map((data) => Order.fromDbMap(data))
  //       .toList();

  //   await _db.clearAllOrders();

  //   final ordersToSave = serverOrders
  //       .map((order) => order.copyWith(syncStatus: SyncStatus.synced))
  //       .toList();

  //   for (final order in ordersToSave) {
  //     await _db.saveOrder(order);
  //   }

  //   print(
  //     '[Repo] Sync from server complete. Saved ${ordersToSave.length} orders locally.',
  //   );
  // }

  Future<void> syncFromServer(String userId) async {
    print('[Repo] Starting two-way sync for user $userId');

    final allLocalOrders = await _db.getAllOrders();

    final localOnlyOrders = allLocalOrders
        .where((order) => order.syncStatus == SyncStatus.localOnly)
        .toList();
    final needsUpdateOrders = allLocalOrders
        .where((order) => order.syncStatus == SyncStatus.needsUpdate)
        .toList();

    for (final order in localOnlyOrders) {
      try {
        final newSupabaseId = await _supabaseService.createOrder(order);

        if (newSupabaseId != null) {
          await updateLocalOrder(
            order.copyWith(
              supabaseId: newSupabaseId,
              syncStatus: SyncStatus.synced,
            ),
          );
        } else {
          print(
            'Supabase returned a null ID for order ${order.localId}. Cannot update sync status.',
          );
        }
      } catch (e) {
        print(
          'Failed to create order on Supabase: ${order.localId}. Error: $e',
        );
      }
    }

    for (final order in needsUpdateOrders) {
      try {
        if (order.supabaseId != null) {
          await _supabaseService.updateOrder(order);
          await updateLocalOrder(order.copyWith(syncStatus: SyncStatus.synced));
        }
      } catch (e) {
        print(
          'Failed to update order on Supabase: ${order.localId}. Error: $e',
        );
      }
    }

    print('[Repo] Local changes pushed. Now fetching server data...');
    final serverOrdersData = await _supabaseService.fetchOrdersForUser();
    final serverOrders = serverOrdersData
        .map((data) => Order.fromDbMap(data))
        .toList();

    for (final orderData in serverOrdersData) {
      final photoPaths = List<String>.from(orderData['photo_paths'] ?? []);
      for (final url in photoPaths) {
        _photoCacheService.cacheImageFromUrl(url);
      }
    }

    await _db.clearAllOrders();

    final ordersToSave = serverOrders
        .map((order) => order.copyWith(syncStatus: SyncStatus.synced))
        .toList();

    for (final order in ordersToSave) {
      await _db.saveOrder(order);
    }

    print(
      '[Repo] Two-way sync complete. Local database is now in sync with the server.',
    );
  }

  Future<void> clearLocalData() async {
    await _db.clearAllOrders();
  }

  Future<void> deleteOrder(int localId, String? supabaseId) async {
    await _db.deleteOrder(localId);

    if (supabaseId != null) {
      try {
        await _supabaseService.deleteOrder(supabaseId);
      } catch (e) {
        print('Failed to delete from Supabase: $e');
        rethrow;
      }
    }
  }
}
