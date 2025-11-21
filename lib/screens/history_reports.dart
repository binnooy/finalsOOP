import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';
import 'edit_transaction.dart';

class HistoryReportsScreen extends StatefulWidget {
  const HistoryReportsScreen({Key? key}) : super(key: key);

  @override
  State<HistoryReportsScreen> createState() => _HistoryReportsScreenState();
}

class _HistoryReportsScreenState extends State<HistoryReportsScreen> {
  late Future<List<TransactionModel>> _transactionsFuture;

  // Filter states
  String? _selectedCategory;
  TransactionType? _selectedType;
  DateTimeRange? _dateRange;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _loadCategories();
  }

  void _loadTransactions() {
    setState(() {
      _transactionsFuture = TransactionService().getAll();
    });
  }

  Future<void> _loadCategories() async {
    final transactions = await TransactionService().getAll();
    final categories = transactions.map((t) => t.category).toSet().toList();
    setState(() {
      _categories = categories;
    });
  }

  List<TransactionModel> _applyFilters(List<TransactionModel> transactions) {
    var filtered = transactions;

    // Filter by category
    if (_selectedCategory != null) {
      filtered =
          filtered.where((t) => t.category == _selectedCategory).toList();
    }

    // Filter by type
    if (_selectedType != null) {
      filtered = filtered.where((t) => t.type == _selectedType).toList();
    }

    // Filter by date range
    if (_dateRange != null) {
      filtered = filtered.where((t) {
        final tDate = DateTime(t.date.year, t.date.month, t.date.day);
        final rangeStart = DateTime(_dateRange!.start.year,
            _dateRange!.start.month, _dateRange!.start.day);
        final rangeEnd = DateTime(
            _dateRange!.end.year, _dateRange!.end.month, _dateRange!.end.day);
        final isInRange =
            tDate.isAfter(rangeStart.subtract(const Duration(days: 1))) &&
                tDate.isBefore(rangeEnd.add(const Duration(days: 1)));
        return isInRange;
      }).toList();
    }

    // Sort by date descending (newest first)
    filtered.sort((a, b) => b.date.compareTo(a.date));

    return filtered;
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      initialDateRange: _dateRange,
    );
    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedType = null;
      _dateRange = null;
    });
  }

  Future<void> _deleteTransaction(String id) async {
    await TransactionService().deleteById(id);
    _loadTransactions();
  }

  void _viewTransactionDetails(
      BuildContext context, TransactionModel transaction) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: _TransactionDetailsSheet(
          transaction: transaction,
          onEdit: () {
            debugPrint('HistoryReports: Edit tapped for id=${transaction.id}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Edit tapped for ${transaction.description}')),
            );
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EditTransactionScreen(transactionId: transaction.id),
              ),
            ).then((result) {
              if (result == true) {
                _loadTransactions();
              }
            });
          },
          onDelete: () {
            debugPrint(
                'HistoryReports: Delete tapped for id=${transaction.id}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Deleting ${transaction.description}...')),
            );
            Navigator.pop(context);
            _deleteTransaction(transaction.id);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History & Reports'),
        elevation: 0,
      ),
      body: FutureBuilder<List<TransactionModel>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No transactions yet. Tap + to add one.'),
            );
          }

          final all = snapshot.data!;
          final filtered = _applyFilters(all);

          return Column(
            children: [
              // Filter Section
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Filter chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Category filter
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
                            ),
                            const SizedBox(width: 8),
                            // Type filter
                            FilterChip(
                              label: Text(
                                _selectedType != null
                                    ? _selectedType!.name.toUpperCase()
                                    : 'Type',
                              ),
                              onSelected: (selected) {
                                if (selected) {
                                  _showTypePicker(context);
                                } else {
                                  setState(() => _selectedType = null);
                                }
                              },
                              selected: _selectedType != null,
                            ),
                            const SizedBox(width: 8),
                            // Date range filter
                            FilterChip(
                              label: Text(
                                _dateRange != null
                                    ? '${_dateRange!.start.day}/${_dateRange!.start.month} - ${_dateRange!.end.day}/${_dateRange!.end.month}'
                                    : 'Date Range',
                              ),
                              onSelected: (selected) {
                                if (selected) {
                                  _selectDateRange(context);
                                } else {
                                  setState(() => _dateRange = null);
                                }
                              },
                              selected: _dateRange != null,
                            ),
                            const SizedBox(width: 8),
                            // Clear filters button
                            if (_selectedCategory != null ||
                                _selectedType != null ||
                                _dateRange != null)
                              ActionChip(
                                label: const Text('Clear'),
                                onPressed: _clearFilters,
                                avatar: const Icon(Icons.clear, size: 18),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Summary stats
                      if (filtered.isNotEmpty)
                        _SummaryStats(
                          transactions: filtered,
                        ),
                    ],
                  ),
                ),
              ),
              // Transactions List
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.filter_list,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No transactions match the filters',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final transaction = filtered[index];
                          return _TransactionTile(
                            transaction: transaction,
                            onTap: () =>
                                _viewTransactionDetails(context, transaction),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add').then((result) {
            if (result == true) {
              _loadTransactions();
            }
          });
        },
        tooltip: 'Add Transaction',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCategoryPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Category'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _categories
                .map(
                  (category) => ListTile(
                    title: Text(category),
                    onTap: () {
                      setState(() => _selectedCategory = category);
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showTypePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Type'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Income'),
                onTap: () {
                  setState(() => _selectedType = TransactionType.income);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Expense'),
                onTap: () {
                  setState(() => _selectedType = TransactionType.expense);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onTap;

  const _TransactionTile({
    required this.transaction,
    required this.onTap,
  });

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
        return Colors.green;
      case 'salary':
        return Colors.green;
      case 'freelance':
        return Colors.lightGreen;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon() {
    switch (transaction.category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'entertainment':
        return Icons.movie;
      case 'utilities':
        return Icons.bolt;
      case 'income':
      case 'salary':
      case 'freelance':
        return Icons.attach_money;
      default:
        return Icons.receipt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == TransactionType.expense;
    final amountColor = isExpense ? Colors.red : Colors.green;
    final amountSign = isExpense ? '-' : '+';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getCategoryColor().withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getCategoryIcon(),
            color: _getCategoryColor(),
          ),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                transaction.category,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _formatDate(transaction.date),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Text(
          '$amountSign₱${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: amountColor,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

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
}

class _TransactionDetailsSheet extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TransactionDetailsSheet({
    required this.transaction,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == TransactionType.expense;
    final amountColor = isExpense ? Colors.red : Colors.green;
    final amountSign = isExpense ? '-' : '+';

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transaction Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Amount display
          Center(
            child: Column(
              children: [
                Text(
                  '$amountSign₱${transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: amountColor,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Details
          _DetailRow('Description', transaction.description),
          const SizedBox(height: 16),
          _DetailRow('Category', transaction.category),
          const SizedBox(height: 16),
          _DetailRow('Type', transaction.type.name.toUpperCase()),
          const SizedBox(height: 16),
          _DetailRow(
            'Date',
            '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
          ),
          if (transaction.notes.isNotEmpty) ...[
            const SizedBox(height: 16),
            _DetailRow('Notes', transaction.notes),
          ],
          const SizedBox(height: 32),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryStats extends StatelessWidget {
  final List<TransactionModel> transactions;

  const _SummaryStats({required this.transactions});

  @override
  Widget build(BuildContext context) {
    final income = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
    final expenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
    final balance = income - expenses;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Text(
                'Income',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                '+₱${income.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Text(
                'Expenses',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                '-₱${expenses.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Text(
                'Balance',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                '₱${balance.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: balance >= 0 ? Colors.teal : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
