import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings_provider.dart';
import '../settings_service.dart';

/// DEBUG WIDGET - Use this to test all settings features
class SettingsDebugPanel extends ConsumerStatefulWidget {
  const SettingsDebugPanel({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsDebugPanel> createState() => _SettingsDebugPanelState();
}

class _SettingsDebugPanelState extends ConsumerState<SettingsDebugPanel> {
  String? _lastMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🔧 SETTINGS DEBUG PANEL',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Test 1: Currency Change
              _buildTestSection(
                title: '1️⃣ TEST CURRENCY CHANGE',
                buttons: [
                  ElevatedButton(
                    onPressed: _testCurrencyToUSD,
                    child: const Text('Change to USD'),
                  ),
                  ElevatedButton(
                    onPressed: _testCurrencyToEUR,
                    child: const Text('Change to EUR'),
                  ),
                  ElevatedButton(
                    onPressed: _testCurrencyToPHP,
                    child: const Text('Change to PHP'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Test 2: Export Data
              _buildTestSection(
                title: '2️⃣ TEST EXPORT DATA',
                buttons: [
                  ElevatedButton(
                    onPressed: _testExportData,
                    child: const Text('Export Data as JSON'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Test 3: Clear Data
              _buildTestSection(
                title: '3️⃣ TEST CLEAR DATA',
                buttons: [
                  ElevatedButton(
                    onPressed: _testClearData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Clear All Data'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Test 4: Check Current Values
              _buildTestSection(
                title: '4️⃣ CHECK CURRENT VALUES',
                buttons: [
                  ElevatedButton(
                    onPressed: _checkCurrentValues,
                    child: const Text('Check All Values'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Status Message
              if (_lastMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  child: Text(
                    _lastMessage!,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestSection({
    required String title,
    required List<Widget> buttons,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: buttons,
        ),
      ],
    );
  }

  Future<void> _testCurrencyToUSD() async {
    try {
      print('🔄 Changing currency to USD...');
      await SettingsService.setCurrency('USD');
      ref.read(currencyProvider.notifier).state = 'USD';

      // Verify it was saved
      String saved = SettingsService.getCurrency();
      print('✅ Currency saved: $saved');

      setState(() {
        _lastMessage =
            '✅ SUCCESS: Currency changed to USD\nSaved value: $saved';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Currency changed to USD'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('❌ Error: $e');
      setState(() {
        _lastMessage = '❌ ERROR: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _testCurrencyToEUR() async {
    try {
      print('🔄 Changing currency to EUR...');
      await SettingsService.setCurrency('EUR');
      ref.read(currencyProvider.notifier).state = 'EUR';

      String saved = SettingsService.getCurrency();
      print('✅ Currency saved: $saved');

      setState(() {
        _lastMessage =
            '✅ SUCCESS: Currency changed to EUR\nSaved value: $saved';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Currency changed to EUR'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('❌ Error: $e');
      setState(() {
        _lastMessage = '❌ ERROR: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _testCurrencyToPHP() async {
    try {
      print('🔄 Changing currency to PHP...');
      await SettingsService.setCurrency('PHP');
      ref.read(currencyProvider.notifier).state = 'PHP';

      String saved = SettingsService.getCurrency();
      print('✅ Currency saved: $saved');

      setState(() {
        _lastMessage =
            '✅ SUCCESS: Currency changed to PHP\nSaved value: $saved';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Currency changed to PHP'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('❌ Error: $e');
      setState(() {
        _lastMessage = '❌ ERROR: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _testExportData() async {
    try {
      print('📤 Exporting data...');
      final jsonData = await SettingsService.exportDataAsJson();
      print('✅ Data exported successfully');
      print('📋 Data:\n$jsonData');

      setState(() {
        _lastMessage =
            '✅ SUCCESS: Data exported\n\nLength: ${jsonData.length} chars\n\n$jsonData';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Data exported to clipboard'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('❌ Error exporting: $e');
      setState(() {
        _lastMessage = '❌ ERROR: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _testClearData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Really clear all data?'),
        content: const Text('This cannot be undone!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child:
                const Text('Yes, Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      print('🗑️ Clearing all data...');
      await SettingsService.clearAllData();
      print('✅ All data cleared');

      var stats = SettingsService.getDataStatistics();
      print('📊 Stats after clear: $stats');

      setState(() {
        _lastMessage = '✅ SUCCESS: All data cleared\n\nStats: $stats';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ All data cleared successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('❌ Error clearing: $e');
      setState(() {
        _lastMessage = '❌ ERROR: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _checkCurrentValues() {
    try {
      final currentCurrency = SettingsService.getCurrency();
      final currentTheme = SettingsService.getTheme();
      final stats = SettingsService.getDataStatistics();

      print('═══ CURRENT VALUES ═══');
      print('💱 Currency: $currentCurrency');
      print('🎨 Theme: $currentTheme');
      print('📊 Data Stats: $stats');
      print('═════════════════════');

      setState(() {
        _lastMessage = '''✅ CURRENT VALUES:
💱 Currency: $currentCurrency
🎨 Theme: $currentTheme
📊 Transactions: ${stats['transactions']}
📊 Categories: ${stats['categories']}''';
      });
    } catch (e) {
      print('❌ Error: $e');
      setState(() {
        _lastMessage = '❌ ERROR: $e';
      });
    }
  }
}
