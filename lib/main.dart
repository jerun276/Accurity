import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
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
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp2a2R0b3p0YmphbWJ4aWx1dnN3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ3NjA4MjUsImV4cCI6MjA3MDMzNjgyNX0.wxbzHlGFWlWYsl3S0fiX5R1GhN0xN8jncaJYfa1nrMI',
  );
  // REMOVED the direct call to signInAnonymously() from here.
  final docPath = (await getApplicationDocumentsDirectory()).path;
  final databaseRepository = DatabaseRepository(dbPath: docPath);
  await databaseRepository.init();
  final supabaseService = SupabaseService();
  final photoService = PhotoService();
  final connectivity = Connectivity();
  final supabaseStorageService = SupabaseStorageService();
  final supabaseAuthService = SupabaseAuthService(); // ADDED
  late SyncService syncService;
  final orderRepository = OrderRepository(
    databaseRepository,
    () => syncService,
  );
  syncService = SyncService(
    orderRepository: orderRepository,
    supabaseService: supabaseService,
    supabaseStorageService: supabaseStorageService,
    authService: supabaseAuthService, // ADDED
    connectivity: connectivity,
  );
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
        RepositoryProvider.value(value: supabaseAuthService), // ADDED
      ],
      child: const MyApp(),
    ),
  );
}
