import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings_provider.dart';
import '../settings_service.dart';

class AppInfoSection extends ConsumerWidget {
  const AppInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appName = ref.watch(appNameProvider);
    final appVersion = ref.watch(appVersionProvider);
    final stats = SettingsService.getDataStatistics();

    return Column(
      children: [
        ListTile(
          title: const Text('App Information'),
          subtitle: Text('$appName v$appVersion'),
          leading: const Icon(Icons.info),
        ),
        const Divider(height: 1),
        ListTile(
          title: const Text('Transactions'),
          subtitle: Text('${stats['transactions']} transactions'),
          leading: const Icon(Icons.receipt),
        ),
        const Divider(height: 1),
        ListTile(
          title: const Text('Categories'),
          subtitle: Text('${stats['categories']} categories'),
          leading: const Icon(Icons.category),
        ),
      ],
    );
  }
}
