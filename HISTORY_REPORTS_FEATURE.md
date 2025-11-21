# History & Reports Feature Implementation

## Overview
The History & Reports feature provides users with a comprehensive view of all transactions with powerful filtering and sorting capabilities. This feature is designed for budget-conscious users who want simple offline tracking with detailed transaction management.

## User Flow

### 1. **Viewing Transaction Lists**
   - Access the History & Reports screen via the history icon (📋) in the Dashboard's AppBar
   - All transactions are displayed in a sorted list (newest first)
   - Each transaction shows:
     - Description
     - Category with color-coded icon
     - Date (relative format: "Today", "Yesterday", or date)
     - Amount with type indicator (+ for income, - for expense)

### 2. **Filtering Transactions**
   Users can apply multiple filters simultaneously:

   **By Category:**
   - Tap the "Category" chip
   - Select from available categories
   - Only transactions in that category are shown
   - Chip displays selected category

   **By Transaction Type:**
   - Tap the "Type" chip
   - Choose between Income or Expense
   - Filters show only selected type
   - Chip displays INCOME or EXPENSE

   **By Date Range:**
   - Tap the "Date Range" chip
   - A date picker opens showing calendar
   - Select start and end dates
   - Transactions outside range are hidden
   - Chip shows date range in format: DD/MM - DD/MM

   **Clear Filters:**
   - After applying any filter, a "Clear" chip appears
   - Tap it to reset all filters
   - All transactions appear again

### 3. **Summary Statistics**
   When transactions are displayed (filtered or not), a summary card shows:
   - **Income:** Total income for filtered transactions (green)
   - **Expenses:** Total expenses for filtered transactions (red)
   - **Balance:** Net balance (Income - Expenses) in teal or red based on sign

### 4. **Selecting a Transaction**
   - Tap on any transaction tile
   - A bottom sheet opens showing full transaction details:
     - Large amount display with currency and type color
     - Description
     - Category
     - Transaction Type (INCOME/EXPENSE)
     - Date (formatted)
     - Notes (if any)
     - Action buttons

### 5. **Edit Transaction**
   - From the transaction details sheet, tap the "Edit" button
   - Opens the EditTransactionScreen
   - Modify any transaction field
   - Save changes (returns to History screen with updated data)

### 6. **Delete Transaction**
   - From the transaction details sheet, tap the "Delete" button
   - Transaction is permanently removed
   - Transaction list refreshes automatically

### 7. **Add Transaction from History Screen**
   - Tap the floating action button (+) on the History screen
   - Opens the AddTransactionScreen
   - After adding, returns to History screen
   - New transaction appears in the list

## File Structure

```
lib/screens/
├── history_reports.dart          # Main History & Reports screen
├── dashboard.dart                 # Updated with history button
└── main.dart                       # Updated with /history route
```

## Key Components

### Main Screen: `HistoryReportsScreen`
- State management for filters and transactions
- Future builder for async transaction loading

### Supporting Widgets:

1. **`_TransactionTile`** - Individual transaction display
   - Category-specific colors and icons
   - Smart date formatting
   - Amount color coding by type

2. **`_TransactionDetailsSheet`** - Bottom sheet for transaction details
   - Read-only transaction information
   - Edit and Delete buttons
   - Clean, organized layout

3. **`_SummaryStats`** - Statistics display
   - Income/Expense/Balance calculation
   - Color-coded values
   - Responsive layout

### Filter Methods:

- **`_applyFilters()`** - Combines all active filters
- **`_selectDateRange()`** - Opens date picker
- **`_clearFilters()`** - Resets all filters to null
- **`_loadCategories()`** - Extracts unique categories from transactions

## Features

### Smart Filtering
- Multiple filters can be combined
- Filters are applied cumulatively (AND logic)
- Real-time filtering as user selects options
- Clear visual indication of active filters

### Category Management
- Automatic extraction of categories from transactions
- Color-coded by category type:
  - 🍽️ Food: Orange
  - 🚗 Transport: Blue
  - 🎬 Entertainment: Purple
  - ⚡ Utilities: Teal
  - 💰 Income/Salary: Green
  - 💼 Freelance: Light Green

### Date Handling
- Smart date formatting (Today, Yesterday, or DD/MM/YYYY)
- Date range picker with calendar
- Timezone-aware date comparisons

### Responsive Design
- Scrollable filter chips for horizontal layout
- Responsive summary stats
- Optimized for all screen sizes
- Empty state when no transactions match filters

## Navigation Integration

### From Dashboard
- New history button (📋) in AppBar
- Routes to `/history` named route

### From History Screen
- Edit: Opens EditTransactionScreen for selected transaction
- Delete: Removes transaction and refreshes list
- Add: Opens AddTransactionScreen via FAB

## Data Persistence
- All transactions are persisted using Hive (local database)
- Changes immediately reflect in the UI
- Offline-first approach (no internet required)

## User Experience Enhancements

1. **Visual Feedback**
   - Color-coded amounts (green for income, red for expenses)
   - Category-specific icons
   - Selected filter chips highlighted

2. **Information Architecture**
   - Transaction list sorted by date (newest first)
   - Summary statistics always visible when data exists
   - Clear empty states with helpful icons

3. **Accessibility**
   - Descriptive icons with tooltips
   - Clear button labels
   - High contrast for amounts

## Testing Scenarios

1. **Filter by Category Only**
   - Select "Food" category
   - Verify only food transactions show
   - Check summary calculations

2. **Filter by Type Only**
   - Select "Expense" type
   - Verify only expenses show
   - Confirm income excluded

3. **Filter by Date Range**
   - Select a 7-day range
   - Verify only transactions in range show
   - Check boundary conditions

4. **Combined Filters**
   - Category: Food + Type: Expense + Date: Last 30 days
   - Verify all three conditions met

5. **Edit Transaction**
   - Edit category of a transaction
   - Verify list updates correctly
   - Check if transaction appears/disappears with current filters

6. **Delete Transaction**
   - Delete a transaction from details sheet
   - Verify it's removed from list
   - Check summary updates

7. **Add Transaction**
   - Add new transaction from FAB
   - Verify it appears in correct position
   - Check if it matches current filters

## Future Enhancements

1. **Export/Share**
   - Export transactions as CSV/PDF
   - Share filtered results

2. **Advanced Reports**
   - Monthly/Yearly summaries
   - Category breakdown charts
   - Spending trends

3. **Recurring Transactions**
   - Mark recurring expenses
   - Auto-add recurring transactions

4. **Budgets**
   - Set category budgets
   - Alert when exceeding budget
   - Budget vs. actual reports

5. **Search**
   - Full-text search on description/notes
   - Combined with filters
