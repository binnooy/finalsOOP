enum TransactionType { income, expense }

class TransactionEntity {
  final String id;
  final String description;
  final String category;
  final double amount;
  final DateTime date;
  final TransactionType type;

  TransactionEntity({
    required this.id,
    required this.description,
    required this.category,
    required this.amount,
    required this.date,
    required this.type,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionEntity &&
        other.id == id &&
        other.description == description &&
        other.category == category &&
        other.amount == amount &&
        other.date == date &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        category.hashCode ^
        amount.hashCode ^
        date.hashCode ^
        type.hashCode;
  }
}
