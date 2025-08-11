import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path/path.dart' as p;

import '../../data/models/order.model.dart';
import '../../data/models/sync_status.enum.dart';
import '../../data/repositories/order_repository.dart';
import 'supabase_auth_service.dart';
import 'supabase_service.dart';
import 'supabase_storage_service.dart';

class SyncService {
  final OrderRepository _orderRepository;
  final SupabaseService _supabaseService;
  final SupabaseStorageService _supabaseStorageService;
  final SupabaseAuthService _authService;
  final Connectivity _connectivity;

  SyncService({
    required OrderRepository orderRepository,
    required SupabaseService supabaseService,
    required SupabaseStorageService supabaseStorageService,
    required SupabaseAuthService authService,
    required Connectivity connectivity,
  }) : _orderRepository = orderRepository,
       _supabaseService = supabaseService,
       _supabaseStorageService = supabaseStorageService,
       _authService = authService,
       _connectivity = connectivity;

  /// Checks for unsynced orders and pushes them to Supabase if online.
  Future<void> syncUnsyncedOrders() async {
    print('[SyncService] Starting sync process...');

    // 1. Check for internet connection.
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print('[SyncService] No internet connection. Sync aborted.');
      return;
    }

    // 2. Get the current user's ID. If no one is logged in, we can't sync.
    final currentUserId = _authService.currentUser?.id;
    if (currentUserId == null) {
      print('[SyncService] No authenticated user found. Cannot sync.');
      return;
    }

    // 3. Get all orders from the local database that need syncing.
    final unsyncedOrders = await _orderRepository.getUnsyncedOrders();
    if (unsyncedOrders.isEmpty) {
      print('[SyncService] No unsynced orders to process.');
      return;
    }

    print('[SyncService] Found ${unsyncedOrders.length} orders to sync.');

    // 4. Loop through each unsynced order and process it.
    for (var order in unsyncedOrders) {
      try {
        // --- THE CRITICAL LOGIC ---
        // If the order is new (localOnly), we inject the current user's ID into it.
        if (order.syncStatus == SyncStatus.localOnly) {
          order = order.copyWith(userId: currentUserId);
        }

        // First, handle uploading any local photos and get their public URLs.
        final orderWithCloudPhotos = await _uploadOrderPhotos(order);

        // Now, sync the order data itself, which now contains the user_id and photo URLs.
        if (orderWithCloudPhotos.syncStatus == SyncStatus.localOnly) {
          final newSupabaseId = await _supabaseService.createOrder(
            orderWithCloudPhotos,
          );
          if (newSupabaseId != null) {
            final updatedOrder = orderWithCloudPhotos.copyWith(
              supabaseId: newSupabaseId,
              syncStatus: SyncStatus.synced,
            );
            await _orderRepository.updateLocalOrder(updatedOrder);
            print(
              '[SyncService] Successfully synced NEW order with localId: ${order.localId}',
            );
          }
        } else if (orderWithCloudPhotos.syncStatus == SyncStatus.needsUpdate) {
          // For updates, we don't change the user_id, as the original creator should be preserved.
          await _supabaseService.updateOrder(orderWithCloudPhotos);
          final updatedOrder = orderWithCloudPhotos.copyWith(
            syncStatus: SyncStatus.synced,
          );
          await _orderRepository.updateLocalOrder(updatedOrder);
          print(
            '[SyncService] Successfully synced UPDATED order with localId: ${order.localId}',
          );
        }
      } catch (e) {
        print(
          '[SyncService] ERROR syncing order with localId: ${order.localId}. Error: $e',
        );
        // Continue to the next order even if one fails.
      }
    }
    print('[SyncService] Sync process finished.');
  }

  /// A helper method to upload photos for a single order.
  Future<Order> _uploadOrderPhotos(Order order) async {
    if (order.photoPaths.isEmpty) {
      return order;
    }

    final List<String> cloudPhotoUrls = [];
    bool hasChanges = false;

    for (final path in order.photoPaths) {
      if (path.startsWith('http')) {
        cloudPhotoUrls.add(path);
      } else {
        hasChanges = true;
        print('[SyncService] Found local photo to upload: $path');
        final file = File(path);

        if (await file.exists()) {
          final fileName = 'order_${order.localId}_${p.basename(file.path)}';

          try {
            final publicUrl = await _supabaseStorageService.uploadImage(
              file,
              fileName,
            );
            cloudPhotoUrls.add(publicUrl);
            print('[SyncService] Photo uploaded successfully. URL: $publicUrl');
          } catch (e) {
            print('[SyncService] FAILED to upload photo: $path. Error: $e');
            cloudPhotoUrls.add(path);
          }
        } else {
          print('[SyncService] Local photo file not found, skipping: $path');
        }
      }
    }

    if (hasChanges) {
      return order.copyWith(photoPaths: cloudPhotoUrls);
    } else {
      return order;
    }
  }
}
