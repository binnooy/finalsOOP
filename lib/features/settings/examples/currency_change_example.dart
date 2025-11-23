import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings_provider.dart';

/// Example widget showing how to detect and display currency changes
class CurrencyChangeExample extends ConsumerWidget {
  const CurrencyChangeExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current currency
    final currency = ref.watch(currencyProvider);
    final currencyData = ref.watch(currencyDataProvider);
    final currentData = currencyData[currency];
    final symbol = currentData?['symbol'] ?? '';
    final name = currentData?['name'] ?? '';

    // Listen for currency changes and perform actions
    ref.listen(currencyProvider, (previous, next) {
      if (previous != null && previous != next) {
        print('✅ Currency changed from $previous to $next');

        // You can perform actions here:
        // - Update transaction display
        // - Recalculate totals
        // - Refresh data

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Currency updated to: $next'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });

    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Currency',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      symbol,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Code: $currency',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Example transaction display that updates with currency
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListTile(
            title: const Text('Example Transaction'),
            trailing: Text('$symbol 1,000.00'),
            subtitle: Text('Paid in $name'),
          ),
        ),
      ],
    );
  }
}

/// Alternative: Use this in your Dashboard to show currency status
class CurrencyStatusBadge extends ConsumerWidget {
  const CurrencyStatusBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    final currencyData = ref.watch(currencyDataProvider);
    final symbol = currencyData[currency]?['symbol'] ?? '';

    return Chip(
      avatar: const Icon(Icons.attach_money, size: 18),
      label: Text('$symbol $currency'),
      backgroundColor: Colors.teal.shade100,
    );
  }
}

/// Example showing how to listen and perform calculations on currency change
class CurrencyAwareSummary extends ConsumerWidget {
  const CurrencyAwareSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    final currencyData = ref.watch(currencyDataProvider);
    final symbol = currencyData[currency]?['symbol'] ?? '';

    // Listen for changes to recalculate if needed
    ref.listen(currencyProvider, (previous, next) {
      if (previous != null && previous != next) {
        print('Recalculating totals for currency: $next');
        // Add your calculation logic here
      }
    });

    // Example data
    double income = 5000;
    double expense = 2000;
    double balance = income - expense;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Income:'),
                  Text('$symbol${income.toStringAsFixed(2)}'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Expense:'),
                  Text('$symbol${expense.toStringAsFixed(2)}'),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Balance:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    '$symbol${balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Currency: $currency',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
