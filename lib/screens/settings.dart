import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../features/settings/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final themes = ref.watch(themesProvider);
    final currencies = ref.watch(currenciesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                // Preferences
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Preferences',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: FormBuilder(
                      key: _formKey,
                      initialValue: {
                        'theme': state.theme,
                        'currency': state.currency,
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormBuilderDropdown<String>(
                            name: 'theme',
                            decoration:
                                const InputDecoration(labelText: 'Theme'),
                            items: themes.keys
                                .map((k) => DropdownMenuItem(
                                    value: k, child: Text(themes[k]!)))
                                .toList(),
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required()]),
                          ),
                          const SizedBox(height: 12),
                          FormBuilderDropdown<String>(
                            name: 'currency',
                            decoration:
                                const InputDecoration(labelText: 'Currency'),
                            items: currencies
                                .map((c) =>
                                    DropdownMenuItem(value: c, child: Text(c)))
                                .toList(),
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required()]),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    final valid = _formKey.currentState
                                            ?.saveAndValidate() ??
                                        false;
                                    if (!valid) return;
                                    final values = _formKey.currentState!.value;
                                    controller
                                        .setTheme(values['theme'] as String);
                                    controller.setCurrency(
                                        values['currency'] as String);
                                  },
                                  child: const Text('Save Preferences'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Data / Stats
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Data',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Transactions: ${state.stats?['transactions'] ?? '-'}'),
                        const SizedBox(height: 8),
                        Text(
                            'Categories: ${state.stats?['categories'] ?? '-'}'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // About
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'About',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListTile(
                    title: const Text('Offline Expense Tracker'),
                    subtitle: Text('Version ${ref.watch(appVersionProvider)}'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }
}
