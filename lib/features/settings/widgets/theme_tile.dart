import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings_provider.dart';
import '../settings_service.dart';

class ThemeTile extends ConsumerWidget {
  const ThemeTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final themes = ref.watch(themesProvider);

    return ListTile(
      title: const Text('Theme'),
      subtitle: Text(themes[theme] ?? 'System'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        _showThemeDialog(context, ref, theme, themes);
      },
    );
  }

  void _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    String currentTheme,
    Map<String, String> themes,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: themes.entries.map((entry) {
              return RadioListTile<String>(
                title: Text(entry.value),
                value: entry.key,
                groupValue: currentTheme,
                onChanged: (value) async {
                  if (value != null) {
                    await SettingsService.setTheme(value);
                    ref.read(themeProvider.notifier).state = value;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Theme changed to ${entry.value}')),
                    );
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
