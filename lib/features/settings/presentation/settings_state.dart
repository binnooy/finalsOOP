class SettingsState {
  final String theme;
  final String currency;
  final bool isLoading;
  final Map<String, int>? stats;
  final String? errorMessage;

  const SettingsState({
    required this.theme,
    required this.currency,
    this.isLoading = false,
    this.stats,
    this.errorMessage,
  });

  SettingsState copyWith({
    String? theme,
    String? currency,
    bool? isLoading,
    Map<String, int>? stats,
    String? errorMessage,
  }) {
    return SettingsState(
      theme: theme ?? this.theme,
      currency: currency ?? this.currency,
      isLoading: isLoading ?? this.isLoading,
      stats: stats ?? this.stats,
      errorMessage: errorMessage,
    );
  }

  factory SettingsState.initial() =>
      const SettingsState(theme: 'system', currency: 'PHP');
}
