import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/add_transaction_entity.dart';

part 'add_transaction_model.g.dart';

@HiveType(typeId: 2)
enum TransactionTypeModel {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 3)
class AddTransactionModel extends HiveObject {
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
  late TransactionTypeModel type;

  @HiveField(6)
  late String notes;

  AddTransactionModel({
    String? id,
    required this.description,
    required this.category,
    required this.amount,
    required this.date,
    required this.type,
    required this.notes,
  }) {
    this.id = id ?? const Uuid().v4();
  }

  AddTransactionModel.empty() {
    id = '';
    description = '';
    category = '';
    amount = 0.0;
    date = DateTime.now();
    type = TransactionTypeModel.expense;
    notes = '';
  }

  // Convert to Entity
  AddTransactionEntity toEntity() {
    return AddTransactionEntity(
      id: id,
      description: description,
      category: category,
      amount: amount,
      date: date,
      type: type.toString().split('.').last,
      notes: notes,
    );
  }

  // Convert from Entity
  factory AddTransactionModel.fromEntity(AddTransactionEntity entity) {
    return AddTransactionModel(
      id: entity.id,
      description: entity.description,
      category: entity.category,
      amount: entity.amount,
      date: entity.date,
      type: entity.type == 'income'
          ? TransactionTypeModel.income
          : TransactionTypeModel.expense,
      notes: entity.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddTransactionModel &&
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
