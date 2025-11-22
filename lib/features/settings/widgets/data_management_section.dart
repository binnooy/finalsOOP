import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../settings_service.dart';

class DataManagementSection extends StatelessWidget {
  const DataManagementSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.backup),
          title: const Text('Backup & Export Data'),
          subtitle: const Text('Export all data as JSON'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _handleExportData(context),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.delete_outline, color: Colors.red),
          title: const Text('Clear All Data'),
          subtitle: const Text('Delete all transactions and categories'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _handleClearData(context),
        ),
      ],
    );
  }

  Future<void> _handleExportData(BuildContext context) async {
    try {
      final jsonData = await SettingsService.exportDataAsJson();

      print('Export data: $jsonData');

      // Show the data in a dialog
      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exported Data'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: SingleChildScrollView(
              child: SelectableText(
                jsonData,
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                _copyToClipboard(context, jsonData);
              },
              child: const Text('Copy'),
            ),
          ],
        ),
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data exported successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Export error: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data copied to clipboard successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error copying: $e'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  Future<void> _handleClearData(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This action will delete all transactions and categories. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await SettingsService.clearAllData();
                if (!context.mounted) return;
                Navigator.pop(context);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All data cleared successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;
                Navigator.pop(context);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
