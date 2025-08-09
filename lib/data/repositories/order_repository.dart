import 'dart:async';
import '../../core/services/sync_service.dart';
import '../models/order.model.dart';
import '../models/sync_status.enum.dart';
import 'database_repository.dart';

class OrderRepository {
  final DatabaseRepository _db;

  // CHANGED: Instead of a direct instance, this is now a function
  // that knows how to get the SyncService instance. This breaks the
  // circular dependency during initialization.
  final SyncService Function() _getSyncService;

  // This is a private getter that executes the function to resolve the
  // SyncService instance only when it's actually needed.
  SyncService get _syncService => _getSyncService();

  // The constructor is updated to accept the function.
  OrderRepository(this._db, this._getSyncService);

  /// Retrieves a single order by its local ID.
  Future<Order> getOrder(int localId) async {
    return _db.getOrder(localId);
  }

  /// Retrieves a list of all saved orders.
  Future<List<Order>> getAllOrders() async {
    return _db.getAllOrders();
  }

  /// Saves an order, intelligently sets its sync status, and triggers a sync.
  Future<Order> saveOrder(Order order) async {
    SyncStatus newStatus;

    if (order.syncStatus == SyncStatus.synced) {
      newStatus = SyncStatus.needsUpdate;
    } else {
      newStatus = order.syncStatus;
    }

    final orderToSave = order.copyWith(syncStatus: newStatus);
    final savedOrder = await _db.saveOrder(orderToSave);

    // This now works perfectly. When this line is called, the `_syncService`
    // getter executes the function provided by main.dart, returning the
    // fully initialized SyncService instance.
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
}
