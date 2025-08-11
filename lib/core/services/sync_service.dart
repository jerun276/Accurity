import 'dart:async';
import 'dart:io';
import 'package:accurity/data/models/sync_result.model.dart';
import 'package:accurity/data/models/sync_state.enum.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

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

  final _syncStateController = StreamController<SyncResult>.broadcast();
  Stream<SyncResult> get syncStateStream => _syncStateController.stream;

  // --- THE CRITICAL FIX: The Syncing Lock ---
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

  Future<void> syncUnsyncedOrders() async {
    // 1. Check the lock. If a sync is already running, exit immediately.
    if (_isSyncing) {
      print('[SyncService] Sync is already in progress. Aborting new request.');
      return;
    }

    // 2. Acquire the lock and announce that we are starting.
    _isSyncing = true;
    _syncStateController.add(SyncResult(SyncState.syncing));

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
        _syncStateController.add(SyncResult(SyncState.idle));
        return; // No work to do, exit early.
      }

      print('[SyncService] Found ${unsyncedOrders.length} orders to sync.');
      int successCount = 0;

      for (var order in unsyncedOrders) {
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
        } else if (orderWithCloudPhotos.syncStatus == SyncStatus.needsUpdate) {
          await _supabaseService.updateOrder(orderWithCloudPhotos);
          final updatedOrder = orderWithCloudPhotos.copyWith(
            syncStatus: SyncStatus.synced,
          );
          await _orderRepository.updateLocalOrder(updatedOrder);
          successCount++;
        }
      }

      if (successCount > 0) {
        _syncStateController.add(
          SyncResult(
            SyncState.success,
            message: "Sync complete! $successCount order(s) updated.",
          ),
        );
      }
    } catch (e) {
      print('[SyncService] ERROR during sync process: $e');
      String errorMessage = "An unexpected error occurred.";
      if (e is PostgrestException) {
        errorMessage = "Database Error: ${e.message}";
      }
      if (e is StorageException) errorMessage = "Storage Error: ${e.message}";
      if (e is Exception) errorMessage = e.toString();
      _syncStateController.add(
        SyncResult(SyncState.failure, message: "Sync failed. $errorMessage"),
      );
    } finally {
      // 3. ALWAYS release the lock, whether the sync succeeded or failed.
      _isSyncing = false;
      await Future.delayed(const Duration(seconds: 3));
      _syncStateController.add(SyncResult(SyncState.idle));
      print('[SyncService] Sync process finished.');
    }
  }

  Future<Order> _uploadOrderPhotos(Order order) async {
    // ... This helper method remains the same ...
    if (order.photoPaths.isEmpty) return order;
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
          final publicUrl = await _supabaseStorageService.uploadImage(
            file,
            fileName,
          );
          cloudPhotoUrls.add(publicUrl);
        }
      }
    }
    return hasChanges ? order.copyWith(photoPaths: cloudPhotoUrls) : order;
  }
}
