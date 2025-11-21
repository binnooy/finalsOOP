import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/transaction.dart';

abstract class TransactionRepository {
  /// Create: Add a new transaction
  Future<Either<Failure, void>> addTransaction(TransactionEntity transaction);

  /// Read: Get all transactions
  Future<Either<Failure, List<TransactionEntity>>> getAllTransactions();

  /// Read: Get transaction by ID
  Future<Either<Failure, TransactionEntity?>> getTransactionById(String id);

  /// Update: Update an existing transaction
  Future<Either<Failure, void>> updateTransaction(
      String id, TransactionEntity transaction);

  /// Delete: Remove a transaction by ID
  Future<Either<Failure, void>> deleteTransaction(String id);

  /// Delete all transactions
  Future<Either<Failure, void>> deleteAllTransactions();
}
