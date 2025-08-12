import 'package:accurity/data/models/sync_status.enum.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/services/supabase_auth_service.dart';

import '../../../data/models/order.model.dart';
import '../../../data/repositories/order_repository.dart';

part 'order_list_event.dart';
part 'order_list_state.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  final OrderRepository _orderRepository;
  final SupabaseAuthService _authService;

  OrderListBloc({
    required OrderRepository orderRepository,
    required SupabaseAuthService authService,
  }) : _orderRepository = orderRepository,
       _authService = authService,
       super(OrderListInitial()) {
    on<FetchLocalOrders>(_onFetchLocalOrders);
    on<SyncOrdersFromServer>(_onSyncOrdersFromServer);
    on<LogoutButtonPressed>(_onLogoutButtonPressed);
  }

  /// Handles a fast refresh by only reading from the local SQLite database.
  Future<void> _onFetchLocalOrders(
    FetchLocalOrders event,
    Emitter<OrderListState> emit,
  ) async {
    // Only show a full-screen loader if the list isn't already loaded.
    if (state is! OrderListLoaded) {
      emit(OrderListLoading());
    }
    try {
      final orders = await _orderRepository.getAllOrders();
      final hasOfflineChanges = orders.any(
        (order) =>
            order.syncStatus == SyncStatus.localOnly ||
            order.syncStatus == SyncStatus.needsUpdate,
      );
      print('[OrderListBloc] Has offline changes: $hasOfflineChanges');

      emit(OrderListLoaded(orders, hasOfflineChanges: hasOfflineChanges));
    } catch (e) {
      emit(OrderListError('Failed to fetch local orders: ${e.toString()}'));
    }
  }

  /// Fetches orders from the server and updates the local database.
  Future<void> _onSyncOrdersFromServer(
    SyncOrdersFromServer event,
    Emitter<OrderListState> emit,
  ) async {
    // This is a background task, so we don't show a full-screen loader.
    // The SyncStatusIndicator will show that syncing is in progress.
    try {
      final userId = _authService.currentUser?.id;
      if (userId != null) {
        await _orderRepository.syncFromServer(userId);
      }
      // After syncing, trigger a local refresh to update the UI.
      add(FetchLocalOrders());
    } catch (e) {
      emit(OrderListError('Failed to sync from server: ${e.toString()}'));
    }
  }

  /// Clears local data and signs the user out.
  Future<void> _onLogoutButtonPressed(
    LogoutButtonPressed event,
    Emitter<OrderListState> emit,
  ) async {
    await _orderRepository.clearLocalData();
    await _authService.signOut();
  }
}
