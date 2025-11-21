import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';
import '../services/category_service.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _description;
  late double _amount;
  late TransactionType _type;
  late String _category;
  late DateTime _selectedDate;
  late String _notes;
  late List<String> _categories;

  @override
  void initState() {
    super.initState();
    _description = '';
    _amount = 0.0;
    _type = TransactionType.expense;
    _category = '';
    _selectedDate = DateTime.now();
    _notes = '';
    _categories = [];
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await CategoryService().getAll();
      setState(() {
        _categories = categories;
        if (categories.isNotEmpty && _category.isEmpty) {
          _category = categories.first;
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading categories: $e')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _showAddCategoryDialog() async {
    final controller = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Category'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter category name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final newCategory = controller.text.trim();
                if (newCategory.isNotEmpty) {
                  try {
                    await CategoryService().add(newCategory);
                    await _loadCategories();
                    setState(() => _category = newCategory);
                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Category "$newCategory" added')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error adding category: $e')),
                      );
                    }
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        final transaction = TransactionModel(
          description: _description,
          amount: _amount,
          category: _category,
          date: _selectedDate,
          type: _type,
          notes: _notes,
        );
        await TransactionService().add(transaction);
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving transaction: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Transaction Type Selector
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SegmentedButton<TransactionType>(
                    segments: const [
                      ButtonSegment(
                        value: TransactionType.income,
                        icon: Icon(Icons.arrow_downward),
                        label: Text('Income'),
                      ),
                      ButtonSegment(
                        value: TransactionType.expense,
                        icon: Icon(Icons.arrow_upward),
                        label: Text('Expense'),
                      ),
                    ],
                    selected: {_type},
                    onSelectionChanged: (v) => setState(() => _type = v.first),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'e.g., Lunch, Office supplies',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                onSaved: (v) => _description = v ?? '',
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter a description' : null,
              ),
              const SizedBox(height: 16),

              // Amount Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Amount (₱)',
                  hintText: '0.00',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSaved: (v) => _amount = double.tryParse(v ?? '') ?? 0.0,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Enter an amount';
                  }
                  final amount = double.tryParse(v);
                  if (amount == null || amount <= 0) {
                    return 'Enter a valid amount greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Selector
              Row(
                children: [
                  Expanded(
                    child: _categories.isEmpty
                        ? TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.category),
                            ),
                            onSaved: (v) => _category = v ?? 'Other',
                          )
                        : DropdownButtonFormField<String>(
                            value: _category.isEmpty
                                ? _categories.first
                                : _category,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.category),
                            ),
                            items: _categories
                                .map((cat) => DropdownMenuItem(
                                      value: cat,
                                      child: Text(cat),
                                    ))
                                .toList(),
                            onChanged: (v) => setState(
                                () => _category = v ?? _categories.first),
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Select a category'
                                : null,
                          ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton.small(
                    onPressed: _showAddCategoryDialog,
                    tooltip: 'Add new category',
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Date Picker
              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Date'),
                  subtitle:
                      Text(_selectedDate.toLocal().toString().split(' ').first),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _selectDate(context),
                ),
              ),
              const SizedBox(height: 16),

              // Notes Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  hintText: 'Add any additional notes...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
                onSaved: (v) => _notes = v ?? '',
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text('Save Transaction',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 16),

              // Cancel Button
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text('Cancel', style: TextStyle(fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
