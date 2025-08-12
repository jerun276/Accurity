import 'dart:async';
import '../../core/services/supabase_service.dart';
import '../models/order.model.dart';
import '../models/sync_status.enum.dart';
import 'database_repository.dart';

class OrderRepository {
  final DatabaseRepository _db;
  final SupabaseService _supabaseService;

  OrderRepository(this._db, this._supabaseService);


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
  Future<void> syncFromServer(String userId) async {
    print('[Repo] Starting sync from server for user $userId');
    // THE FIX: The call to fetchOrdersForUser now correctly passes no arguments.
    final serverOrdersData = await _supabaseService.fetchOrdersForUser();

    final serverOrders = serverOrdersData
        .map((data) => Order.fromDbMap(data))
        .toList();

    await _db.clearAllOrders();

    final ordersToSave = serverOrders
        .map((order) => order.copyWith(syncStatus: SyncStatus.synced))
        .toList();

    for (final order in ordersToSave) {
      await _db.saveOrder(order);
    }

    print(
      '[Repo] Sync from server complete. Saved ${ordersToSave.length} orders locally.',
    );
  }

  Future<void> clearLocalData() async {
    await _db.clearAllOrders();
  }
}
