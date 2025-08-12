import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/sync_result.model.dart';
import '../../data/models/sync_state.enum.dart';
import '../services/sync_service.dart';

class SyncStatusIndicator extends StatelessWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    // Read the single instance of the SyncService provided in main.dart
    final syncService = context.read<SyncService>();

    return StreamBuilder<SyncResult>(
      stream: syncService.syncStateStream,
      initialData: SyncResult(SyncState.idle),
      builder: (context, snapshot) {
        final state = snapshot.data?.state ?? SyncState.idle;

        Widget iconWidget;
        switch (state) {
          case SyncState.syncing:
            iconWidget = const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.0,
                ),
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
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: iconWidget,
        );
      },
    );
  }
}
