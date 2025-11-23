import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late String category;

  @HiveField(3)
  late double amount;

  @HiveField(4)
  late DateTime date;

  @HiveField(5)
  late TransactionType type;

  @HiveField(6)
  late String notes;

  TransactionModel({
    String? id,
    required this.description,
    required this.category,
    required this.amount,
    required this.date,
    required this.type,
    String? notes,
  }) {
    this.id = id ?? const Uuid().v4();
    this.notes = notes ?? '';
  }

  TransactionModel.empty() {
    id = '';
    description = '';
    category = '';
    amount = 0.0;
    date = DateTime.now();
    type = TransactionType.expense;
    notes = '';
  }

  /// Convert to JSON-serializable map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.toString().split('.').last,
      'notes': notes,
    };
  }

  /// Create from JSON map
  factory TransactionModel.fromJson(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String?,
      description: map['description'] as String? ?? '',
      category: map['category'] as String? ?? '',
      amount: (map['amount'] is num) ? (map['amount'] as num).toDouble() : 0.0,
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      type: (map['type'] as String? ?? 'expense') == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      notes: map['notes'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionModel &&
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
