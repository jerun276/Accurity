import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'core/services/photo_service.dart';
import 'data/repositories/database_repository.dart';
import 'data/repositories/order_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final docPath = (await getApplicationDocumentsDirectory()).path;

  // --- INSTANCES ARE CREATED HERE ---
  final databaseRepository = DatabaseRepository(dbPath: docPath);
  await databaseRepository.init();

  final orderRepository = OrderRepository(databaseRepository);
  final photoService = PhotoService();

  runApp(
    // --- PROVIDE ALL NECESSARY SINGLETONS HERE ---
    MultiRepositoryProvider(
      providers: [
        // THE FIX: Provide the DatabaseRepository so other services/blocs can access it.
        RepositoryProvider.value(value: databaseRepository),

        // The other providers remain the same.
        RepositoryProvider.value(value: orderRepository),
        RepositoryProvider.value(value: photoService),
      ],
      child: const MyApp(),
    ),
  );
}
