import 'dart:convert';
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

  /// Export all data as JSON string
  static Future<String> exportDataAsJson() async {
    try {
      // Access the box with correct type
      final transactionsBox = Hive.box<dynamic>('transactions');
      final categoriesBox = Hive.box<dynamic>('categories');

      // Convert transactions to JSON-serializable maps
      final List<Map<String, dynamic>> transactionsList = [];
      for (var transaction in transactionsBox.values) {
        try {
          if (transaction is Map) {
            transactionsList.add(Map<String, dynamic>.from(transaction));
          } else {
            // Call toJson() method if available
            transactionsList.add(transaction.toJson());
          }
        } catch (e) {
          // Skip problematic transactions
          print('Error converting transaction: $e');
          continue;
        }
      }

      // Get categories - they're stored as strings
      final categoriesList = categoriesBox.values.toList();

      final exportData = {
        'version': '1.0.0',
        'exportedAt': DateTime.now().toIso8601String(),
        'dataCount': {
          'transactions': transactionsList.length,
          'categories': categoriesList.length,
        },
        'transactions': transactionsList,
        'categories': categoriesList,
      };

      // Verify the data can be JSON encoded
      final jsonString = jsonEncode(exportData);
      print('Export successful: ${jsonString.length} bytes');
      return jsonString;
    } catch (e) {
      print('Export error: $e');
      rethrow;
    }
  }

  /// Clear all data from the app
  static Future<void> clearAllData() async {
    try {
      final transactionsBox = Hive.box('transactions');
      final categoriesBox = Hive.box('categories');

      await transactionsBox.clear();
      await categoriesBox.clear();
    } catch (e) {
      throw Exception('Failed to clear data: $e');
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
