import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';
import '../widgets/summary_card.dart';
import 'edit_transaction.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _filter = 'Month';
  late Future<List<TransactionModel>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    setState(() {
      _transactionsFuture = TransactionService().getAll();
    });
  }

  List<TransactionModel> _filteredTransactions(List<TransactionModel> all) {
    final now = DateTime.now();
    if (_filter == 'Week') {
      final cutoff = now.subtract(const Duration(days: 7));
      return all.where((t) => t.date.isAfter(cutoff)).toList();
    } else if (_filter == 'Month') {
      final cutoff = now.subtract(const Duration(days: 30));
      return all.where((t) => t.date.isAfter(cutoff)).toList();
    }
    return all;
  }

  double _totalIncome(List<TransactionModel> list) =>
      list.where((t) => t.type == TransactionType.income).fold(0.0, (p, e) => p + e.amount);

  double _totalExpenses(List<TransactionModel> list) =>
      list.where((t) => t.type == TransactionType.expense).fold(0.0, (p, e) => p + e.amount);

  Future<void> _deleteTransaction(String id) async {
    await TransactionService().deleteById(id);
    _loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            tooltip: 'Categories',
            onPressed: () => Navigator.pushNamed(context, '/categories'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: FutureBuilder<List<TransactionModel>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No transactions yet. Tap + to add one.'));
          }

          final all = snapshot.data!;
          final list = _filteredTransactions(all);
          final income = _totalIncome(list);
          final expenses = _totalExpenses(list);
          final balance = income - expenses;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SummaryCard(
                          title: 'Income',
                          amount: '₱${income.toStringAsFixed(2)}',
                          color: Colors.green,
                          icon: Icons.arrow_downward,
                        ),
                        SummaryCard(
                          title: 'Expenses',
                          amount: '₱${expenses.toStringAsFixed(2)}',
                          color: Colors.red,
                          icon: Icons.arrow_upward,
                        ),
                        SummaryCard(
                          title: 'Balance',
                          amount: '₱${balance.toStringAsFixed(2)}',
                          color: Colors.blue,
                          icon: Icons.account_balance_wallet,
                        ),
                      ],
                    ),
                    DropdownButton<String>(
                      value: _filter,
                      items: const [
                        DropdownMenuItem(value: 'Week', child: Text('Week')),
                        DropdownMenuItem(value: 'Month', child: Text('Month')),
                        DropdownMenuItem(value: 'All', child: Text('All time')),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _filter = v);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Recent transactions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Expanded(
                  child: list.isEmpty
                      ? const Center(child: Text('No transactions in this period'))
                      : ListView.separated(
                          itemCount: list.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, i) {
                            final t = list[i];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: t.type == TransactionType.income ? Colors.green[100] : Colors.red[100],
                                child: Icon(
                                  t.type == TransactionType.income ? Icons.arrow_downward : Icons.arrow_upward,
                                  color: t.type == TransactionType.income ? Colors.green : Colors.red,
                                ),
                              ),
                              title: Text(t.description),
                              subtitle: Text('${t.category} • ${t.date.toLocal().toString().split(' ').first}'),
                              trailing: Text(
                                (t.type == TransactionType.income ? '+' : '-') + '₱${t.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: t.type == TransactionType.income ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditTransactionScreen(transactionId: t.id),
                                  ),
                                );
                                if (result == true) {
                                  _loadTransactions();
                                }
                              },
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Delete Transaction?'),
                                    content: Text('Delete "${t.description}"?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _deleteTransaction(t.id);
                                        },
                                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add');
          if (result == true) {
            _loadTransactions();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
