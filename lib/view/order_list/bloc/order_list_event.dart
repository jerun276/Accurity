part of 'order_list_bloc.dart';

sealed class OrderListEvent extends Equatable {
  const OrderListEvent();

  @override
  List<Object> get props => [];
}

/// Event dispatched to fetch all orders from the repository.
final class FetchAllOrders extends OrderListEvent {}

final class LogoutButtonPressed extends OrderListEvent {}

