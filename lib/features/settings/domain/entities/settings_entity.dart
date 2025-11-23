class SettingsEntity {
  final String theme;
  final String currency;

  SettingsEntity({required this.theme, required this.currency});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettingsEntity &&
        other.theme == theme &&
        other.currency == currency;
  }

  @override
  int get hashCode => Object.hash(theme, currency);
}
