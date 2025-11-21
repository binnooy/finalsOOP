// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_report_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryReportModelAdapter extends TypeAdapter<HistoryReportModel> {
  @override
  final int typeId = 4;

  @override
  HistoryReportModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryReportModel(
      id: fields[0] as String,
      description: fields[1] as String,
      category: fields[2] as String,
      amount: fields[3] as double,
      date: fields[4] as DateTime,
      type: fields[5] as String,
      notes: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryReportModel obj) {
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
      other is HistoryReportModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
