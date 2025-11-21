import 'package:hive_flutter/hive_flutter.dart';
import '../../../../models/transaction.dart';
import '../../domain/entities/transaction.dart';
import 'transaction_local_datasource.dart';

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  static const String boxName = 'transactions';

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    try {
      final box = Hive.box<TransactionModel>(boxName);
      final model = _entityToModel(transaction);
      await box.add(model);
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  @override
  Future<List<TransactionEntity>> getAllTransactions() async {
    try {
      final box = Hive.box<TransactionModel>(boxName);
      return box.values.map((model) => _modelToEntity(model)).toList();
    } catch (e) {
      throw Exception('Failed to get transactions: $e');
    }
  }

  @override
  Future<TransactionEntity?> getTransactionById(String id) async {
    try {
      final box = Hive.box<TransactionModel>(boxName);
      for (int i = 0; i < box.length; i++) {
        final model = box.getAt(i);
        if (model?.id == id) {
          return _modelToEntity(model!);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get transaction by ID: $e');
    }
  }

  @override
  Future<void> updateTransaction(String id, TransactionEntity transaction) async {
    try {
      final box = Hive.box<TransactionModel>(boxName);
      for (int i = 0; i < box.length; i++) {
        final model = box.getAt(i);
        if (model?.id == id) {
          final updatedModel = _entityToModel(transaction);
          await box.putAt(i, updatedModel);
          return;
        }
      }
      throw Exception('Transaction not found');
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      final box = Hive.box<TransactionModel>(boxName);
      for (int i = 0; i < box.length; i++) {
        final model = box.getAt(i);
        if (model?.id == id) {
          await box.deleteAt(i);
          return;
        }
      }
      throw Exception('Transaction not found');
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  @override
  Future<void> deleteAllTransactions() async {
    try {
      final box = Hive.box<TransactionModel>(boxName);
      await box.clear();
    } catch (e) {
      throw Exception('Failed to delete all transactions: $e');
    }
  }

  // Helper: Convert Model to Entity
  TransactionEntity _modelToEntity(TransactionModel model) {
    return TransactionEntity(
      id: model.id,
      description: model.description,
      category: model.category,
      amount: model.amount,
      date: model.date,
      type: model.type == TransactionType.income
          ? TransactionType.income
          : TransactionType.expense,
    );
  }

  // Helper: Convert Entity to Model
  TransactionModel _entityToModel(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      description: entity.description,
      category: entity.category,
      amount: entity.amount,
      date: entity.date,
      type: entity.type == TransactionType.income
          ? TransactionType.income
          : TransactionType.expense,
    );
  }
}
