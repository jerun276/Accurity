part of 'dropdown_data_bloc.dart';

sealed class DropdownDataState extends Equatable {
  const DropdownDataState();
  @override
  List<Object> get props => [];
}

final class DropdownDataInitial extends DropdownDataState {}
final class DropdownDataLoading extends DropdownDataState {}

final class DropdownDataLoaded extends DropdownDataState {
  final List<DropdownItem> items;
  const DropdownDataLoaded(this.items);
  @override
  List<Object> get props => [items];
}

final class DropdownDataError extends DropdownDataState {
  final String message;
  const DropdownDataError(this.message);
  @override
  List<Object> get props => [message];
}
