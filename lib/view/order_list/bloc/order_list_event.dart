part of 'order_list_bloc.dart';

sealed class OrderListEvent extends Equatable {
  const OrderListEvent();
  @override
  List<Object> get props => [];
}

/// Fetches orders ONLY from the local database to refresh the UI.
final class FetchLocalOrders extends OrderListEvent {}

/// Fetches orders from the server and updates the local database.
final class SyncOrdersFromServer extends OrderListEvent {}

/// Dispatches a logout request.
final class LogoutButtonPressed extends OrderListEvent {}

final class OrderDeleted extends OrderListEvent {
  final int localId;
  final String? supabaseId;
  const OrderDeleted({required this.localId, this.supabaseId});
}
