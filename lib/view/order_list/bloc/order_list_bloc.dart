import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    on<FetchAllOrders>(_onFetchAllOrders);
    on<LogoutButtonPressed>(_onLogoutButtonPressed); // <-- ADD HANDLER
  }

  Future<void> _onFetchAllOrders(
    FetchAllOrders event,
    Emitter<OrderListState> emit,
  ) async {
    emit(OrderListLoading());
    try {
      // 1. First, sync the latest data from the server for the current user.
      final userId = _authService.currentUser?.id;
      if (userId != null) {
        await _orderRepository.syncFromServer(userId);
      }

      // 2. Then, fetch all orders from the now-updated local database.
      final orders = await _orderRepository.getAllOrders();
      emit(OrderListLoaded(orders));
    } catch (e) {
      emit(OrderListError('Failed to fetch orders: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutButtonPressed(
    LogoutButtonPressed event,
    Emitter<OrderListState> emit,
  ) async {
    await _orderRepository.clearLocalData();
    await _authService.signOut();
  }
}
