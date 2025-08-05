import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/order.model.dart';
import '../../../data/repositories/order_repository.dart';

part 'order_list_event.dart';
part 'order_list_state.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  final OrderRepository _orderRepository;

  OrderListBloc({required OrderRepository orderRepository})
    : _orderRepository = orderRepository,
      super(OrderListInitial()) {
    on<FetchAllOrders>(_onFetchAllOrders);
  }

  Future<void> _onFetchAllOrders(
    FetchAllOrders event,
    Emitter<OrderListState> emit,
  ) async {
    emit(OrderListLoading());
    try {
      final orders = await _orderRepository.getAllOrders();
      emit(OrderListLoaded(orders));
    } catch (e) {
      emit(OrderListError('Failed to fetch orders: ${e.toString()}'));
    }
  }
}
