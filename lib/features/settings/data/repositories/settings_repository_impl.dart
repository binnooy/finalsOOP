import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';
import '../models/settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> setTheme(String theme) async {
    try {
      await localDataSource.setTheme(theme);
      return const Right(null);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setCurrency(String currency) async {
    try {
      await localDataSource.setCurrency(currency);
      return const Right(null);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getTheme() async {
    try {
      final theme = await localDataSource.getTheme();
      return Right(theme);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getCurrency() async {
    try {
      final currency = await localDataSource.getCurrency();
      return Right(currency);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SettingsEntity>> getSettings() async {
    try {
      final model = await localDataSource.getSettings();
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getDataStatistics() async {
    try {
      final stats = await localDataSource.getDataStatistics();
      return Right(stats);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }
}
