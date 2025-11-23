import '../models/settings_model.dart';

abstract class SettingsLocalDataSource {
  /// Save theme preference
  /// Throws [Exception] on failure
  Future<void> setTheme(String theme);

  /// Save currency preference
  /// Throws [Exception] on failure
  Future<void> setCurrency(String currency);

  /// Get current theme
  /// Throws [Exception] on failure
  Future<String> getTheme();

  /// Get current currency
  /// Throws [Exception] on failure
  Future<String> getCurrency();

  /// Get both preferences as model
  /// Throws [Exception] on failure
  Future<SettingsModel> getSettings();

  /// Get data statistics (transactions and categories counts)
  /// Throws [Exception] on failure
  Future<Map<String, int>> getDataStatistics();
}
