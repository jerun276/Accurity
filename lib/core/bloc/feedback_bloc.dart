import 'dart:async';
import 'package:accurity/data/models/sync_result.model.dart';
import 'package:accurity/data/models/sync_state.enum.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../services/sync_service.dart';

// --- STATE ---
abstract class FeedbackState extends Equatable {
  const FeedbackState();
  @override
  List<Object> get props => [];
}

class FeedbackInitial extends FeedbackState {}

class ShowFeedbackSnackbar extends FeedbackState {
  final String message;
  final bool isError;
  const ShowFeedbackSnackbar(this.message, {this.isError = false});
  @override
  List<Object> get props => [message, isError];
}

// --- BLOC ---
class FeedbackBloc extends Bloc<SyncResult, FeedbackState> {
  final SyncService _syncService;
  late final StreamSubscription _syncSubscription;

  FeedbackBloc({required SyncService syncService})
    : _syncService = syncService,
      super(FeedbackInitial()) {
    // Listen to the SyncService stream and add the results as events to this BLoC
    _syncSubscription = _syncService.syncStateStream.listen((syncResult) {
      add(syncResult);
    });

    on<SyncResult>((event, emit) {
      if (event.state == SyncState.success && event.message != null) {
        emit(ShowFeedbackSnackbar(event.message!));
      } else if (event.state == SyncState.failure && event.message != null) {
        emit(ShowFeedbackSnackbar(event.message!, isError: true));
      }
    });
  }

  @override
  Future<void> close() {
    _syncSubscription.cancel();
    return super.close();
  }
}
