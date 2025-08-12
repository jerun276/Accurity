import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../data/models/order.model.dart';
import '../../data/models/sync_result.model.dart';
import '../../data/models/sync_state.enum.dart';
import '../../data/models/sync_status.enum.dart';
import '../../data/repositories/order_repository.dart';
import 'supabase_service.dart';
import 'supabase_storage_service.dart';
import 'supabase_auth_service.dart';

class SyncService {
  final OrderRepository _orderRepository;
  final SupabaseService _supabaseService;
  final SupabaseStorageService _supabaseStorageService;
  final SupabaseAuthService _authService;
  final Connectivity _connectivity;

  final _syncStateController = StreamController<SyncResult>.broadcast();
  Stream<SyncResult> get syncStateStream => _syncStateController.stream;

  bool _isSyncing = false;

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
    if (_isSyncing) {
      print('[SyncService] Sync already in progress. Aborting.');
      return;
    }

    _isSyncing = true;
    _syncStateController.add(SyncResult(SyncState.syncing));
    print('[SyncService] Starting sync process...');

    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception("No internet connection.");
      }

      final currentUserId = _authService.currentUser?.id;
      if (currentUserId == null) {
        throw Exception("No authenticated user found.");
      }

      final unsyncedOrders = await _orderRepository.getUnsyncedOrders();
      if (unsyncedOrders.isEmpty) {
        print('[SyncService] No unsynced orders to process.');
        _syncStateController.add(SyncResult(SyncState.idle));
        _isSyncing = false;
        return;
      }

      int successCount = 0;
      bool allSyncsSuccessful = true; // ✅ Fix: define this

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
              successCount++;
            }
          } else if (orderWithCloudPhotos.syncStatus ==
              SyncStatus.needsUpdate) {
            await _supabaseService.updateOrder(orderWithCloudPhotos);
            final updatedOrder = orderWithCloudPhotos.copyWith(
              syncStatus: SyncStatus.synced,
            );
            await _orderRepository.updateLocalOrder(updatedOrder);
            successCount++;
          }
        } catch (e, stackTrace) {
          allSyncsSuccessful = false;
          await Sentry.captureException(e, stackTrace: stackTrace);

          print('[SyncService] ERROR during sync process: $e');
          String errorMessage = "An unexpected error occurred.";
          if (e is PostgrestException) {
            errorMessage = "Database Error: ${e.message}";
          } else if (e is StorageException) {
            errorMessage = "Storage Error: ${e.message}";
          } else {
            errorMessage = e.toString().replaceFirst('Exception: ', '');
          }

          _syncStateController.add(
            SyncResult(
              SyncState.failure,
              message: "Sync failed: $errorMessage",
            ),
          );
        }
      }

      // ✅ Final result after loop
      if (successCount > 0 && allSyncsSuccessful) {
        _syncStateController.add(
          SyncResult(
            SyncState.success,
            message: "Sync complete! $successCount order(s) updated.",
          ),
        );
      } else if (!allSyncsSuccessful) {
        _syncStateController.add(
          SyncResult(SyncState.failure, message: "Some orders failed to sync."),
        );
      }
    } finally {
      _isSyncing = false;
      await Future.delayed(const Duration(seconds: 3));
      if (!_isSyncing) {
        _syncStateController.add(SyncResult(SyncState.idle));
      }
      print('[SyncService] Sync process finished.');
    }
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

    return hasChanges ? order.copyWith(photoPaths: cloudPhotoUrls) : order;
  }
}
