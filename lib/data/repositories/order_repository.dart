import 'dart:async';
import '../../core/services/sync_service.dart';
import '../../core/services/supabase_service.dart';
import '../models/order.model.dart';
import '../models/sync_status.enum.dart';
import 'database_repository.dart';

class OrderRepository {
  final DatabaseRepository _db;
  final SupabaseService _supabaseService;

  // This is a 'late' variable, which we promise to set immediately after creation.
  late SyncService _syncService;

  // The constructor takes the direct dependencies.
  OrderRepository(this._db, this._supabaseService);

  /// This setter method is used by main.dart to inject the SyncService.
  void setSyncService(SyncService service) {
    _syncService = service;
  }

  /// Retrieves a single order by its local ID from the local database.
  Future<Order> getOrder(int localId) async {
    return _db.getOrder(localId);
  }

  /// Retrieves a list of all saved orders from the local database.
  Future<List<Order>> getAllOrders() async {
    return _db.getAllOrders();
  }

  /// Saves an order, intelligently sets its sync status, and triggers a sync.
  /// NOTE: This method was calling a flawed _db.saveOrder() which, combined with
  /// a flawed Order.fromDbMap(), caused the bug.
  Future<Order> saveOrder(Order order) async {
    SyncStatus newStatus;

    if (order.syncStatus == SyncStatus.synced) {
      newStatus = SyncStatus.needsUpdate;
    } else {
      newStatus = order.syncStatus;
    }

    final orderToSave = order.copyWith(syncStatus: newStatus);
    final savedOrder = await _db.saveOrder(orderToSave);

    unawaited(_syncService.syncUnsyncedOrders());

    return savedOrder;
  }

  /// Retrieves all orders that need to be pushed to the cloud.
  Future<List<Order>> getUnsyncedOrders() async {
    return _db.getOrdersWithStatus([
      SyncStatus.localOnly,
      SyncStatus.needsUpdate,
    ]);
  }

  /// Updates an existing order in the local database. Used by the SyncService.
  Future<void> updateLocalOrder(Order order) async {
    return _db.updateLocalOrder(order);
  }

  /// Fetches orders from Supabase, clears the local DB, and saves the new data.
  Future<void> syncFromServer(String userId) async {
    print('[Repo] Starting sync from server for user $userId');
    final serverOrdersData = await _supabaseService.fetchOrdersForUser(userId);
    // NOTE: The bug originated here, where Order.fromDbMap was failing
    // to correctly parse the 'localId' due to inconsistent naming.
    final serverOrders = serverOrdersData
        .map((data) => Order.fromDbMap(data))
        .toList();

    await _db.clearAllOrders();

    final ordersToSave = serverOrders
        .map((order) => order.copyWith(syncStatus: SyncStatus.synced))
        .toList();

    // The `bulkInsertOrders` method did not exist at this point in time.
    // We were using a simple loop.
    for (final order in ordersToSave) {
      await _db.saveOrder(order);
    }

    print(
      '[Repo] Sync from server complete. Saved ${serverOrders.length} orders locally.',
    );
  }

  /// A simple wrapper to clear local data on logout.
  Future<void> clearLocalData() async {
    await _db.clearAllOrders();
  }
}
