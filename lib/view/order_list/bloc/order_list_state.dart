part of 'order_list_bloc.dart';

sealed class OrderListState extends Equatable {
  const OrderListState();

  @override
  List<Object> get props => [];
}

/// Initial state, before any orders are fetched.
final class OrderListInitial extends OrderListState {}

/// State while the list of orders is being fetched from the database.
final class OrderListLoading extends OrderListState {}

/// State representing that the orders have been successfully loaded.
final class OrderListLoaded extends OrderListState {
  final List<Order> orders;

  const OrderListLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

/// State indicating an error occurred while fetching orders.
final class OrderListError extends OrderListState {
  final String message;

  const OrderListError(this.message);

  @override
  List<Object> get props => [message];
}
