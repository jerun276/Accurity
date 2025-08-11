part of 'order_details_bloc.dart';

sealed class OrderDetailsEvent extends Equatable {
  const OrderDetailsEvent();
  @override
  List<Object?> get props => [];
}

/// Event to fetch the order from the database when the view is first opened.
class LoadOrderDetails extends OrderDetailsEvent {
  final int localId;
  const LoadOrderDetails(this.localId);

  @override
  List<Object?> get props => [localId];
}

/// A generic event to handle a change in any form field across all sections.
/// This is the key to the automatic save feature.
class OrderFieldChanged extends OrderDetailsEvent {
  final String fieldName;
  final dynamic value;

  const OrderFieldChanged({required this.fieldName, this.value});

  @override
  List<Object?> get props => [fieldName, value];
}

class AddPhotoRequested extends OrderDetailsEvent {
  final ImageSource source;
  const AddPhotoRequested({required this.source});

  @override
  List<Object?> get props => [source];
}

class SketchSaved extends OrderDetailsEvent {
  final String filePath;
  const SketchSaved({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}
