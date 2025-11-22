import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/settings/settings_provider.dart';

/// Helper class to format amounts with the selected currency symbol
class CurrencyFormatter {
  /// Get the currency symbol for the currently selected currency
  /// Usage in ConsumerWidget: final symbol = CurrencyFormatter.getSymbol(ref);
  static String getSymbol(WidgetRef ref) {
    final currencyCode = ref.watch(currencyProvider);
    final currencyData = ref.watch(currencyDataProvider);
    return currencyData[currencyCode]?['symbol'] ?? '₱';
  }

  /// Format an amount with the selected currency symbol
  /// Usage: CurrencyFormatter.format(ref, 1234.56) => "₱1,234.56"
  static String format(WidgetRef ref, double amount) {
    final symbol = getSymbol(ref);
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  /// Format with sign (+ for income, - for expenses)
  /// Usage: CurrencyFormatter.formatSigned(ref, 1234.56, true) => "+₱1,234.56"
  static String formatSigned(WidgetRef ref, double amount, bool isIncome) {
    final formatted = format(ref, amount);
    return isIncome ? '+$formatted' : formatted;
  }

  /// Get currency name
  /// Usage: CurrencyFormatter.getCurrencyName(ref) => "Philippine Peso"
  static String getCurrencyName(WidgetRef ref) {
    final currencyCode = ref.watch(currencyProvider);
    final currencyData = ref.watch(currencyDataProvider);
    return currencyData[currencyCode]?['name'] ?? 'Philippine Peso';
  }

  /// Get full currency display (symbol + code)
  /// Usage: CurrencyFormatter.getFullCurrency(ref) => "₱ PHP"
  static String getFullCurrency(WidgetRef ref) {
    final currencyCode = ref.watch(currencyProvider);
    final symbol = getSymbol(ref);
    return '$symbol $currencyCode';
  }
}
