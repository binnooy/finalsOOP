import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';

class EditTransactionScreen extends StatefulWidget {
  final String transactionId;

  const EditTransactionScreen({Key? key, required this.transactionId})
      : super(key: key);

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TransactionModel _transaction;
  late String _description;
  late double _amount;
  late TransactionType _type;
  late String _category;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransaction();
  }

  Future<void> _loadTransaction() async {
    final t = await TransactionService().getById(widget.transactionId);
    if (t != null) {
      setState(() {
        _transaction = t;
        _description = t.description;
        _amount = t.amount;
        _category = t.category;
        _type = t.type;
        _isLoading = false;
      });
    } else {
      if (mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      _transaction.description = _description;
      _transaction.amount = _amount;
      _transaction.category = _category;
      _transaction.type = _type;
      final idx = await TransactionService().getIndexById(widget.transactionId);
      if (idx != -1) {
        await TransactionService().update(idx, _transaction);
      }
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Transaction')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Description', border: OutlineInputBorder()),
                initialValue: _description,
                onSaved: (v) => _description = v ?? '',
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter description' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Amount (₱)', border: OutlineInputBorder()),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                initialValue: _amount.toString(),
                onSaved: (v) => _amount = double.tryParse(v ?? '') ?? 0.0,
                validator: (v) => (v == null || double.tryParse(v) == null)
                    ? 'Enter valid amount'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Category', border: OutlineInputBorder()),
                initialValue: _category,
                onSaved: (v) => _category = v ?? 'General',
              ),
              const SizedBox(height: 12),
              SegmentedButton<TransactionType>(
                segments: const [
                  ButtonSegment(
                      value: TransactionType.income, label: Text('Income')),
                  ButtonSegment(
                      value: TransactionType.expense, label: Text('Expense')),
                ],
                selected: {_type},
                onSelectionChanged: (v) => setState(() => _type = v.first),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text('Update Transaction',
                      style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
