part of 'order_details_bloc.dart';

sealed class OrderDetailsState extends Equatable {
  const OrderDetailsState();

  @override
  List<Object?> get props => [];
}

/// Initial state, before any order is loaded.
final class OrderDetailsInitial extends OrderDetailsState {}

/// State while the order is being fetched from the database.
final class OrderDetailsLoading extends OrderDetailsState {}

/// The primary state, indicating the order data has been successfully loaded.
final class OrderDetailsLoaded extends OrderDetailsState {
  final Order order;

  const OrderDetailsLoaded(this.order);

  @override
  List<Object?> get props => [order];
}

/// State indicating an error occurred while loading the order.
final class OrderDetailsError extends OrderDetailsState {
  final String message;

  const OrderDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
