import 'package:hive_flutter/hive_flutter.dart';

class SettingsService {
  static const String _settingsBoxName = 'settings';

  /// Save theme preference
  static Future<void> setTheme(String theme) async {
    final box = Hive.box(_settingsBoxName);
    await box.put('theme', theme);
  }

  /// Save currency preference
  static Future<void> setCurrency(String currency) async {
    final box = Hive.box(_settingsBoxName);
    await box.put('currency', currency);
  }

  /// Get current theme
  static String getTheme() {
    try {
      final box = Hive.box(_settingsBoxName);
      return box.get('theme', defaultValue: 'system') as String;
    } catch (e) {
      return 'system';
    }
  }

  /// Get current currency
  static String getCurrency() {
    try {
      final box = Hive.box(_settingsBoxName);
      return box.get('currency', defaultValue: 'PHP') as String;
    } catch (e) {
      return 'PHP';
    }
  }

  /// Get data statistics
  static Map<String, int> getDataStatistics() {
    try {
      final transactionsBox = Hive.box('transactions');
      final categoriesBox = Hive.box('categories');

      return {
        'transactions': transactionsBox.length,
        'categories': categoriesBox.length,
      };
    } catch (e) {
      return {
        'transactions': 0,
        'categories': 0,
      };
    }
  }
}
