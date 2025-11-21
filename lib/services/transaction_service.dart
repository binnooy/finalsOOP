import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';

class TransactionService {
  static const String boxName = 'transactions';

  // Singleton
  static final TransactionService _instance = TransactionService._internal();

  TransactionService._internal();

  factory TransactionService() {
    return _instance;
  }

  // Get the Hive box (must call initBox first)
  Future<Box<TransactionModel>> _getBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<TransactionModel>(boxName);
    }
    return Hive.box<TransactionModel>(boxName);
  }

  // Initialize the box (call once in main.dart)
  Future<void> initBox() async {
    await _getBox();
    // Add sample data if box is empty
    final box = await _getBox();
    if (box.isEmpty) {
      await addSampleData(box);
    }
  }

  // Add sample data for demo
  Future<void> addSampleData(Box<TransactionModel> box) async {
    final samples = [
      TransactionModel(
        description: 'Salary',
        category: 'Income',
        amount: 2500.0,
        date: DateTime.now().subtract(const Duration(days: 2)),
        type: TransactionType.income,
      ),
      TransactionModel(
        description: 'Groceries',
        category: 'Food',
        amount: 76.45,
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: TransactionType.expense,
      ),
      TransactionModel(
        description: 'Coffee',
        category: 'Food',
        amount: 4.5,
        date: DateTime.now().subtract(const Duration(days: 8)),
        type: TransactionType.expense,
      ),
      TransactionModel(
        description: 'Freelance',
        category: 'Income',
        amount: 420.0,
        date: DateTime.now().subtract(const Duration(days: 15)),
        type: TransactionType.income,
      ),
    ];
    for (var t in samples) {
      await box.add(t);
    }
  }

  // READ: Get all transactions
  Future<List<TransactionModel>> getAll() async {
    final box = await _getBox();
    return box.values.toList();
  }

  // CREATE: Add a new transaction
  Future<TransactionModel> add(TransactionModel transaction) async {
    final box = await _getBox();
    await box.add(transaction);
    return transaction;
  }

  // UPDATE: Update an existing transaction
  Future<void> update(int index, TransactionModel transaction) async {
    final box = await _getBox();
    await box.putAt(index, transaction);
  }

  // UPDATE by ID (find and update)
  Future<void> updateById(String id, TransactionModel transaction) async {
    final box = await _getBox();
    final index = _findIndexById(box, id);
    if (index != -1) {
      await box.putAt(index, transaction);
    }
  }

  // DELETE: Remove a transaction by index
  Future<void> deleteAt(int index) async {
    final box = await _getBox();
    await box.deleteAt(index);
  }

  // DELETE by ID
  Future<void> deleteById(String id) async {
    final box = await _getBox();
    final index = _findIndexById(box, id);
    if (index != -1) {
      await box.deleteAt(index);
    }
  }

  // Helper: Find index by ID
  int _findIndexById(Box<TransactionModel> box, String id) {
    for (int i = 0; i < box.length; i++) {
      if (box.getAt(i)?.id == id) {
        return i;
      }
    }
    return -1;
  }

  // Helper: Get transaction by ID
  Future<TransactionModel?> getById(String id) async {
    final box = await _getBox();
    for (int i = 0; i < box.length; i++) {
      final t = box.getAt(i);
      if (t?.id == id) {
        return t;
      }
    }
    return null;
  }

  // Helper: Get index by ID
  Future<int> getIndexById(String id) async {
    final box = await _getBox();
    return _findIndexById(box, id);
  }
}
