import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings_provider.dart';
import '../settings_service.dart';

class CurrencyTile extends ConsumerWidget {
  const CurrencyTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    final currencies = ref.watch(currenciesProvider);
    final currencyData = ref.watch(currencyDataProvider);
    final current = currencyData[currency];

    return ListTile(
      title: const Text('Currency'),
      subtitle: Text(current != null
          ? '${current['symbol']} ${current['name']}'
          : currency),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        _showCurrencyDialog(context, ref, currency, currencies, currencyData);
      },
    );
  }

  void _showCurrencyDialog(
    BuildContext context,
    WidgetRef ref,
    String currentCurrency,
    List<String> currencies,
    Map<String, Map<String, String>> currencyData,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Select Currency'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: currencies.map((currency) {
              final data = currencyData[currency];
              return RadioListTile<String>(
                title: Text('${data?['symbol']} ${data?['name']}'),
                subtitle: Text(currency),
                value: currency,
                groupValue: currentCurrency,
                onChanged: (value) async {
                  if (value != null) {
                    // Save to persistent storage
                    await SettingsService.setCurrency(value);
                    // Update the provider state
                    if (context.mounted) {
                      ref.read(currencyProvider.notifier).state = value;
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Currency changed to ${data?['name']}')),
                      );
                    }
                  }
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
