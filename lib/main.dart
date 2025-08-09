import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'app.dart';
import 'core/services/photo_service.dart';
import 'core/services/sync_service.dart';
import 'core/services/supabase_service.dart';
import 'data/repositories/database_repository.dart';
import 'data/repositories/order_repository.dart';

/// The main entry point for the application.
Future<void> main() async {
  // Ensure that Flutter's widget binding is initialized before any async operations.
  WidgetsFlutterBinding.ensureInitialized();

  // --- 1. INITIALIZE SUPABASE ---
  // This must be done before any other services are created.
  // Replace with your actual project URL and anon key from the Supabase dashboard.
  await Supabase.initialize(
    url: 'https://zvkdtoztbjambxiluvsw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp2a2R0b3p0YmphbWJ4aWx1dnN3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ3NjA4MjUsImV4cCI6MjA3MDMzNjgyNX0.wxbzHlGFWlWYsl3S0fiX5R1GhN0xN8jncaJYfa1nrMI',
  );

  // --- 2. CREATE INSTANCES OF ALL SERVICES AND REPOSITORIES ---

  // Get the application's private documents directory path to store the database.
  final docPath = (await getApplicationDocumentsDirectory()).path;

  // Low-level services and repositories with no dependencies
  final databaseRepository = DatabaseRepository(dbPath: docPath);
  await databaseRepository.init(); // IMPORTANT: Initialize the DB

  final supabaseService = SupabaseService();
  final photoService = PhotoService();
  final connectivity = Connectivity();

  // The SyncService and OrderRepository have a circular dependency:
  // OrderRepository needs SyncService to trigger syncs.
  // SyncService needs OrderRepository to get data to sync.
  // We solve this with a two-step initialization (setter injection).

  // Step A: Create SyncService with a temporary null repository.
  late SyncService syncService; // Declare it to be accessible later

  // Step B: Create OrderRepository, giving it the SyncService instance.
  final orderRepository = OrderRepository(
    databaseRepository,
    // The lambda function ensures SyncService is available when needed
    () => syncService,
  );

  // Step C: Now create the real SyncService, giving it the real OrderRepository.
  syncService = SyncService(
    orderRepository: orderRepository,
    supabaseService: supabaseService,
    connectivity: connectivity,
  );
  
  // --- 3. RUN THE APP WITH ALL REPOSITORIES PROVIDED ---
  runApp(
    // MultiRepositoryProvider makes singleton instances of our services
    // available to the entire widget tree.
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: databaseRepository),
        RepositoryProvider.value(value: orderRepository),
        RepositoryProvider.value(value: photoService),
        RepositoryProvider.value(value: supabaseService),
        RepositoryProvider.value(value: syncService),
        RepositoryProvider.value(value: connectivity),
      ],
      child: const MyApp(),
    ),
  );
}