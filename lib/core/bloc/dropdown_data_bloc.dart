// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/dropdown_item.model.dart';
import '../../data/repositories/database_repository.dart';

part 'dropdown_data_state.dart';
part 'dropdown_data_event.dart';

class DropdownDataBloc extends Bloc<DropdownDataEvent, DropdownDataState> {
  final DatabaseRepository _databaseRepository;

  DropdownDataBloc({required DatabaseRepository databaseRepository})
    : _databaseRepository = databaseRepository,
      super(DropdownDataInitial()) {
    on<FetchDropdownData>(_onFetchDropdownData);
  }

  Future<void> _onFetchDropdownData(
    FetchDropdownData event,
    Emitter<DropdownDataState> emit,
  ) async {
    emit(DropdownDataLoading());
    try {
      final items = await _databaseRepository.getDropdownItems(event.category);
      emit(DropdownDataLoaded(items));
    } catch (e) {
      emit(DropdownDataError(e.toString()));
    }
  }
}
