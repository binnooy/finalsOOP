import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/history_report_entity.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_local_datasource.dart';
import '../models/history_report_model.dart';

/// Implementation of HistoryRepository with exception handling and Either wrapping
class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDataSource localDataSource;

  HistoryRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<HistoryReportEntity>>> getAllReports() async {
    try {
      final models = await localDataSource.getAllReports();
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(
        message: 'Failed to fetch all reports: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, HistoryReportEntity?>> getReportById(String id) async {
    try {
      final model = await localDataSource.getReportById(id);
      return Right(model?.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(
        message: 'Failed to fetch report by id: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, HistoryReportEntity>> addReport(
      HistoryReportEntity report) async {
    try {
      final model = HistoryReportModel.fromEntity(report);
      final addedModel = await localDataSource.addReport(model);
      return Right(addedModel.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(
        message: 'Failed to add report: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, HistoryReportEntity>> updateReport(
      HistoryReportEntity report) async {
    try {
      final model = HistoryReportModel.fromEntity(report);
      final updatedModel = await localDataSource.updateReport(model);
      return Right(updatedModel.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(
        message: 'Failed to update report: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReportById(String id) async {
    try {
      await localDataSource.deleteReportById(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(
        message: 'Failed to delete report: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllReports() async {
    try {
      await localDataSource.deleteAllReports();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(
        message: 'Failed to delete all reports: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<HistoryReportEntity>>> getReportsByCategory(
      String category) async {
    try {
      final models = await localDataSource.getReportsByCategory(category);
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(
        message: 'Failed to fetch reports by category: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<HistoryReportEntity>>> getReportsByType(
      String type) async {
    try {
      final models = await localDataSource.getReportsByType(type);
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(
        message: 'Failed to fetch reports by type: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<HistoryReportEntity>>> getReportsByDateRange(
      DateTime start, DateTime end) async {
    try {
      final models = await localDataSource.getReportsByDateRange(start, end);
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(
        message: 'Failed to fetch reports by date range: ${e.toString()}',
      ));
    }
  }
}
