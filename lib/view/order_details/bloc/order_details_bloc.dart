import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/order.model.dart';
import '../../../data/repositories/order_repository.dart';

part 'order_details_event.dart';
part 'order_details_state.dart';

class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  final OrderRepository _orderRepository;

  OrderDetailsBloc({required OrderRepository orderRepository})
    : _orderRepository = orderRepository,
      super(OrderDetailsInitial()) {
    on<LoadOrderDetails>(_onLoadOrderDetails);
    on<OrderFieldChanged>(_onFormFieldChanged);
  }

  Future<void> _onLoadOrderDetails(
    LoadOrderDetails event,
    Emitter<OrderDetailsState> emit,
  ) async {
    emit(OrderDetailsLoading());
    try {
      final order = await _orderRepository.getOrder(event.localId);
      emit(OrderDetailsLoaded(order));
    } catch (e) {
      emit(OrderDetailsError('Failed to load order: ${e.toString()}'));
    }
  }

  /// This handler is the core of the "automatic save" feature.
  Future<void> _onFormFieldChanged(
    OrderFieldChanged event,
    Emitter<OrderDetailsState> emit,
  ) async {
    if (state is OrderDetailsLoaded) {
      final currentOrder = (state as OrderDetailsLoaded).order;

      // Use a switch to create a new Order object with the updated field.
      // The `copyWith` method from our model is essential here.
      final updatedOrder = _mapFieldChangeToOrder(
        currentOrder,
        event.fieldName,
        event.value,
      );

      // Emit the new state immediately so the UI updates without any lag.
      emit(OrderDetailsLoaded(updatedOrder));

      // Asynchronously save the updated order to the local database.
      await _orderRepository.saveOrder(updatedOrder);
    }
  }

  /// A helper function to map a field name string to the correct `copyWith` parameter.
  Order _mapFieldChangeToOrder(Order order, String fieldName, dynamic value) {
    switch (fieldName) {
      // --- Neighbourhood ---
      case 'natureOfDistrict':
        return order.copyWith(natureOfDistrict: value as String?);
      case 'developmentType':
        return order.copyWith(developmentType: value as String?);
      case 'isGatedCommunity':
        return order.copyWith(isGatedCommunity: value as bool?);

      // --- Site ---
      case 'configuration':
        return order.copyWith(configuration: value as String?);
      case 'topography':
        return order.copyWith(topography: value as String?);
      case 'waterSupplyType':
        return order.copyWith(waterSupplyType: value as String?);
      case 'isSepticWell':
        return order.copyWith(isSepticWell: value as bool?);
      case 'streetscape':
        return order.copyWith(streetscape: value as List<String>?);

      // ... ADD A CASE FOR EVERY SINGLE FIELD FROM YOUR ORDER MODEL ...

      default:
        // If the field name doesn't match, return the original order.
        // You might want to add logging here for debugging.
        print('Warning: Unhandled field name in OrderDetailsBloc: $fieldName');
        return order;
    }
  }
}
