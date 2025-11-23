import 'package:hive_flutter/hive_flutter.dart';
import '../models/settings_model.dart';
import 'settings_local_datasource.dart';

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String settingsBox = 'settings';

  @override
  Future<void> setTheme(String theme) async {
    try {
      final box = Hive.box(settingsBox);
      await box.put('theme', theme);
    } on HiveError catch (e) {
      throw Exception('Failed to save theme: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error saving theme: $e');
    }
  }

  @override
  Future<void> setCurrency(String currency) async {
    try {
      final box = Hive.box(settingsBox);
      await box.put('currency', currency);
    } on HiveError catch (e) {
      throw Exception('Failed to save currency: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error saving currency: $e');
    }
  }

  @override
  Future<String> getTheme() async {
    try {
      final box = Hive.box(settingsBox);
      return box.get('theme', defaultValue: 'system') as String;
    } on HiveError catch (e) {
      throw Exception('Failed to get theme: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting theme: $e');
    }
  }

  @override
  Future<String> getCurrency() async {
    try {
      final box = Hive.box(settingsBox);
      return box.get('currency', defaultValue: 'PHP') as String;
    } on HiveError catch (e) {
      throw Exception('Failed to get currency: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting currency: $e');
    }
  }

  @override
  Future<SettingsModel> getSettings() async {
    try {
      final theme = await getTheme();
      final currency = await getCurrency();
      return SettingsModel(theme: theme, currency: currency);
    } on Exception catch (e) {
      throw Exception('Failed to get settings: $e');
    }
  }

  @override
  Future<Map<String, int>> getDataStatistics() async {
    try {
      final transactionsBox = Hive.box('transactions');
      final categoriesBox = Hive.box('categories');

      return {
        'transactions': transactionsBox.length,
        'categories': categoriesBox.length,
      };
    } on HiveError catch (e) {
      throw Exception('Failed to get statistics: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting statistics: $e');
    }
  }
}
