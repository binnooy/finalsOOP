import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/history_report_entity.dart';

/// Abstract repository interface for history/reports feature
abstract class HistoryRepository {
  /// Get all history reports
  Future<Either<Failure, List<HistoryReportEntity>>> getAllReports();

  /// Get a single report by ID
  Future<Either<Failure, HistoryReportEntity?>> getReportById(String id);

  /// Add a new report
  Future<Either<Failure, HistoryReportEntity>> addReport(
      HistoryReportEntity report);

  /// Update an existing report
  Future<Either<Failure, HistoryReportEntity>> updateReport(
      HistoryReportEntity report);

  /// Delete a report by ID
  Future<Either<Failure, void>> deleteReportById(String id);

  /// Delete all reports
  Future<Either<Failure, void>> deleteAllReports();

  /// Get reports filtered by category
  Future<Either<Failure, List<HistoryReportEntity>>> getReportsByCategory(
      String category);

  /// Get reports filtered by type
  Future<Either<Failure, List<HistoryReportEntity>>> getReportsByType(
      String type);

  /// Get reports within a date range
  Future<Either<Failure, List<HistoryReportEntity>>> getReportsByDateRange(
      DateTime start, DateTime end);
}
