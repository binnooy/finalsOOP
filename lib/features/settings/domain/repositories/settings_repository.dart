import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/settings_entity.dart';

abstract class SettingsRepository {
  /// Save theme preference
  Future<Either<Failure, void>> setTheme(String theme);

  /// Save currency preference
  Future<Either<Failure, void>> setCurrency(String currency);

  /// Get current theme
  Future<Either<Failure, String>> getTheme();

  /// Get current currency
  Future<Either<Failure, String>> getCurrency();

  /// Get both preferences
  Future<Either<Failure, SettingsEntity>> getSettings();

  /// Get data statistics (transactions and categories counts)
  Future<Either<Failure, Map<String, int>>> getDataStatistics();
}
