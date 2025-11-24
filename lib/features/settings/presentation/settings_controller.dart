import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/repositories/settings_repository.dart';
import '../domain/entities/settings_entity.dart';
import '../../../../core/error/failure.dart';
import 'settings_state.dart';

class SettingsController extends StateNotifier<SettingsState> {
  final SettingsRepository repository;

  SettingsController(this.repository) : super(SettingsState.initial()) {
    // load initial settings
    load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final settingsResult = await repository.getSettings();
    final statsResult = await repository.getDataStatistics();

    settingsResult.fold((Failure f) {
      state = state.copyWith(isLoading: false, errorMessage: f.message);
    }, (SettingsEntity settings) {
      statsResult.fold((Failure f) {
        state = state.copyWith(
            isLoading: false,
            theme: settings.theme,
            currency: settings.currency,
            errorMessage: f.message);
      }, (Map<String, int> stats) {
        state = state.copyWith(
            isLoading: false,
            theme: settings.theme,
            currency: settings.currency,
            stats: stats);
      });
    });
  }

  Future<void> setTheme(String theme) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final res = await repository.setTheme(theme);
    res.fold((Failure f) {
      state = state.copyWith(isLoading: false, errorMessage: f.message);
    }, (_) {
      state = state.copyWith(isLoading: false, theme: theme);
    });
  }

  Future<void> setCurrency(String currency) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final res = await repository.setCurrency(currency);
    res.fold((Failure f) {
      state = state.copyWith(isLoading: false, errorMessage: f.message);
    }, (_) {
      state = state.copyWith(isLoading: false, currency: currency);
    });
  }
}
