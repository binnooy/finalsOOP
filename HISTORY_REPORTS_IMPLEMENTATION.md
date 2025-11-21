# History & Reports Implementation Guide

## Feature Overview

The History & Reports feature provides a sophisticated transaction management interface with filtering, sorting, and detailed transaction views. Built entirely with Flutter's standard widgets for offline-first functionality.

## Architecture

### Component Hierarchy

```
HistoryReportsScreen (StatefulWidget)
├── AppBar
├── Body: Column
│  ├── SingleChildScrollView (Filters section)
│  │  └── Column
│  │     ├── "Filters" label
│  │     ├── SingleChildScrollView (horizontal chips)
│  │     │  └── Row
│  │     │     ├── FilterChip (Category)
│  │     │     ├── FilterChip (Type)
│  │     │     ├── FilterChip (Date Range)
│  │     │     └── ActionChip (Clear)
│  │     └── _SummaryStats widget
│  └── Expanded (Transactions list)
│     └── ListView (_TransactionTile items)
└── FloatingActionButton (+)
```

## State Management

### Filter State Variables

```dart
String? _selectedCategory;        // null or category name
TransactionType? _selectedType;   // null, income, or expense
DateTimeRange? _dateRange;        // null or DateTimeRange
List<String> _categories = [];    // Dynamic list from transactions
```

### Future State

```dart
late Future<List<TransactionModel>> _transactionsFuture;
```

### Update Mechanism

All filters trigger `setState()` to rebuild the widget and reapply filtering.

## Key Algorithms

### Filter Application

```dart
List<TransactionModel> _applyFilters(List<TransactionModel> transactions) {
  var filtered = transactions;

  // Apply category filter (if selected)
  if (_selectedCategory != null) {
    filtered = filtered.where((t) => t.category == _selectedCategory).toList();
  }

  // Apply type filter (if selected)
  if (_selectedType != null) {
    filtered = filtered.where((t) => t.type == _selectedType).toList();
  }

  // Apply date range filter (if selected)
  if (_dateRange != null) {
    filtered = filtered.where((t) {
      // Date-only comparison (ignore time)
      final tDate = DateTime(t.date.year, t.date.month, t.date.day);
      final rangeStart = DateTime(
        _dateRange!.start.year,
        _dateRange!.start.month,
        _dateRange!.start.day,
      );
      final rangeEnd = DateTime(
        _dateRange!.end.year,
        _dateRange!.end.month,
        _dateRange!.end.day,
      );
      // Check if transaction date is within range (inclusive)
      return tDate.isAfter(rangeStart.subtract(const Duration(days: 1))) &&
             tDate.isBefore(rangeEnd.add(const Duration(days: 1)));
    }).toList();
  }

  // Sort by date (newest first)
  filtered.sort((a, b) => b.date.compareTo(a.date));

  return filtered;
}
```

### Date Formatting

```dart
String _formatDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final transactionDate = DateTime(date.year, date.month, date.day);

  if (transactionDate == today) {
    return 'Today';
  } else if (transactionDate == yesterday) {
    return 'Yesterday';
  } else {
    return '${date.day}/${date.month}/${date.year}';
  }
}
```

### Category Color Mapping

```dart
Color _getCategoryColor() {
  switch (transaction.category.toLowerCase()) {
    case 'food':
      return Colors.orange;
    case 'transport':
      return Colors.blue;
    case 'entertainment':
      return Colors.purple;
    case 'utilities':
      return Colors.teal;
    case 'income':
    case 'salary':
      return Colors.green;
    case 'freelance':
      return Colors.lightGreen;
    default:
      return Colors.grey;
  }
}
```

## UI Patterns

### Filter Chip Pattern

```dart
FilterChip(
  label: Text(_selectedCategory ?? 'Category'),
  onSelected: (selected) {
    if (selected) {
      _showCategoryPicker(context);
    } else {
      setState(() => _selectedCategory = null);
    }
  },
  selected: _selectedCategory != null,
)
```

- Shows label (filter name or current selection)
- Tap to open picker
- Double-tap or long-press to clear
- Visual distinction when selected

### Transaction Tile Pattern

```dart
Card(
  child: ListTile(
    leading: Container(
      decoration: BoxDecoration(
        color: _getCategoryColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(_getCategoryIcon(), color: _getCategoryColor()),
    ),
    title: Text(transaction.description),
    subtitle: Row(
      children: [
        CategoryBadge(transaction.category),
        DateText(transaction.date),
      ],
    ),
    trailing: AmountText(transaction),
    onTap: () => _viewTransactionDetails(context, transaction),
  ),
)
```

### Bottom Sheet Pattern

```dart
showModalBottomSheet(
  context: context,
  builder: (context) => _TransactionDetailsSheet(...),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  ),
)
```

## Data Flow

### Loading Transactions

```
initState()
    ↓
_loadTransactions()
    ↓
TransactionService().getAll() [Future]
    ↓
FutureBuilder listens
    ↓
_applyFilters() applied in builder
    ↓
UI renders filtered list
```

### Filtering Process

```
User taps filter chip
    ↓
_showCategoryPicker() / _showTypePicker() / _selectDateRange()
    ↓
setState(() => _selectedCategory = category)
    ↓
Widget rebuilds
    ↓
FutureBuilder rebuilds
    ↓
_applyFilters() called with new criteria
    ↓
ListView rebuilds with filtered data
```

