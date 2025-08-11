import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'app.dart';
import 'core/bloc/feedback_bloc.dart';
import 'core/services/photo_service.dart';
import 'core/services/sync_service.dart';
import 'core/services/supabase_auth_service.dart';
import 'core/services/supabase_service.dart';
import 'core/services/supabase_storage_service.dart';
import 'data/repositories/database_repository.dart';
import 'data/repositories/order_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zvkdtoztbjambxiluvsw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp2a2R0b3p0YmphbWJ4aWx1dnN3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ3NjA4MjUsImV4cCI6MjA3MDMzNjgyNX0.wxbzHlGFWlWYsl3S0fiX5R1GhN0xN8jncaJYfa1nrMI',
  );

  // --- 1. CREATE ALL SERVICE AND REPOSITORY INSTANCES ---
  final docPath = (await getApplicationDocumentsDirectory()).path;
  final databaseRepository = DatabaseRepository(dbPath: docPath);
  await databaseRepository.init();

  final supabaseAuthService = SupabaseAuthService();
  await supabaseAuthService.initialize(); // Ensure user session is ready

  final supabaseService = SupabaseService();
  final photoService = PhotoService();
  final connectivity = Connectivity();
  final supabaseStorageService = SupabaseStorageService();

  // --- 2. SOLVE THE CIRCULAR DEPENDENCY ---
  // Step A: Create the OrderRepository first. It needs a SyncService,
  //         but we can't create that yet. So we create it without one for now.
  final orderRepository = OrderRepository(databaseRepository, supabaseService);

  // Step B: Now create the SyncService. It depends on the OrderRepository,
  //         which is now fully created and available.
  final syncService = SyncService(
    orderRepository: orderRepository,
    supabaseService: supabaseService,
    supabaseStorageService: supabaseStorageService,
    authService: supabaseAuthService,
    connectivity: connectivity,
  );

  // Step C: Now that the SyncService exists, inject it back into the
  //         OrderRepository.
  orderRepository.setSyncService(syncService);

  // --- 3. CREATE THE GLOBAL BLOC ---
  final feedbackBloc = FeedbackBloc(syncService: syncService);

  // --- 4. RUN THE APP WITH ALL DEPENDENCIES PROVIDED ---
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
      ],
      child: MultiBlocProvider(
        providers: [BlocProvider.value(value: feedbackBloc)],
        child: const MyApp(),
      ),
    ),
  );
}
