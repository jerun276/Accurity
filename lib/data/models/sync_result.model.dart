import 'sync_state.enum.dart'; // We will still use our enum

/// A model to represent the result of a synchronization operation.
class SyncResult {
  final SyncState state;
  final String? message; // An optional message for success or failure

  SyncResult(this.state, {this.message});
}