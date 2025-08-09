import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../data/models/sync_status.enum.dart';
import '../../data/repositories/order_repository.dart';
import 'supabase_service.dart';

class SyncService {
  final OrderRepository _orderRepository;
  final SupabaseService _supabaseService;
  final Connectivity _connectivity;

  SyncService({
    required OrderRepository orderRepository,
    required SupabaseService supabaseService,
    required Connectivity connectivity,
  }) : _orderRepository = orderRepository,
       _supabaseService = supabaseService,
       _connectivity = connectivity;

  /// Checks for unsynced orders and pushes them to Supabase if online.
  Future<void> syncUnsyncedOrders() async {
    print('[SyncService] Starting sync process...');

    // 1. Check for internet connection
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print('[SyncService] No internet connection. Sync aborted.');
      return;
    }

    // 2. Get all orders that are not synced
    final unsyncedOrders = await _orderRepository.getUnsyncedOrders();
    if (unsyncedOrders.isEmpty) {
      print('[SyncService] No unsynced orders to process.');
      return;
    }

    print('[SyncService] Found ${unsyncedOrders.length} orders to sync.');

    // 3. Loop through and process each unsynced order
    for (final order in unsyncedOrders) {
      try {
        if (order.syncStatus == SyncStatus.localOnly) {
          // This is a new record, create it on Supabase
          final newSupabaseId = await _supabaseService.createOrder(order);
          if (newSupabaseId != null) {
            // Update the local record with the new supabaseId and set status to synced
            final updatedOrder = order.copyWith(
              supabaseId: newSupabaseId,
              syncStatus: SyncStatus.synced,
            );
            await _orderRepository.updateLocalOrder(updatedOrder);
            print(
              '[SyncService] Successfully synced new order with localId: ${order.localId}',
            );
          }
        } else if (order.syncStatus == SyncStatus.needsUpdate) {
          // This is an existing record, update it on Supabase
          await _supabaseService.updateOrder(order);
          // Update the local record's status to synced
          final updatedOrder = order.copyWith(syncStatus: SyncStatus.synced);
          await _orderRepository.updateLocalOrder(updatedOrder);
          print(
            '[SyncService] Successfully synced updated order with localId: ${order.localId}',
          );
        }
      } catch (e) {
        print(
          '[SyncService] ERROR syncing order with localId: ${order.localId}. Error: $e',
        );
        // Continue to the next order even if one fails
      }
    }
    print('[SyncService] Sync process finished.');
  }
}
