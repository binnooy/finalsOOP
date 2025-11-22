import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/hive/hive_adapter_registration.dart';
import 'features/settings/settings_provider.dart';
import 'screens/dashboard.dart';
import 'screens/add_transaction.dart';
import 'screens/settings.dart';
import 'screens/categories.dart';
import 'screens/history_reports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive with all adapters and boxes
  await initializeHive();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Offline Expense Tracker',
      themeMode: _getThemeMode(themeMode),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const DashboardScreen(),
      routes: {
        '/add': (context) => const AddTransactionScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/categories': (context) => const CategoriesScreen(),
        '/history': (context) => const HistoryReportsScreen(),
      },
    );
  }

  ThemeMode _getThemeMode(String theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
