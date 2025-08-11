// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/services/photo_service.dart';
import '../../../data/models/order.model.dart';
import '../../../data/repositories/order_repository.dart';

part 'order_details_event.dart';
part 'order_details_state.dart';

class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  final OrderRepository _orderRepository;
  final PhotoService _photoService;

  OrderDetailsBloc({
    required OrderRepository orderRepository,
    required PhotoService photoService,
  }) : _orderRepository = orderRepository,
       _photoService = photoService,
       super(OrderDetailsInitial()) {
    on<LoadOrderDetails>(_onLoadOrderDetails);
    on<OrderFieldChanged>(_onFormFieldChanged);
    on<AddPhotoRequested>(_onAddPhotoRequested);
    on<SketchSaved>(_onSketchSaved);
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

  Future<void> _onFormFieldChanged(
    OrderFieldChanged event,
    Emitter<OrderDetailsState> emit,
  ) async {
    if (state is OrderDetailsLoaded) {
      final currentOrder = (state as OrderDetailsLoaded).order;
      final updatedOrder = _mapFieldChangeToOrder(
        currentOrder,
        event.fieldName,
        event.value,
      );
      emit(OrderDetailsLoaded(updatedOrder));
      await _orderRepository.saveOrder(updatedOrder);
    }
  }

  Future<void> _onAddPhotoRequested(
    AddPhotoRequested event,
    Emitter<OrderDetailsState> emit,
  ) async {
    if (state is OrderDetailsLoaded) {
      final currentOrder = (state as OrderDetailsLoaded).order;
      final newPhotoFile = await _photoService.pickAndCompressImage(
        source: event.source,
      );
      if (newPhotoFile == null) return;

      final updatedPhotoList = List<String>.from(currentOrder.photoPaths)
        ..add(newPhotoFile.path);
      final updatedOrder = currentOrder.copyWith(photoPaths: updatedPhotoList);

      emit(OrderDetailsLoaded(updatedOrder));
      await _orderRepository.saveOrder(updatedOrder);
    }
  }

  /// This helper function is now fully synced with the latest Order model.
  Order _mapFieldChangeToOrder(Order order, String fieldName, dynamic value) {
    switch (fieldName) {
      // --- Order Details ---
      case 'clientFileNumber':
        return order.copyWith(clientFileNumber: value);
      case 'firmFileNumber':
        return order.copyWith(firmFileNumber: value);
      case 'address':
        return order.copyWith(address: value);
      case 'applicantName':
        return order.copyWith(applicantName: value);
      case 'appointment':
        return order.copyWith(appointment: value);
      case 'client':
        return order.copyWith(client: value);
      case 'lender':
        return order.copyWith(lender: value);
      case 'serviceType':
        return order.copyWith(serviceType: value);
      case 'loanType':
        return order.copyWith(loanType: value);
      case 'contactName':
        return order.copyWith(contactName: value);
      case 'contactEmail':
        return order.copyWith(contactEmail: value);
      case 'contactPhone1':
        return order.copyWith(contactPhone1: value);
      case 'contactPhone2':
        return order.copyWith(contactPhone2: value);

      // --- Neighbourhood ---
      case 'natureOfDistrict':
        return order.copyWith(natureOfDistrict: value);
      case 'developmentType':
        return order.copyWith(developmentType: value);

      // --- Site ---
      case 'configuration':
        return order.copyWith(configuration: value);
      case 'topography':
        return order.copyWith(topography: value);
      case 'waterSupplyType':
        return order.copyWith(waterSupplyType: value);
      case 'streetscape':
        return order.copyWith(streetscape: value);
      case 'siteInfluence':
        return order.copyWith(siteInfluence: value);
      case 'siteImprovements':
        return order.copyWith(siteImprovements: value);
      case 'driveway':
        return order.copyWith(driveway: value);
      case 'parking':
        return order.copyWith(parking: value);
      case 'occupancy':
        return order.copyWith(occupancy: value);

      // --- Structural Details ---
      case 'builtInPast10Years':
        return order.copyWith(builtInPast10Years: value);
      case 'propertyType':
        return order.copyWith(propertyType: value);
      case 'designStyle':
        return order.copyWith(designStyle: value);
      case 'construction':
        return order.copyWith(construction: value);
      case 'sidingType':
        return order.copyWith(sidingType: value as List<String>);
      case 'roofType':
        return order.copyWith(roofType: value as List<String>);
      case 'windowType':
        return order.copyWith(windowType: value as List<String>);

      // --- Mechanical ---
      case 'heatingType':
        return order.copyWith(heatingType: value as List<String>);
      case 'electricalType':
        return order.copyWith(electricalType: value as List<String>);
      case 'waterType':
        return order.copyWith(waterType: value as List<String>);

      // --- Basement ---
      case 'basementType':
        return order.copyWith(basementType: value);
      case 'basementFinish':
        return order.copyWith(basementFinish: value);
      case 'foundationType':
        return order.copyWith(foundationType: value as List<String>);
      case 'basementRooms':
        return order.copyWith(basementRooms: value);
      case 'basementFeatures':
        return order.copyWith(basementFeatures: value as List<String>);
      case 'basementFlooring':
        return order.copyWith(basementFlooring: value);
      case 'basementCeilingType':
        return order.copyWith(basementCeilingType: value as List<String>);

      // --- Level Details ---
      case 'mainLevelRooms':
        return order.copyWith(mainLevelRooms: value);
      case 'mainLevelFeatures':
        return order.copyWith(mainLevelFeatures: value as List<String>);
      case 'mainLevelFlooring':
        return order.copyWith(mainLevelFlooring: value);
      case 'secondLevelRooms':
        return order.copyWith(secondLevelRooms: value);
      case 'secondLevelFeatures':
        return order.copyWith(secondLevelFeatures: value as List<String>);
      case 'secondLevelFlooring':
        return order.copyWith(secondLevelFlooring: value);
      case 'thirdLevelRooms':
        return order.copyWith(thirdLevelRooms: value);
      case 'thirdLevelFeatures':
        return order.copyWith(thirdLevelFeatures: value as List<String>);
      case 'thirdLevelFlooring':
        return order.copyWith(thirdLevelFlooring: value);
      case 'fourthLevelRooms':
        return order.copyWith(fourthLevelRooms: value);
      case 'fourthLevelFeatures':
        return order.copyWith(fourthLevelFeatures: value as List<String>);
      case 'fourthLevelFlooring':
        return order.copyWith(fourthLevelFlooring: value);

      // --- Component Age ---
      case 'roofAge':
        return order.copyWith(roofAge: value);
      case 'windowAge':
        return order.copyWith(windowAge: value);
      case 'furnaceAge':
        return order.copyWith(furnaceAge: value);
      case 'kitchenAge':
        return order.copyWith(kitchenAge: value);
      case 'bathAge':
        return order.copyWith(bathAge: value);

      // --- Notes ---
      case 'roofNotes':
        return order.copyWith(roofNotes: value);
      case 'windowNotes':
        return order.copyWith(windowNotes: value);
      case 'kitchenNotes':
        return order.copyWith(kitchenNotes: value);
      case 'bathNotes':
        return order.copyWith(bathNotes: value);
      case 'furnaceNotes':
        return order.copyWith(furnaceNotes: value);

      // --- Value Indicators ---
      case 'bankValue':
        return order.copyWith(bankValue: value);
      case 'ownerValue':
        return order.copyWith(ownerValue: value);
      case 'purchasePrice':
        return order.copyWith(purchasePrice: value);
      case 'purchaseDate':
        return order.copyWith(purchaseDate: value);

      default:
        print('Warning: Unhandled field name in OrderDetailsBloc: $fieldName');
        return order;
    }
  }

  Future<void> _onSketchSaved(
    SketchSaved event,
    Emitter<OrderDetailsState> emit,
  ) async {
    if (state is OrderDetailsLoaded) {
      final currentOrder = (state as OrderDetailsLoaded).order;

      // This logic is identical to adding a regular photo.
      final updatedPhotoList = List<String>.from(currentOrder.photoPaths)
        ..add(event.filePath);

      final updatedOrder = currentOrder.copyWith(photoPaths: updatedPhotoList);

      // Emit the new state to update the order object.
      emit(OrderDetailsLoaded(updatedOrder));

      // Automatically save the updated order to the local database.
      // The SyncService will find this new local path and upload it automatically.
      await _orderRepository.saveOrder(updatedOrder);
    }
  }
}
