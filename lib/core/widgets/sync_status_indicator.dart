import 'package:accurity/data/models/sync_result.model.dart';
import 'package:accurity/data/models/sync_state.enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/sync_service.dart';

class SyncStatusIndicator extends StatelessWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    // Find the single instance of the SyncService
    final syncService = context.read<SyncService>();

    return StreamBuilder<SyncResult>(
      stream: syncService.syncStateStream,
      // We create an initial SyncResult object with an idle state.
      initialData: SyncResult(SyncState.idle),
      builder: (context, snapshot) {
        // We get the state from the SyncResult object.
        final state = snapshot.data?.state ?? SyncState.idle;

        switch (state) {
          case SyncState.syncing:
            return const Padding(
              padding: EdgeInsets.all(12.0),
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              ),
            );
          case SyncState.success:
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.check_circle, color: Colors.greenAccent),
            );
          case SyncState.failure:
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.error, color: Colors.orangeAccent),
            );
          case SyncState.idle:
          return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.cloud_done_outlined, color: Colors.white70),
            );
        }
      },
    );
  }
}
