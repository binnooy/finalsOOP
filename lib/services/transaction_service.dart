import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';

class TransactionService {
  static const String boxName = 'transactions';
  static final TransactionService _instance = TransactionService._internal();

  TransactionService._internal();
  factory TransactionService() => _instance;

  // Access the already-opened box
  Box<TransactionModel> _getBox() => Hive.box<TransactionModel>(boxName);

  Future<void> initBox() async {
    final box = _getBox();
    if (box.isEmpty) {
      await addSampleData(box);
    }
  }

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
    ];
    for (var t in samples) {
      await box.add(t);
    }
  }

  Future<List<TransactionModel>> getAll() async => _getBox().values.toList();

  Future<TransactionModel> add(TransactionModel transaction) async {
    await _getBox().add(transaction);
    return transaction;
  }

  Future<void> update(int index, TransactionModel transaction) async {
    await _getBox().putAt(index, transaction);
  }

  Future<void> updateById(String id, TransactionModel transaction) async {
    final box = _getBox();
    final index = _findIndexById(box, id);
    if (index != -1) await box.putAt(index, transaction);
  }

  Future<void> deleteAt(int index) async => await _getBox().deleteAt(index);

  Future<void> deleteById(String id) async {
    final box = _getBox();
    final index = _findIndexById(box, id);
    if (index != -1) await box.deleteAt(index);
  }

  int _findIndexById(Box<TransactionModel> box, String id) {
    for (int i = 0; i < box.length; i++) {
      if (box.getAt(i)?.id == id) return i;
    }
    return -1;
  }

  Future<TransactionModel?> getById(String id) async {
    final box = _getBox();
    for (int i = 0; i < box.length; i++) {
      final t = box.getAt(i);
      if (t?.id == id) return t;
    }
    return null;
  }

  Future<int> getIndexById(String id) async {
    final box = _getBox();
    return _findIndexById(box, id);
  }
}
