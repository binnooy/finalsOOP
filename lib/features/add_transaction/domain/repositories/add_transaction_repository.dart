import 'package:dartz/dartz.dart';
import '../../domain/entities/add_transaction_entity.dart';
import '../../../../core/error/failure.dart';

abstract class AddTransactionRepository {
  /// Add a new transaction
  /// Returns [Either<Failure, AddTransactionEntity>]
  Future<Either<Failure, AddTransactionEntity>> addTransaction(
      AddTransactionEntity transaction);

  /// Get all transactions
  /// Returns [Either<Failure, List<AddTransactionEntity>>]
  Future<Either<Failure, List<AddTransactionEntity>>> getAllTransactions();

  /// Get a transaction by ID
  /// Returns [Either<Failure, AddTransactionEntity?>]
  Future<Either<Failure, AddTransactionEntity?>> getTransactionById(String id);

  /// Update an existing transaction
  /// Returns [Either<Failure, void>]
  Future<Either<Failure, void>> updateTransaction(
      AddTransactionEntity transaction);

  /// Delete a transaction by ID
  /// Returns [Either<Failure, void>]
  Future<Either<Failure, void>> deleteTransactionById(String id);

  /// Add a new category
  /// Returns [Either<Failure, void>]
  Future<Either<Failure, void>> addCategory(String category);

  /// Get all categories
  /// Returns [Either<Failure, List<String>>]
  Future<Either<Failure, List<String>>> getAllCategories();

  /// Delete a category
  /// Returns [Either<Failure, void>]
  Future<Either<Failure, void>> deleteCategory(String category);
}
