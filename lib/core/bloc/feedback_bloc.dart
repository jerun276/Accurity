import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../view/order_list/bloc/order_list_bloc.dart';
import '../../data/models/sync_result.model.dart';
import '../../data/models/sync_state.enum.dart';
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
  final OrderListBloc _orderListBloc;
  late final StreamSubscription _syncSubscription;

  FeedbackBloc({
    required SyncService syncService,
    required OrderListBloc orderListBloc,
  }) : _syncService = syncService,
       _orderListBloc = orderListBloc,
       super(FeedbackInitial()) {
    _syncSubscription = _syncService.syncStateStream.listen((syncResult) {
      add(syncResult);
    });

    on<SyncResult>((event, emit) {
      if (event.state == SyncState.success) {
        if (event.message != null) {
          emit(ShowFeedbackSnackbar(event.message!));
        }
        _orderListBloc.add(FetchLocalOrders());
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
