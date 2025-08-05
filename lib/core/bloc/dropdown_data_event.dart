part of 'dropdown_data_bloc.dart';

sealed class DropdownDataEvent extends Equatable {
  const DropdownDataEvent();
  @override
  List<Object> get props => [];
}

class FetchDropdownData extends DropdownDataEvent {
  final String category;
  const FetchDropdownData(this.category);
  @override
  List<Object> get props => [category];
}
