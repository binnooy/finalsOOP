# Settings Feature Implementation

## Overview
The Settings feature has been fully implemented with all required functionality for budget-conscious users to manage their expense tracker application. This includes currency and theme preferences, data backup/export, data clearing, and app information viewing.

## Features Implemented

### 1. **Currency Settings**
- **Location**: `lib/features/settings/widgets/currency_tile.dart`
- **Supported Currencies**: USD, EUR, GBP, JPY, AUD, CAD, CHF, CNY, INR, AED, SAR
- **Storage**: Persisted in Hive settings box
- **User Flow**:
  1. User taps "Currency" in Settings
  2. Dialog opens with list of supported currencies
  3. User selects preferred currency
  4. Selection is saved and displayed
  5. Confirmation message appears

### 2. **Theme Settings**
- **Location**: `lib/features/settings/widgets/theme_tile.dart`
- **Options**: System (default), Light, Dark
- **Storage**: Persisted in Hive settings box
- **User Flow**:
  1. User taps "Theme" in Settings
  2. Dialog opens with theme options
  3. User selects preferred theme
  4. Selection is saved and displayed
  5. Confirmation message appears

### 3. **Data Backup & Export**
- **Location**: `lib/features/settings/widgets/data_management_section.dart`
- **Format**: JSON export containing:
  - Export timestamp
  - All transactions
  - All categories
  - App version
- **User Flow**:
  1. User taps "Backup & Export Data"
  2. Data is exported to JSON format
  3. Dialog shows formatted JSON
  4. User can copy the data for backup
  5. Success message confirms export

### 4. **Clear All Data**
- **Location**: `lib/features/settings/widgets/data_management_section.dart`
- **Safety Features**:
  - Confirmation dialog before deletion
  - Clear warning message
  - Red styling to indicate danger
- **User Flow**:
  1. User taps "Clear All Data"
  2. Confirmation dialog appears with warning
  3. User confirms the action
  4. All transactions and categories are deleted
  5. Success message confirms clearing

### 5. **App Information**
- **Location**: `lib/features/settings/widgets/app_info_section.dart`
- **Displays**:
  - App name (Offline Expense Tracker)
  - App version (1.0.0)
  - Number of transactions
  - Number of categories
- **User Flow**:
  1. User scrolls to "About" section
  2. App information is displayed
  3. Real-time statistics update as data changes

## Architecture

### File Structure
```
lib/
├── features/
│   └── settings/
│       ├── settings_provider.dart      # Riverpod providers
│       ├── settings_service.dart       # Business logic
│       └── widgets/
│           ├── index.dart              # Widget exports
│           ├── currency_tile.dart      # Currency selector
│           ├── theme_tile.dart         # Theme selector
│           ├── data_management_section.dart   # Export/Clear
│           └── app_info_section.dart   # App information
└── screens/
    └── settings.dart                   # Main settings screen
```

### Key Components

#### `SettingsService`
Business logic layer handling all settings operations:
- `setTheme(String theme)` - Save theme preference
- `setCurrency(String currency)` - Save currency preference
- `getTheme()` - Retrieve current theme
- `getCurrency()` - Retrieve current currency
- `exportDataAsJson()` - Export data as JSON
- `clearAllData()` - Delete all data
- `getDataStatistics()` - Get data counts

#### Riverpod Providers (`settings_provider.dart`)
State management using Riverpod:
- `themeProvider` - Current theme state
- `currencyProvider` - Current currency state
- `currenciesProvider` - List of available currencies
- `themesProvider` - Map of available themes
- `appVersionProvider` - App version
- `appNameProvider` - App name

#### Widgets
- **ThemeTile**: Theme selection with radio buttons
- **CurrencyTile**: Currency selection with radio buttons
- **DataManagementSection**: Export and clear data controls
- **AppInfoSection**: Display app and data statistics

### Storage
All preferences are stored in Hive's 'settings' box:
- Key: 'theme' → Value: 'system', 'light', or 'dark'
- Key: 'currency' → Value: Currency code (USD, EUR, etc.)

The settings box is automatically initialized in `lib/core/hive/hive_adapter_registration.dart`.

## User Flows Documented

### Change Currency
1. Tap Settings from main menu
2. Scroll to "Preferences" section
3. Tap on "Currency" showing current selection
4. Select desired currency from dialog
5. Currency changes immediately with confirmation

### Change Theme
1. Tap Settings from main menu
2. Scroll to "Preferences" section
3. Tap on "Theme" showing current selection
4. Select theme (System/Light/Dark) from dialog
5. Theme updates with confirmation (Note: Full app-wide theme switching requires main.dart integration)

### Export Data
1. Tap Settings from main menu
2. Scroll to "Data Management" section
3. Tap "Backup & Export Data"
4. View formatted JSON in dialog
5. Tap "Copy" to prepare data for backup
6. Share or store the data securely

### Clear All Data
1. Tap Settings from main menu
2. Scroll to "Data Management" section
3. Tap "Clear All Data" (red button)
4. Read warning in confirmation dialog
5. Tap "Clear" button to confirm
6. All data is permanently deleted

### View App Information
1. Tap Settings from main menu
2. Scroll to "About" section
3. View app name, version, transaction count, and category count
4. Information updates in real-time as data changes

## Integration Notes

### Main App Integration
To fully enable theme switching app-wide, update `lib/main.dart`:
```dart
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    
    return MaterialApp(
      // ... existing config ...
      themeMode: _getThemeMode(theme),
      theme: ThemeData(/* light theme */),
      darkTheme: ThemeData(/* dark theme */),
    );
  }

  ThemeMode _getThemeMode(String theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
```

### Currency Integration
To use the selected currency in other screens, access via Riverpod:
```dart
final currency = ref.watch(currencyProvider);
// Use currency in transaction displays, summaries, etc.
```

## Testing Checklist

- [x] Currency selector opens and closes properly
- [x] Currency changes are persisted across app restart
- [x] Theme selector opens and closes properly
- [x] Theme selection is persisted
- [x] Data export generates valid JSON
- [x] Clear data shows confirmation dialog
- [x] App information displays correctly
- [x] Settings box initializes properly in Hive

## Future Enhancements

1. **Advanced Export Options**:
   - CSV format for spreadsheet compatibility
   - File saving to device storage
   - Email export capability

2. **Advanced Theme**:
   - Custom color schemes
   - Accent color selection
   - Font size adjustment

3. **Additional Settings**:
   - Date format preferences
   - Notification settings
   - Auto-backup scheduling
   - Data import from JSON

4. **Security**:
   - PIN protection for settings
   - Data encryption
   - Backup password protection

## Error Handling

- Export failures show error messages
- Clear data requires confirmation
- Invalid operations display snackbar notifications
- Default values fallback if settings box is corrupted

## Dependencies

- `flutter_riverpod: ^2.6.1` - State management
- `hive_flutter: ^1.1.0` - Local storage
- `material_design_icons` (built-in) - Icons

No additional dependencies required beyond existing project setup.
