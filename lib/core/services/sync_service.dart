import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path/path.dart' as p;

import '../../data/models/order.model.dart';
import '../../data/models/sync_status.enum.dart';
import '../../data/repositories/order_repository.dart';
import 'supabase_service.dart';
import 'supabase_storage_service.dart';

class SyncService {
  final OrderRepository _orderRepository;
  final SupabaseService _supabaseService;
  final SupabaseStorageService _supabaseStorageService;
  final Connectivity _connectivity;

  SyncService({
    required OrderRepository orderRepository,
    required SupabaseService supabaseService,
    required SupabaseStorageService supabaseStorageService,
    required Connectivity connectivity,
  }) : _orderRepository = orderRepository,
       _supabaseService = supabaseService,
       _supabaseStorageService = supabaseStorageService,
       _connectivity = connectivity;

  Future<void> syncUnsyncedOrders() async {
    print('[SyncService] Starting sync process...');

    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print('[SyncService] No internet connection. Sync aborted.');
      return;
    }

    // The rest of the method is the same as your correct version
    final unsyncedOrders = await _orderRepository.getUnsyncedOrders();
    if (unsyncedOrders.isEmpty) {
      print('[SyncService] No unsynced orders to process.');
      return;
    }

    print('[SyncService] Found ${unsyncedOrders.length} orders to sync.');

    for (final order in unsyncedOrders) {
      try {
        final orderWithCloudPhotos = await _uploadOrderPhotos(order);
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
          }
        } else if (orderWithCloudPhotos.syncStatus == SyncStatus.needsUpdate) {
          await _supabaseService.updateOrder(orderWithCloudPhotos);
          final updatedOrder = orderWithCloudPhotos.copyWith(
            syncStatus: SyncStatus.synced,
          );
          await _orderRepository.updateLocalOrder(updatedOrder);
        }
      } catch (e) {
        print(
          '[SyncService] ERROR syncing order with localId: ${order.localId}. Error: $e',
        );
      }
    }
    print('[SyncService] Sync process finished.');
  }

  Future<Order> _uploadOrderPhotos(Order order) async {
    // ... This entire helper method from your code is correct and does not need to change ...
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
        final file = File(path);
        if (await file.exists()) {
          final fileName = 'order_${order.localId}_${p.basename(file.path)}';
          try {
            final publicUrl = await _supabaseStorageService.uploadImage(
              file,
              fileName,
            );
            cloudPhotoUrls.add(publicUrl);
          } catch (e) {
            print('[SyncService] FAILED to upload photo: $path. Error: $e');
            cloudPhotoUrls.add(path);
          }
        }
      }
    }
    return hasChanges ? order.copyWith(photoPaths: cloudPhotoUrls) : order;
  }
}
