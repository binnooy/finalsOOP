import 'package:flutter/material.dart';
import 'core/hive/hive_adapter_registration.dart';
import 'screens/dashboard.dart';
import 'screens/add_transaction.dart';
import 'screens/settings.dart';
import 'screens/categories.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive with all adapters and boxes
  await initializeHive();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
      routes: {
        '/add': (context) => const AddTransactionScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/categories': (context) => const CategoriesScreen(),
      },
    );
  }
}
