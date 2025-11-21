import 'package:hive_flutter/hive_flutter.dart';
import '../models/add_transaction_model.dart';
import 'add_transaction_local_datasource.dart';

class AddTransactionLocalDataSourceImpl
    implements AddTransactionLocalDataSource {
  static const String transactionsBoxName = 'addTransactions';
  static const String categoriesBoxName = 'addCategories';

  @override
  Future<AddTransactionModel> addTransaction(
      AddTransactionModel transaction) async {
    try {
      final box = Hive.box<AddTransactionModel>(transactionsBoxName);
      await box.add(transaction);
      return transaction;
    } on HiveError catch (e) {
      throw Exception('Failed to add transaction: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error adding transaction: $e');
    }
  }

  @override
  Future<List<AddTransactionModel>> getAllTransactions() async {
    try {
      final box = Hive.box<AddTransactionModel>(transactionsBoxName);
      return box.values.toList();
    } on HiveError catch (e) {
      throw Exception('Failed to fetch transactions: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching transactions: $e');
    }
  }

  @override
  Future<AddTransactionModel?> getTransactionById(String id) async {
    try {
      final box = Hive.box<AddTransactionModel>(transactionsBoxName);
      for (final transaction in box.values) {
        if (transaction.id == id) {
          return transaction;
        }
      }
      return null;
    } on HiveError catch (e) {
      throw Exception('Failed to fetch transaction: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching transaction: $e');
    }
  }

  @override
  Future<void> updateTransaction(AddTransactionModel transaction) async {
    try {
      final box = Hive.box<AddTransactionModel>(transactionsBoxName);
      int index = -1;
      for (int i = 0; i < box.length; i++) {
        if (box.getAt(i)?.id == transaction.id) {
          index = i;
          break;
        }
      }
      if (index != -1) {
        await box.putAt(index, transaction);
      } else {
        throw Exception('Transaction not found');
      }
    } on HiveError catch (e) {
      throw Exception('Failed to update transaction: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error updating transaction: $e');
    }
  }

  @override
  Future<void> deleteTransactionById(String id) async {
    try {
      final box = Hive.box<AddTransactionModel>(transactionsBoxName);
      int index = -1;
      for (int i = 0; i < box.length; i++) {
        if (box.getAt(i)?.id == id) {
          index = i;
          break;
        }
      }
      if (index != -1) {
        await box.deleteAt(index);
      } else {
        throw Exception('Transaction not found');
      }
    } on HiveError catch (e) {
      throw Exception('Failed to delete transaction: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting transaction: $e');
    }
  }

  @override
  Future<void> addCategory(String category) async {
    try {
      final box = Hive.box<String>(categoriesBoxName);
      if (!box.values.contains(category)) {
        await box.add(category);
      }
    } on HiveError catch (e) {
      throw Exception('Failed to add category: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error adding category: $e');
    }
  }

  @override
  Future<List<String>> getAllCategories() async {
    try {
      final box = Hive.box<String>(categoriesBoxName);
      return box.values.toList();
    } on HiveError catch (e) {
      throw Exception('Failed to fetch categories: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching categories: $e');
    }
  }

  @override
  Future<void> deleteCategory(String category) async {
    try {
      final box = Hive.box<String>(categoriesBoxName);
      final index = box.values.toList().indexOf(category);
      if (index != -1) {
        await box.deleteAt(index);
      } else {
        throw Exception('Category not found');
      }
    } on HiveError catch (e) {
      throw Exception('Failed to delete category: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting category: $e');
    }
  }
}