### Editing Transaction

```
User taps transaction
    ↓
_viewTransactionDetails() opens bottom sheet
    ↓
User taps [Edit]
    ↓
Navigator.push(EditTransactionScreen)
    ↓
User saves changes
    ↓
Navigator.pop(true)
    ↓
.then((result) => _loadTransactions())
    ↓
Transaction list refreshes
```

## Performance Considerations

### Memory Usage
- All transactions loaded into memory
- For 10,000+ transactions, consider pagination
- Filtering is O(n) with linear search

### CPU Usage
- Filtering occurs on every rebuild
- Sorting is O(n log n) but only on filtered list
- Category extraction is O(n) on init only

### Optimization Opportunities

1. **Memoization**: Cache filtered results
```dart
late List<TransactionModel> _cachedFiltered;
bool _filterChanged = true;

List<TransactionModel> _getFiltered() {
  if (_filterChanged) {
    _cachedFiltered = _applyFilters(...);
    _filterChanged = false;
  }
  return _cachedFiltered;
}
```

2. **Pagination**: Load transactions in chunks
```dart
final pageSize = 50;
int currentPage = 0;

List<TransactionModel> _getPage(List<TransactionModel> all) {
  return all.skip(currentPage * pageSize).take(pageSize).toList();
}
```

3. **Indexed Search**: For large datasets
```dart
Map<String, List<int>> _categoryIndex = {};

void _buildCategoryIndex(List<TransactionModel> transactions) {
  for (int i = 0; i < transactions.length; i++) {
    final cat = transactions[i].category;
    _categoryIndex[cat] ??= [];
    _categoryIndex[cat]!.add(i);
  }
}
```

## Testing Examples

### Unit Tests

```dart
void main() {
  group('HistoryReportsScreen', () {
    test('_applyFilters applies category filter', () {
      final transactions = [
        TransactionModel(..., category: 'Food', ...),
        TransactionModel(..., category: 'Transport', ...),
      ];
      
      // Set category filter
      state._selectedCategory = 'Food';
      
      final filtered = state._applyFilters(transactions);
      
      expect(filtered.length, 1);
      expect(filtered.first.category, 'Food');
    });

    test('_applyFilters combines multiple filters', () {
      // Test all three filters together
      state._selectedCategory = 'Food';
      state._selectedType = TransactionType.expense;
      state._dateRange = DateTimeRange(...);
      
      final filtered = state._applyFilters(transactions);
      
      expect(filtered.every((t) => t.category == 'Food'), true);
      expect(filtered.every((t) => t.type == TransactionType.expense), true);
    });
  });
}
```

### Widget Tests

```dart
void main() {
  testWidgets('Transaction tile displays correctly', (WidgetTester tester) async {
    final transaction = TransactionModel(...);
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: _TransactionTile(
            transaction: transaction,
            onTap: () {},
          ),
        ),
      ),
    );
    
    expect(find.text(transaction.description), findsOneWidget);
    expect(find.text(transaction.category), findsOneWidget);
    expect(find.text('-${transaction.amount}'), findsOneWidget);
  });
}
```

## Customization Guide

### Changing Filter Chips Order

```dart
// In build() method, Row children order:
Row(
  children: [
    FilterChip(...), // Change order here
    FilterChip(...),
    FilterChip(...),
  ],
)
```

### Adding New Filter Type

```dart
// 1. Add state variable
String? _selectedTag;

// 2. Add filter logic
if (_selectedTag != null) {
  filtered = filtered.where((t) => t.tags?.contains(_selectedTag)).toList();
}

// 3. Add chip in UI
FilterChip(
  label: Text(_selectedTag ?? 'Tags'),
  onSelected: (selected) {
    if (selected) _showTagPicker(context);
    else setState(() => _selectedTag = null);
  },
  selected: _selectedTag != null,
)

// 4. Add picker method
void _showTagPicker(BuildContext context) { ... }
```

### Customizing Category Colors

Edit `_getCategoryColor()` method to add new categories:

```dart
Color _getCategoryColor() {
  switch (transaction.category.toLowerCase()) {
    case 'groceries':
      return Colors.lime;
    case 'healthcare':
      return Colors.pink;
    // ... add more
    default:
      return Colors.blueGrey;
  }
}
```

## Troubleshooting

### Filters not applying
- Check `_applyFilters()` is called in FutureBuilder
- Verify `setState()` is triggering rebuild
- Check filter values are set correctly

### Transactions not updating after edit
- Ensure `_loadTransactions()` called after navigation
- Check `await` on async operations
- Verify transaction service methods work correctly

### Wrong category color
- Check category name case (use toLowerCase())
- Add missing category to `_getCategoryColor()`
- Verify TransactionModel category field populated

### Date filtering not working
- Ensure date range includes target date
- Check timezone handling in date comparison
- Verify DateTime(year, month, day) format

## Future Enhancement Ideas

1. **Sort Options**: By amount, category, date (ascending/descending)
2. **Search**: Full-text search in descriptions
3. **Export**: CSV, PDF export of filtered data
4. **Analytics**: Charts, spending trends
5. **Sharing**: Share filtered transactions via email/messaging
6. **Bulk Actions**: Select multiple, delete, export together
7. **Recurring**: Mark recurring transactions
8. **Tags**: Multi-tag filtering
