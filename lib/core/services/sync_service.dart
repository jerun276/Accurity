import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path/path.dart' as p;

import '../../data/models/order.model.dart';
import '../../data/models/sync_status.enum.dart';
import '../../data/repositories/order_repository.dart';
import 'package:accurity/data/models/sync_state.enum.dart';
import 'supabase_auth_service.dart';
import 'supabase_service.dart';
import 'supabase_storage_service.dart';

class SyncService {
  final OrderRepository _orderRepository;
  final SupabaseService _supabaseService;
  final SupabaseStorageService _supabaseStorageService;
  final SupabaseAuthService _authService;
  final Connectivity _connectivity;

  final _syncStateController = StreamController<SyncState>.broadcast();
  Stream<SyncState> get syncStateStream => _syncStateController.stream;

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

  void dispose() {
    _syncStateController.close();
  }

  /// Checks for unsynced orders and pushes them to Supabase if online.
  Future<void> syncUnsyncedOrders() async {
    _syncStateController.add(SyncState.syncing);

    // 1. Check for internet connection.
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print('[SyncService] No internet connection. Sync aborted.');
      _syncStateController.add(SyncState.failure);
      return;
    }

    // 2. Get the current user's ID. If no one is logged in, we can't sync.
    final currentUserId = _authService.currentUser?.id;
    if (currentUserId == null) {
      print('[SyncService] No authenticated user found. Cannot sync.');
      _syncStateController.add(SyncState.failure);
      return;
    }

    // 3. Get all orders from the local database that need syncing.
    final unsyncedOrders = await _orderRepository.getUnsyncedOrders();
    if (unsyncedOrders.isEmpty) {
      print('[SyncService] No unsynced orders to process.');
      _syncStateController.add(SyncState.idle);
      return;
    }

    print('[SyncService] Found ${unsyncedOrders.length} orders to sync.');
    bool allSyncsSuccessful = true;

    // 4. Loop through each unsynced order and process it.
    for (var order in unsyncedOrders) {
      try {
        if (order.syncStatus == SyncStatus.localOnly) {
          order = order.copyWith(userId: currentUserId);
        }
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
        allSyncsSuccessful = false; 
        print(
          '[SyncService] ERROR syncing order with localId: ${order.localId}. Error: $e',
        );
      }
    }

    // 2. Announce the final result.
    if (allSyncsSuccessful) {
      _syncStateController.add(SyncState.success);
    } else {
      _syncStateController.add(SyncState.failure);
    }

    // After a short delay, return to idle state
    await Future.delayed(const Duration(seconds: 3));
    _syncStateController.add(SyncState.idle);

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
