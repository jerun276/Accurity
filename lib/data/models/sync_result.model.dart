import 'sync_state.enum.dart';

class SyncResult {
  final SyncState state;
  final String? message;

  SyncResult(this.state, {this.message});
}
