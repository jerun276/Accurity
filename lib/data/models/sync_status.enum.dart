/// Represents the synchronization status of a local record
/// with the cloud database (e.g., Supabase).
enum SyncStatus {
  /// The record is successfully saved on both the local DB and the cloud.
  /// It is up-to-date.
  synced,

  /// The record was created locally while the device was offline.
  /// It has not yet been pushed to the cloud and needs a CREATE operation.
  localOnly,

  /// The record was modified locally while the device was offline.
  /// It exists on the cloud but the local version is newer.
  /// It needs an UPDATE operation.
  needsUpdate,
}
