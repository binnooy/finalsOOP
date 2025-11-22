# Currency Detection System - Quick Reference

## How Currency Changes Work in Your App

### The Flow:
1. **User goes to Settings** → Taps on Currency
2. **Selects new currency** (e.g., PHP - Philippine Peso)
3. **System saves it** to Hive database
4. **Provider updates** - triggers all listening widgets
5. **Widgets rebuild** automatically with new currency
6. **Success message** shows confirmation

---

## Quick Ways to Detect Currency Changes

### **Option 1: Simple - Just Display It (Recommended for most cases)**
```dart
final currency = ref.watch(currencyProvider);
Text('Current: $currency') // Updates automatically
```
✅ Use this for: Showing currency in UI

---

### **Option 2: React to Change - Do Something When It Changes**
```dart
ref.listen(currencyProvider, (previous, next) {
  if (previous != null) {
    print('Currency changed from $previous to $next');
  }
});
```
✅ Use this for: Recalculating totals, fetching rates, updating displays

---

### **Option 3: Get Current Value Only (No Auto-Update)**
```dart
final currency = ref.read(currencyProvider);
// Use once, doesn't rebuild
```
✅ Use this for: Button taps, calculations, one-time actions

---

## How to Check if Currency Actually Changed

### Method 1: Via Console/Debug Output
```dart
ref.listen(currencyProvider, (previous, next) {
  print('📊 CURRENCY CHANGE DETECTED!');
  print('From: $previous');
  print('To: $next');
  if (previous != null && previous != next) {
    print('✅ Currency ACTUALLY changed');
  }
});
```

### Method 2: Check Persistent Storage
```dart
import 'features/settings/settings_service.dart';

// Get what's saved in Hive
String savedCurrency = SettingsService.getCurrency();
print('Saved currency: $savedCurrency'); // e.g., "PHP"
```

### Method 3: Visual Confirmation in Settings
- Go to Settings
- Look at Currency tile - shows current selection
- Changes immediately when you select new one
- Shows snackbar message: "Currency changed to Philippine Peso"

---

## Complete Example - Show It's Working

Add this to your Dashboard to see currency changes in real-time:

```dart
class DashboardScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch current currency
    final currency = ref.watch(currencyProvider);
    
    // 2. Listen for changes
    ref.listen(currencyProvider, (prev, next) {
      if (prev != null && prev != next) {
        print('✅ Changed from $prev to $next');
        // Refresh data, recalculate, etc.
      }
    });

    // 3. Use it in UI
    return Column(
      children: [
        Text('Current Currency: $currency'), // Updates when currency changes
        TransactionList(), // This will also update
      ],
    );
  }
}
```

When you change currency in Settings, you'll see:
1. ✅ Print statement in console showing change
2. ✅ Dashboard updates instantly
3. ✅ All currency displays change across app

---

## What Gets Updated When Currency Changes

When you select a new currency (e.g., PHP), automatically updates:

| Component | What Changes |
|-----------|--------------|
| Settings tile | Shows "₱ Philippine Peso" |
| Dashboard | All currency symbols change to ₱ |
| Currency badge | Shows new code and symbol |
| Transaction list | Amounts display with new symbol |
| Summaries | Income/expense use new symbol |

---

## Testing Checklist

✅ Do this to verify currency change is working:

1. **Open Settings**
   - Go to Settings screen
   - Look at Currency tile - should show current (e.g., "$ US Dollar")

2. **Change Currency**
   - Tap Currency
   - Select "Philippine Peso" (₱)
   - See confirmation message

3. **Verify Change**
   - Currency tile updates to "₱ Philippine Peso"
   - Go back to Dashboard
   - All amounts show with ₱ symbol instead of $

4. **Check Persistence**
   - Close and reopen app
   - Settings still show ₱ Philippine Peso
   - Currency persisted to device storage ✅

5. **Check Logs**
   - Open console/logcat
   - Should see print: "Currency changed from USD to PHP"

---

## Common Issues & Solutions

### Issue: Currency doesn't change in UI
**Solution**: Use `ref.watch()` not `ref.read()` in your widgets
```dart
// ❌ Wrong - doesn't rebuild
final currency = ref.read(currencyProvider);

// ✅ Correct - rebuilds when currency changes
final currency = ref.watch(currencyProvider);
```

### Issue: Can't see the change
**Solution**: Add a listener to see debug output
```dart
ref.listen(currencyProvider, (prev, next) {
  debugPrint('🔄 Currency: $prev → $next');
});
```

### Issue: Change doesn't persist
**Solution**: Make sure you're using SettingsService
```dart
// ✅ This persists to Hive
await SettingsService.setCurrency('PHP');
ref.read(currencyProvider.notifier).state = 'PHP';
```

---

## How Data Flows

```
Settings Screen
    ↓
User selects "PHP"
    ↓
SettingsService.setCurrency('PHP') → Saves to Hive
    ↓
ref.read(currencyProvider.notifier).state = 'PHP' → Updates provider
    ↓
ref.watch(currencyProvider) listeners notified
    ↓
Widgets rebuild with new currency
    ↓
ref.listen() callbacks executed
    ↓
UI updates across entire app ✅
```

---

## Where the System Is Located

| File | Purpose |
|------|---------|
| `lib/features/settings/settings_provider.dart` | Defines currencyProvider |
| `lib/features/settings/settings_service.dart` | Saves/loads from Hive |
| `lib/features/settings/widgets/currency_tile.dart` | UI for changing currency |
| `lib/core/hive/hive_adapter_registration.dart` | Initializes settings box |

---

## Summary

✅ **Currency changes are detected via Riverpod providers**
- `currencyProvider` - Current selected currency
- `currencyDataProvider` - Currency symbols and names
- `currenciesProvider` - List of available currencies

✅ **Watch for changes with**: `ref.watch(currencyProvider)`
✅ **React to changes with**: `ref.listen(currencyProvider, ...)`
✅ **Get current value with**: `ref.read(currencyProvider)`
✅ **All changes persist** to Hive automatically

That's how you determine and detect currency changes! 🎯
