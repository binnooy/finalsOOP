import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/settings/widgets/index.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          // Preferences Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Preferences',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: const [
                ThemeTile(),
                Divider(height: 1),
                CurrencyTile(),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Data management removed

          // App Information Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'About',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const AppInfoSection(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
