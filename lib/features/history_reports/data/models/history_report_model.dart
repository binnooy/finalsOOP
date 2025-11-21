import 'package:hive/hive.dart';
import '../../domain/entities/history_report_entity.dart';

part 'history_report_model.g.dart';

@HiveType(typeId: 4)
class HistoryReportModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String type; // 'income' or 'expense'

  @HiveField(6)
  final String notes;

  HistoryReportModel({
    required this.id,
    required this.description,
    required this.category,
    required this.amount,
    required this.date,
    required this.type,
    required this.notes,
  });

  /// Convert model to entity
  HistoryReportEntity toEntity() {
    return HistoryReportEntity(
      id: id,
      description: description,
      category: category,
      amount: amount,
      date: date,
      type: type,
      notes: notes,
    );
  }

  /// Create model from entity
  factory HistoryReportModel.fromEntity(HistoryReportEntity entity) {
    return HistoryReportModel(
      id: entity.id,
      description: entity.description,
      category: entity.category,
      amount: entity.amount,
      date: entity.date,
      type: entity.type,
      notes: entity.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HistoryReportModel &&
        other.id == id &&
        other.description == description &&
        other.category == category &&
        other.amount == amount &&
        other.date == date &&
        other.type == type &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        category.hashCode ^
        amount.hashCode ^
        date.hashCode ^
        type.hashCode ^
        notes.hashCode;
  }
}
