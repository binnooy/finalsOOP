import '../models/history_report_model.dart';

/// Abstract interface for local history/reports data source
abstract class HistoryLocalDataSource {
  /// Get all history reports from local storage
  Future<List<HistoryReportModel>> getAllReports();

  /// Get a single report by ID
  Future<HistoryReportModel?> getReportById(String id);

  /// Add a new report to local storage
  Future<HistoryReportModel> addReport(HistoryReportModel report);

  /// Update an existing report
  Future<HistoryReportModel> updateReport(HistoryReportModel report);

  /// Delete a report by ID
  Future<void> deleteReportById(String id);

  /// Delete all reports
  Future<void> deleteAllReports();

  /// Get reports filtered by category
  Future<List<HistoryReportModel>> getReportsByCategory(String category);

  /// Get reports filtered by type
  Future<List<HistoryReportModel>> getReportsByType(String type);

  /// Get reports within a date range
  Future<List<HistoryReportModel>> getReportsByDateRange(
      DateTime start, DateTime end);
}
