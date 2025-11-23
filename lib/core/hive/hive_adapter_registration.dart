import 'package:hive_flutter/hive_flutter.dart';
import '../../models/transaction.dart';
import '../../services/category_service.dart';
import '../../services/transaction_service.dart';
import '../../features/add_transaction/data/models/add_transaction_model.dart';
import '../../features/history_reports/data/models/history_report_model.dart';
import '../../features/settings/data/models/settings_model.dart';

/// Central place to register all Hive adapters
Future<void> registerHiveAdapters() async {
  // Register existing adapters
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionModelAdapter());

  // Register AddTransaction adapters
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(AddTransactionModelAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(TransactionTypeModelAdapter());
  }

  // Register HistoryReport adapters
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(HistoryReportModelAdapter());
  }

  // Register Settings adapter
  if (!Hive.isAdapterRegistered(10)) {
    Hive.registerAdapter(SettingsModelAdapter());
  }
}

/// Initialize Hive with all boxes
Future<void> initializeHive() async {
  await Hive.initFlutter();
  await registerHiveAdapters();

  // Open the transactions box
  await Hive.openBox<TransactionModel>('transactions');

  // Open AddTransaction boxes
  if (!Hive.isBoxOpen('addTransactions')) {
    await Hive.openBox<AddTransactionModel>('addTransactions');
  }
  if (!Hive.isBoxOpen('categories')) {
    await Hive.openBox<String>('categories');
  }

  // Open settings box for app preferences
  if (!Hive.isBoxOpen('settings')) {
    await Hive.openBox('settings');
  }

  // Add default categories if box is empty
  final categoriesBox = Hive.box<String>('categories');
  if (categoriesBox.isEmpty) {
    final defaults = [
      'Food',
      'Transport',
      'Entertainment',
      'Bills',
      'Health',
      'Shopping',
      'Salary',
      'Freelance',
      'Other',
    ];
    for (var category in defaults) {
      await categoriesBox.add(category);
    }
  }

  // Initialize category service
  await CategoryService().initBox();

  // Initialize transaction service with sample data if needed
  await TransactionService().initBox();
}

/// Close all Hive boxes
Future<void> closeHive() async {
  await Hive.close();
}
