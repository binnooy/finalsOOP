import 'package:hive_flutter/hive_flutter.dart';
import '../../models/transaction.dart';

/// Central place to register all Hive adapters
Future<void> registerHiveAdapters() async {
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionModelAdapter());
}

/// Initialize Hive with all boxes
Future<void> initializeHive() async {
  await Hive.initFlutter();
  await registerHiveAdapters();
  
  // Open the transactions box
  await Hive.openBox<TransactionModel>('transactions');
}

/// Close all Hive boxes
Future<void> closeHive() async {
  await Hive.close();
}
