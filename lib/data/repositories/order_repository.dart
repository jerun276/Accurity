import '../models/order.model.dart';
import '../models/sync_status.enum.dart';
import 'database_repository.dart';

/// The single source of truth for all order-related data in the app.
///
/// This repository abstracts the underlying data source (currently SQLite)
/// from the rest of the application. The BLoCs interact with this class,

class OrderRepository {
  final DatabaseRepository _db;

  OrderRepository(this._db);

  /// Retrieves a single order by its local ID.
  Future<Order> getOrder(int localId) async {
    return _db.getOrder(localId);
  }

  /// Retrieves a list of all saved orders.
  Future<List<Order>> getAllOrders() async {
    return _db.getAllOrders();
  }

  /// Saves an order and intelligently sets its sync status.
  ///
  /// This is a critical piece of the offline-first logic.
  Future<Order> saveOrder(Order order) async {
    SyncStatus newStatus;

    // If the record was already synced and is now being edited, it needs an update.
    if (order.syncStatus == SyncStatus.synced) {
      newStatus = SyncStatus.needsUpdate;
    } else {
      // If it was created offline (localOnly) or already needed an update,
      // its status remains unchanged until it is successfully synced.
      newStatus = order.syncStatus;
    }

    final orderToSave = order.copyWith(syncStatus: newStatus);

    return _db.saveOrder(orderToSave);
  }

  /// For the future SyncService to find records to push to Supabase.
  Future<List<Order>> getUnsyncedOrders() async {
    return _db.getOrdersWithStatus([
      SyncStatus.localOnly,
      SyncStatus.needsUpdate,
    ]);
  }
}
