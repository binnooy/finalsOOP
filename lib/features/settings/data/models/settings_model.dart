import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/settings_entity.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 10)
class SettingsModel extends HiveObject {
  @HiveField(0)
  final String theme;

  @HiveField(1)
  final String currency;

  SettingsModel({required this.theme, required this.currency});

  factory SettingsModel.fromEntity(SettingsEntity entity) {
    return SettingsModel(theme: entity.theme, currency: entity.currency);
  }

  SettingsEntity toEntity() {
    return SettingsEntity(theme: theme, currency: currency);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettingsModel &&
        other.theme == theme &&
        other.currency == currency;
  }

  @override
  int get hashCode => Object.hash(theme, currency);
}
