import 'package:hive_flutter/hive_flutter.dart';
import '../models/history_report_model.dart';
import 'history_local_datasource.dart';

/// Implementation of HistoryLocalDataSource using Hive
class HistoryLocalDataSourceImpl implements HistoryLocalDataSource {
  static const String boxName = 'history_reports';

  /// Get or open the Hive box
  Future<Box<HistoryReportModel>> _getBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<HistoryReportModel>(boxName);
    }
    return Hive.box<HistoryReportModel>(boxName);
  }

  @override
  Future<List<HistoryReportModel>> getAllReports() async {
    try {
      final box = await _getBox();
      return box.values.toList();
    } catch (e) {
      throw Exception('Failed to fetch all reports: $e');
    }
  }

  @override
  Future<HistoryReportModel?> getReportById(String id) async {
    try {
      final box = await _getBox();
      for (var report in box.values) {
        if (report.id == id) {
          return report;
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch report by id: $e');
    }
  }

  @override
  Future<HistoryReportModel> addReport(HistoryReportModel report) async {
    try {
      final box = await _getBox();
      await box.add(report);
      return report;
    } catch (e) {
      throw Exception('Failed to add report: $e');
    }
  }

  @override
  Future<HistoryReportModel> updateReport(HistoryReportModel report) async {
    try {
      final box = await _getBox();
      for (int i = 0; i < box.length; i++) {
        if (box.getAt(i)?.id == report.id) {
          await box.putAt(i, report);
          return report;
        }
      }
      throw Exception('Report not found for update');
    } catch (e) {
      throw Exception('Failed to update report: $e');
    }
  }

  @override
  Future<void> deleteReportById(String id) async {
    try {
      final box = await _getBox();
      for (int i = 0; i < box.length; i++) {
        if (box.getAt(i)?.id == id) {
          await box.deleteAt(i);
          return;
        }
      }
      throw Exception('Report not found for deletion');
    } catch (e) {
      throw Exception('Failed to delete report: $e');
    }
  }

  @override
  Future<void> deleteAllReports() async {
    try {
      final box = await _getBox();
      await box.clear();
    } catch (e) {
      throw Exception('Failed to delete all reports: $e');
    }
  }

  @override
  Future<List<HistoryReportModel>> getReportsByCategory(String category) async {
    try {
      final box = await _getBox();
      return box.values.where((report) => report.category == category).toList();
    } catch (e) {
      throw Exception('Failed to fetch reports by category: $e');
    }
  }

  @override
  Future<List<HistoryReportModel>> getReportsByType(String type) async {
    try {
      final box = await _getBox();
      return box.values.where((report) => report.type == type).toList();
    } catch (e) {
      throw Exception('Failed to fetch reports by type: $e');
    }
  }

  @override
  Future<List<HistoryReportModel>> getReportsByDateRange(
      DateTime start, DateTime end) async {
    try {
      final box = await _getBox();
      return box.values
          .where((report) =>
              report.date.isAfter(start.subtract(const Duration(days: 1))) &&
              report.date.isBefore(end.add(const Duration(days: 1))))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch reports by date range: $e');
    }
  }
}
