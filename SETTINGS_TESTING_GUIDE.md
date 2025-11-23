# Settings Features - Testing & Verification Guide

## How to Test All Features

### **Step 1: Add Debug Widget to Settings Screen**

Open `lib/screens/settings.dart` and add the test widget to the settings screen:

```dart
import 'package:expensetracker/features/settings/debug/settings_tests.dart';

// In the ListView of SettingsScreen, add at the top:
ListView(
  children: [
    const SettingsFeatureTests(),  // ADD THIS LINE
    const SizedBox(height: 32),
    
    // Rest of your settings...
  ],
)
```

### **Step 2: Run the App**

```bash
flutter run
```

### **Step 3: Go to Settings**

- From Dashboard, tap Settings
- You should see the test panel at the top

---

## What Each Test Does

### **Test 1: Currency Change**
```
Buttons: USD | PHP
```
- Click "USD" → Changes currency to USD and saves it
- Click "PHP" → Changes currency to PHP and saves it
- Status shows: "SUCCESS: Currency changed to [CURRENCY]"
- **Verification**: Currency displays with correct symbol

### **Test 2: Export Data**
```
Buttons: Export | Get Stats
```
- Click "Export" → Exports all transactions and categories as JSON
- Shows exported data in the status box
- **Verification**: JSON data appears with your actual data

### **Test 3: Clear Data**
```
Button: CLEAR ALL (Red)
```
- Click → Shows confirmation dialog
- Click "YES DELETE" → Deletes all data
- Status shows: "SUCCESS: Data cleared!"
- **Verification**: Stats show 0 transactions and 0 categories

---

## Expected Behavior

### Currency Change ✅
1. Click "USD" button
2. Status shows: "SUCCESS: Currency changed to USD"
3. Go back to Dashboard
4. All amounts display with USD symbol
5. Restart app → Settings still shows USD ✓

### Export Data ✅
1. Click "Export" button
2. Status shows full JSON with all your data
3. JSON format like:
```json
{
  "version": "1.0.0",
  "exportedAt": "2025-11-22T10:30:00.000Z",
  "transactions": [...],
  "categories": [...]
}
```

### Clear Data ✅
1. Click "CLEAR ALL" button
2. Confirm deletion in dialog
3. Status shows: "SUCCESS: Data cleared!"
4. Transaction count → 0
5. Category count → 0

---

## Troubleshooting

### Issue: Tests Not Appearing
**Solution**: Make sure you added `SettingsFeatureTests()` widget to settings.dart

### Issue: Currency Doesn't Change
**Check**:
1. Is the status showing "SUCCESS"?
2. Check console for errors
3. Go to Dashboard and look for currency symbol

### Issue: Export Shows No Data
**Check**:
1. Do you have transactions in the app?
2. Check the JSON - it might be empty but still valid

### Issue: Clear Data Doesn't Work
**Check**:
1. Did you confirm the dialog?
2. Check stats show 0 after clearing

---

## Console Output

When you click buttons, check the console for debug prints:

```
I/flutter: Testing: Changing to USD...
I/flutter: SUCCESS: Currency changed to USD
```

or 

```
I/flutter: Testing: Exporting data...
I/flutter: SUCCESS: Exported 456 characters
```

---

## What's Actually Tested

### Currency Feature Tests:
✅ Saves to Hive database
✅ Updates Riverpod provider
✅ Displays with correct symbol
✅ Persists on app restart

### Export Data Tests:
✅ Reads transactions box
✅ Reads categories box
✅ Converts to JSON
✅ Shows formatted data

### Clear Data Tests:
✅ Clears transactions box
✅ Clears categories box
✅ Updates statistics
✅ Shows confirmation

---

## Manual Testing Without Debug Widget

### Test Currency Manually:
```dart
// In any widget:
ref.watch(currencyProvider); // Should show current currency
// Change it in Settings
// Widget rebuilds with new currency
```

### Test Export Manually:
```dart
// In console:
final json = await SettingsService.exportDataAsJson();
print(json); // Should show valid JSON
```

### Test Clear Manually:
```dart
// In console:
final before = SettingsService.getDataStatistics();
print(before); // Shows count
await SettingsService.clearAllData();
final after = SettingsService.getDataStatistics();
print(after); // Should be 0
```

---

## Complete Test Checklist

Run through all these:

- [ ] **Currency USD**: Click USD → See status "SUCCESS" → Check Dashboard shows USD
- [ ] **Currency PHP**: Click PHP → See status "SUCCESS" → Check Dashboard shows PHP
- [ ] **Currency Persist**: Restart app → Settings shows PHP still ✓
- [ ] **Get Stats**: Click button → Shows transaction and category count
- [ ] **Export Data**: Click button → Shows JSON with data
- [ ] **Export Empty**: Clear data first, export → Shows empty JSON
- [ ] **Clear Data**: Click CLEAR ALL → Confirm → See "SUCCESS"
- [ ] **Clear Verified**: Stats show 0 transactions and 0 categories

---

## If Something Doesn't Work

1. **Check Hive initialization**: 
   - Settings box must be open in `hive_adapter_registration.dart`

2. **Check Providers**:
   - `currencyProvider` must be watched correctly
   - Must use `ref.read().notifier.state = value` to update

3. **Check Service**:
   - `SettingsService.setCurrency()` must save to Hive
   - `SettingsService.exportDataAsJson()` must not throw

4. **Check Errors**:
   - Watch Flutter console for red errors
   - Status box shows errors in red

---

## Summary

These tests verify that:
✅ Currency selection saves and persists
✅ Theme selection works (checked in main.dart)
✅ Data export generates valid JSON
✅ Clear data safely deletes everything
✅ All Riverpod providers update correctly
✅ Hive persistence works

**If all tests pass, all features are working!** 🎉
