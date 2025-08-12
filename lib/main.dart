import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart'; // Import Sentry

import 'app.dart';
import 'core/bloc/feedback_bloc.dart';
import 'core/services/photo_service.dart';
import 'core/services/sync_service.dart';
import 'core/services/supabase_auth_service.dart';
import 'core/services/supabase_service.dart';
import 'core/services/supabase_storage_service.dart';
import 'core/services/photo_cache_service.dart';
import 'data/repositories/database_repository.dart';
import 'data/repositories/order_repository.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://0b4ee3733e8c002c57ec55444d08549d@o4509830320029696.ingest.us.sentry.io/4509830351880192';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Supabase.initialize(
        url: 'https://zvkdtoztbjambxiluvsw.supabase.co',
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp2a2R0b3p0YmphbWJ4aWx1dnN3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ3NjA4MjUsImV4cCI6MjA3MDMzNjgyNX0.wxbzHlGFWlWYsl3S0fiX5R1GhN0xN8jncaJYfa1nrMI',
      );

      // --- 1. AUTHENTICATION FIRST ---
      final supabaseAuthService = SupabaseAuthService();
      await supabaseAuthService.initialize();

      // --- 2. CREATE ALL OTHER SERVICES AND REPOSITORIES ---
      final docPath = (await getApplicationDocumentsDirectory()).path;
      final databaseRepository = DatabaseRepository(dbPath: docPath);
      await databaseRepository.init();

      final supabaseService = SupabaseService();
      final photoService = PhotoService();
      final connectivity = Connectivity();
      final supabaseStorageService = SupabaseStorageService();
      final photoCacheService = PhotoCacheService();

      // --- 3. SOLVE THE CIRCULAR DEPENDENCY ---
      final orderRepository = OrderRepository(
        databaseRepository,
        supabaseService,
        photoCacheService,
      );

      final syncService = SyncService(
        orderRepository: orderRepository,
        supabaseService: supabaseService,
        supabaseStorageService: supabaseStorageService,
        authService: supabaseAuthService,
        connectivity: connectivity,
      );

      // --- 4. CREATE THE GLOBAL BLOC ---
      final feedbackBloc = FeedbackBloc(syncService: syncService);

      // --- 5. RUN THE APP ---
      runApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: databaseRepository),
            RepositoryProvider.value(value: orderRepository),
            RepositoryProvider.value(value: photoService),
            RepositoryProvider.value(value: supabaseService),
            RepositoryProvider.value(value: syncService),
            RepositoryProvider.value(value: connectivity),
            RepositoryProvider.value(value: supabaseStorageService),
            RepositoryProvider.value(value: supabaseAuthService),
            RepositoryProvider.value(value: photoCacheService),
          ],
          child: MultiBlocProvider(
            providers: [BlocProvider.value(value: feedbackBloc)],
            child: const MyApp(),
          ),
        ),
      );
    },
  );
}
