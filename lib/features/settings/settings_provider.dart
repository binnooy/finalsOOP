import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Provider for theme preference (light/dark/system)
final themeProvider = StateProvider<String>((ref) {
  try {
    final settingsBox = Hive.box('settings');
    return settingsBox.get('theme', defaultValue: 'system') as String;
  } catch (e) {
    return 'system';
  }
});

/// Provider for currency preference
final currencyProvider = StateProvider<String>((ref) {
  try {
    final settingsBox = Hive.box('settings');
    return settingsBox.get('currency', defaultValue: 'PHP') as String;
  } catch (e) {
    return 'PHP';
  }
});

/// Currency data with symbols and locales
final currencyDataProvider = Provider<Map<String, Map<String, String>>>((ref) {
  return {
    'USD': {'symbol': '\$', 'name': 'US Dollar', 'locale': 'en_US'},
    'EUR': {'symbol': '€', 'name': 'Euro', 'locale': 'en_IE'},
    'GBP': {'symbol': '£', 'name': 'British Pound', 'locale': 'en_GB'},
    'JPY': {'symbol': '¥', 'name': 'Japanese Yen', 'locale': 'ja_JP'},
    'AUD': {'symbol': 'A\$', 'name': 'Australian Dollar', 'locale': 'en_AU'},
    'CAD': {'symbol': 'C\$', 'name': 'Canadian Dollar', 'locale': 'en_CA'},
    'CHF': {'symbol': 'CHF', 'name': 'Swiss Franc', 'locale': 'de_CH'},
    'CNY': {'symbol': '¥', 'name': 'Chinese Yuan', 'locale': 'zh_CN'},
    'INR': {'symbol': '₹', 'name': 'Indian Rupee', 'locale': 'en_IN'},
    'AED': {'symbol': 'د.إ', 'name': 'UAE Dirham', 'locale': 'ar_AE'},
    'SAR': {'symbol': '﷼', 'name': 'Saudi Riyal', 'locale': 'ar_SA'},
    'PHP': {'symbol': '₱', 'name': 'Philippine Peso', 'locale': 'en_PH'},
  };
});

/// Available currencies
final currenciesProvider = Provider<List<String>>((ref) {
  return [
    'PHP',
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'AUD',
    'CAD',
    'CHF',
    'CNY',
    'INR',
    'AED',
    'SAR',
  ];
});

/// Available themes
final themesProvider = Provider<Map<String, String>>((ref) {
  return {
    'system': 'System',
    'light': 'Light',
    'dark': 'Dark',
  };
});

/// App version
final appVersionProvider = Provider<String>((ref) {
  return '1.0.0';
});

/// App name
final appNameProvider = Provider<String>((ref) {
  return 'Offline Expense Tracker';
});
