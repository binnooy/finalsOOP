class AddTransactionEntity {
  final String? id;
  final String description;
  final String category;
  final double amount;
  final DateTime date;
  final String type; // 'income' or 'expense'
  final String notes;

  AddTransactionEntity({
    this.id,
    required this.description,
    required this.category,
    required this.amount,
    required this.date,
    required this.type,
    required this.notes,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddTransactionEntity &&
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
