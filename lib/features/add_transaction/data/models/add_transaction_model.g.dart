// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddTransactionModelAdapter extends TypeAdapter<AddTransactionModel> {
  @override
  final int typeId = 3;

  @override
  AddTransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddTransactionModel(
      id: fields[0] as String?,
      description: fields[1] as String,
      category: fields[2] as String,
      amount: fields[3] as double,
      date: fields[4] as DateTime,
      type: fields[5] as TransactionTypeModel,
      notes: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AddTransactionModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddTransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionTypeModelAdapter extends TypeAdapter<TransactionTypeModel> {
  @override
  final int typeId = 2;

  @override
  TransactionTypeModel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionTypeModel.income;
      case 1:
        return TransactionTypeModel.expense;
      default:
        return TransactionTypeModel.income;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionTypeModel obj) {
    switch (obj) {
      case TransactionTypeModel.income:
        writer.writeByte(0);
        break;
      case TransactionTypeModel.expense:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
