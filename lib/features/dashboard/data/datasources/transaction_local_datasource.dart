import '../../domain/entities/transaction.dart';

abstract class TransactionLocalDataSource {
  /// Create: Add a new transaction
  Future<void> addTransaction(TransactionEntity transaction);

  /// Read: Get all transactions
  Future<List<TransactionEntity>> getAllTransactions();

  /// Read: Get transaction by ID
  Future<TransactionEntity?> getTransactionById(String id);

  /// Update: Update an existing transaction
  Future<void> updateTransaction(String id, TransactionEntity transaction);

  /// Delete: Remove a transaction by ID
  Future<void> deleteTransaction(String id);

  /// Delete all transactions
  Future<void> deleteAllTransactions();
}
