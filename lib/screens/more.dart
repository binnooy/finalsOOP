import 'package:flutter/material.dart';
import '../screens/settings.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = <_MoreItem>[
      _MoreItem(label: 'Settings', routeBuilder: () => const SettingsScreen()),
      _MoreItem(label: 'About', routeBuilder: () => const _AboutScreen()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.label),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              // Navigate to the screen
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => item.routeBuilder()));
            },
          );
        },
      ),
    );
  }
}

class _MoreItem {
  final String label;
  final Widget Function() routeBuilder;
  _MoreItem({required this.label, required this.routeBuilder});
}

class _AboutScreen extends StatelessWidget {
  const _AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Offline Expense Tracker\nVersion 1.0.0'),
      ),
    );
  }
}
