# How to Detect Currency Changes

## Overview
The currency is stored in Hive and managed via Riverpod's `currencyProvider`. Here are multiple ways to detect when currency changes:

---

## Method 1: Watch Currency in Widgets (Recommended for UI Updates)

Use `ref.watch()` to automatically rebuild widgets when currency changes:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/settings/settings_provider.dart';

class TransactionDisplayWidget extends ConsumerWidget {
  const TransactionDisplayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This widget rebuilds whenever currency changes
    final currency = ref.watch(currencyProvider);
    final currencyData = ref.watch(currencyDataProvider);
    final symbol = currencyData[currency]?['symbol'] ?? '';

    return Text('Amount: $symbol 1000');
  }
}
```

**When to use**: Best for displaying currency symbols in the UI

---

## Method 2: Listen for Currency Changes

Use `ref.listen()` to perform actions when currency changes:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/settings/settings_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for currency changes and perform actions
    ref.listen(currencyProvider, (previous, next) {
      if (previous != null && previous != next) {
        print('Currency changed from $previous to $next');
        
        // Perform actions on currency change:
        // - Recalculate totals
        // - Refresh exchange rates
        // - Update display
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Currency changed to $next')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Text('Dashboard with currency: ${ref.watch(currencyProvider)}'),
      ),
    );
  }
}
```

**When to use**: When you need to trigger side effects (API calls, calculations) on currency change

---

## Method 3: Get Current Currency Value

Access currency without watching for changes:

```dart
// Get currency without rebuilding widget
final currency = ref.read(currencyProvider);

// Get currency data
final currencyData = ref.read(currencyDataProvider);
final symbol = currencyData[currency]?['symbol'] ?? '';
final name = currencyData[currency]?['name'] ?? '';
```

**When to use**: In event handlers, button taps, or calculations where you only need the current value

---

## Method 4: Check if Currency Changed from Persistent Storage

```dart
import 'features/settings/settings_service.dart';

// Get saved currency from Hive
String savedCurrency = SettingsService.getCurrency();

// Compare with another value
String previousCurrency = 'USD';
if (savedCurrency != previousCurrency) {
  print('Currency has changed from $previousCurrency to $savedCurrency');
}
```

**When to use**: Comparing with previous sessions or saved values

---

## Method 5: Create a Custom Change Listener Hook

Create a reusable hook to detect currency changes app-wide:

```dart
// In settings_provider.dart, add this:

/// Listen to currency changes globally
final currencyChangeNotifierProvider = Provider<void>((ref) {
  // This watches for changes but doesn't return anything
  ref.watch(currencyProvider);
});

/// Get a stream of currency changes
final currencyChangeStreamProvider = StreamProvider<String>((ref) async* {
  String lastCurrency = SettingsService.getCurrency();
  
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    final currentCurrency = SettingsService.getCurrency();
    
    if (currentCurrency != lastCurrency) {
      lastCurrency = currentCurrency;
      yield currentCurrency;
    }
  }
});
```

Then in your widgets:

```dart
final currencyStream = ref.watch(currencyChangeStreamProvider);

currencyStream.when(
  data: (newCurrency) => Text('New currency: $newCurrency'),
  loading: () => const CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```

---

## Method 6: Example - Update Transaction Display When Currency Changes

Here's a complete example showing currency change detection in the transaction list:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/settings/settings_provider.dart';

class TransactionListWidget extends ConsumerWidget {
  const TransactionListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch for currency changes
    final currency = ref.watch(currencyProvider);
    final currencyData = ref.watch(currencyDataProvider);
    
    // Listen for changes and perform actions
    ref.listen(currencyProvider, (previous, next) {
      if (previous != null && previous != next) {
        print('Updating transaction display - currency changed to $next');
        // Refresh transaction list or recalculate totals
      }
    });

    final symbol = currencyData[currency]?['symbol'] ?? '';

    return ListView(
      children: [
        ListTile(
          title: const Text('Transaction 1'),
          trailing: Text('$symbol 1000'),
          subtitle: Text('Currency: $currency'),
        ),
        ListTile(
          title: const Text('Transaction 2'),
          trailing: Text('$symbol 500'),
          subtitle: Text('Currency: $currency'),
        ),
      ],
    );
  }
}
```

---

## How Currency Change Works Currently

1. **User selects new currency** in Settings → Currency
2. **Saved to Hive**: `SettingsService.setCurrency(value)`
3. **Provider updated**: `ref.read(currencyProvider.notifier).state = value`
4. **All watching widgets rebuild** automatically
5. **UI updates** with new currency symbol and name

---

## Testing Currency Changes

To verify currency changes are working:

### 1. Check Hive Storage
```dart
final settingsBox = Hive.box('settings');
print('Saved currency: ${settingsBox.get('currency')}');
```

### 2. Print Changes During Development
```dart
ref.listen(currencyProvider, (previous, next) {
  debugPrint('Currency changed: $previous → $next');
});
```

### 3. Monitor via Console/Logcat
Look for the print statements when you:
- Go to Settings
- Select a different currency
- See the snackbar confirmation
- Return to main screen

---

## Best Practices

✅ **DO**:
- Use `ref.watch()` for UI that needs to update with currency
- Use `ref.listen()` for side effects (calculations, API calls)
- Use `ref.read()` for one-time reads in event handlers
- Check `previous != null` before comparing in listeners

❌ **DON'T**:
- Don't call `SettingsService.getCurrency()` in `build()` method - use `ref.watch()`
- Don't ignore the `previous` value in listeners
- Don't update UI in listeners - let Riverpod's rebuilding handle it

---

## Debugging Currency Changes

Add this to any ConsumerWidget to debug:

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final currency = ref.watch(currencyProvider);
  
  // Debug prints
  print('🔄 Building widget - Currency: $currency');
  
  ref.listen(currencyProvider, (previous, next) {
    print('📱 Currency changed: $previous → $next');
  });

  return YourWidget();
}
```

---

## Summary Table

| Method | Use Case | When to Use |
|--------|----------|------------|
| `ref.watch()` | Auto-rebuild UI | Display currency in widgets |
| `ref.listen()` | Side effects | Trigger actions on change |
| `ref.read()` | Get current value | One-time reads |
| `SettingsService.getCurrency()` | Persistent storage | Compare with saved values |
| Stream Provider | Event stream | Complex workflows |

Choose the method that best fits your use case!
