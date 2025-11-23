import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings_provider.dart';
import '../settings_service.dart';

/// Working Debug Tests for Settings Features
/// Add this to your Settings screen to test all features
class SettingsFeatureTests extends ConsumerStatefulWidget {
  const SettingsFeatureTests({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsFeatureTests> createState() =>
      _SettingsFeatureTestsState();
}

class _SettingsFeatureTestsState extends ConsumerState<SettingsFeatureTests> {
  String _status = 'Ready to test...';

  void _showStatus(String message) {
    setState(() => _status = message);
    print(message);
  }

  Future<void> _testCurrencyUSD() async {
    try {
      _showStatus('Testing: Changing to USD...');
      await SettingsService.setCurrency('USD');
      ref.read(currencyProvider.notifier).state = 'USD';
      String saved = SettingsService.getCurrency();
      _showStatus('SUCCESS: Currency changed to $saved');
    } catch (e) {
      _showStatus('ERROR: $e');
    }
  }

  Future<void> _testCurrencyPHP() async {
    try {
      _showStatus('Testing: Changing to PHP...');
      await SettingsService.setCurrency('PHP');
      ref.read(currencyProvider.notifier).state = 'PHP';
      String saved = SettingsService.getCurrency();
      _showStatus('SUCCESS: Currency changed to $saved');
    } catch (e) {
      _showStatus('ERROR: $e');
    }
  }

  Future<void> _testExportData() async {
    // Export functionality removed
    _showStatus('Export functionality has been removed');
  }

  Future<void> _testGetStats() async {
    try {
      _showStatus('Testing: Getting statistics...');
      final stats = SettingsService.getDataStatistics();
      _showStatus(
          'SUCCESS: Transactions: ${stats['transactions']}, Categories: ${stats['categories']}');
    } catch (e) {
      _showStatus('ERROR: $e');
    }
  }

  Future<void> _testClearData() async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Clear ALL data?'),
            content: const Text('This will delete everything!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('YES DELETE',
                    style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    // Clear functionality removed
    _showStatus('Clear functionality has been removed');
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyProvider);

    return Column(
      children: [
        Container(
          color: Colors.blue.shade100,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FEATURE TESTS',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Current Currency: $currency'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const Text('Test 1: Currency Change'),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _testCurrencyUSD,
                      child: const Text('USD'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _testCurrencyPHP,
                      child: const Text('PHP'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Test 2: Stats'),
              Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _testGetStats,
                      child: const Text('Get Stats'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Test 3: Clear Data'),
              ElevatedButton(
                onPressed: _testClearData,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('CLEAR ALL'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Status:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(_status, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
