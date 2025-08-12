import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/sync_result.model.dart';
import '../../data/models/sync_state.enum.dart';
import '../services/sync_service.dart';

class SyncStatusIndicator extends StatelessWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final syncService = context.read<SyncService>();

    return StreamBuilder<SyncResult>(
      stream: syncService.syncStateStream,
      initialData: SyncResult(SyncState.idle),
      builder: (context, snapshot) {
        final state = snapshot.data?.state ?? SyncState.idle;
        final bool isSyncing = state == SyncState.syncing;

        Widget iconWidget;
        switch (state) {
          case SyncState.syncing:
            iconWidget = const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.0,
              ),
            );
            break;
          case SyncState.success:
            iconWidget = const Icon(
              Icons.check_circle,
              color: Colors.greenAccent,
            );
            break;
          case SyncState.failure:
            iconWidget = const Icon(Icons.error, color: Colors.orangeAccent);
            break;
          case SyncState.idle:
            iconWidget = const Icon(
              Icons.cloud_done_outlined,
              color: Colors.white70,
            );
            break;
        }
        return Tooltip(
          message: isSyncing
              ? 'Sync in progress...'
              : 'Tap to sync local changes',
          child: InkWell(
            onTap: isSyncing
                ? null
                : () {
                    print(
                      '[SyncStatusIndicator] Tapped. Triggering manual sync.',
                    );
                    syncService.syncUnsyncedOrders();
                  },
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: iconWidget,
            ),
          ),
        );
      },
    );
  }
}
