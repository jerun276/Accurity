import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart'; // <-- FIX #1: IMPORT ADDED

import 'app.dart';
import 'core/services/photo_service.dart'; // <-- FIX #2: IMPORT ADDED
import 'data/repositories/database_repository.dart';
import 'data/repositories/order_repository.dart';

/// The main entry point for the application.
Future<void> main() async {
  // Ensure that Flutter's widget binding is initialized before any async operations.
  WidgetsFlutterBinding.ensureInitialized();

  // --- REPOSITORIES & SERVICES SETUP ---

  // Get the application's private documents directory path to store the database.
  final docPath = (await getApplicationDocumentsDirectory()).path;

  // 1. Initialize the lowest-level repository: the DatabaseRepository.
  //    The `init()` call creates the DB file, tables, and seeds dropdown data.
  final databaseRepository = DatabaseRepository(dbPath: docPath);
  await databaseRepository.init();

  // 2. Initialize the higher-level repositories and services that depend on others.
  final orderRepository = OrderRepository(databaseRepository);
  final photoService = PhotoService(); // This will now work correctly

  // 3. Run the main application widget.
  runApp(
    // Use MultiRepositoryProvider to make singleton instances of our repositories
    // and services available to the entire widget tree. Any BLoC can now
    // easily access them using `context.read<OrderRepository>()`.
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: orderRepository),
        RepositoryProvider.value(value: photoService),
      ],
      child: const MyApp(),
    ),
  );
}
