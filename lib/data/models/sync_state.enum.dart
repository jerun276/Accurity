/// Represents the different states of the background synchronization service.
enum SyncState {
  /// The service is not currently syncing.
  idle,

  /// The service is actively communicating with the cloud.
  syncing,

  /// The last sync operation completed successfully.
  success,

  /// The last sync operation failed.
  failure,
}
