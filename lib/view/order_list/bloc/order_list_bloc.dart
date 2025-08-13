import 'dart:async';
import 'package:accurity/data/models/sync_state.enum.dart';
import 'package:accurity/data/models/sync_status.enum.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/services/supabase_auth_service.dart';
import '../../../data/models/order.model.dart';
import '../../../data/repositories/order_repository.dart';
import '../../../core/services/sync_service.dart';

part 'order_list_event.dart';
part 'order_list_state.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  final OrderRepository _orderRepository;
  final SupabaseAuthService _authService;
  final SyncService _syncService;
  late final StreamSubscription _syncStatusSubscription;

  OrderListBloc({
    required OrderRepository orderRepository,
    required SupabaseAuthService authService,
    required SyncService syncService,
  }) : _orderRepository = orderRepository,
       _authService = authService,
       _syncService = syncService,
       super(OrderListInitial()) {
    on<FetchLocalOrders>(_onFetchLocalOrders);
    on<SyncOrdersFromServer>(_onSyncOrdersFromServer);
    on<LogoutButtonPressed>(_onLogoutButtonPressed);
    on<OrderDeleted>(_onOrderDeleted);

    _syncStatusSubscription = _syncService.syncStateStream.listen((syncResult) {
      if (syncResult.state == SyncState.success ||
          syncResult.state == SyncState.failure) {
        add(FetchLocalOrders());
      }
    });
  }

  @override
  Future<void> close() {
    _syncStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onFetchLocalOrders(
    FetchLocalOrders event,
    Emitter<OrderListState> emit,
  ) async {
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

  Future<void> _onSyncOrdersFromServer(
    SyncOrdersFromServer event,
    Emitter<OrderListState> emit,
  ) async {
    try {
      final userId = _authService.currentUser?.id;
      if (userId != null) {
        await _orderRepository.syncFromServer(userId);
      }
      add(FetchLocalOrders());
    } catch (e) {
      emit(OrderListError('Failed to sync from server: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutButtonPressed(
    LogoutButtonPressed event,
    Emitter<OrderListState> emit,
  ) async {
    await _orderRepository.clearLocalData();
    await _authService.signOut();
  }

  Future<void> _onOrderDeleted(
    OrderDeleted event,
    Emitter<OrderListState> emit,
  ) async {
    try {
    await _orderRepository.deleteOrder(event.localId, event.supabaseId);
      add(FetchLocalOrders());
    } catch (e) {
      emit(OrderListError('Failed to delete order: ${e.toString()}'));
    }
  }
}
