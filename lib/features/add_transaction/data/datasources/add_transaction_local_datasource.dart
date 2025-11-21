import '../models/add_transaction_model.dart';

abstract class AddTransactionLocalDataSource {
  /// Add a new transaction to local storage
  /// Throws [Exception] on failure
  Future<AddTransactionModel> addTransaction(AddTransactionModel transaction);

  /// Get all transactions from local storage
  /// Throws [Exception] on failure
  Future<List<AddTransactionModel>> getAllTransactions();

  /// Get a transaction by ID from local storage
  /// Throws [Exception] on failure
  Future<AddTransactionModel?> getTransactionById(String id);

  /// Update an existing transaction in local storage
  /// Throws [Exception] on failure
  Future<void> updateTransaction(AddTransactionModel transaction);

  /// Delete a transaction by ID from local storage
  /// Throws [Exception] on failure
  Future<void> deleteTransactionById(String id);

  /// Add a new category to local storage
  /// Throws [Exception] on failure
  Future<void> addCategory(String category);

  /// Get all categories from local storage
  /// Throws [Exception] on failure
  Future<List<String>> getAllCategories();

  /// Delete a category from local storage
  /// Throws [Exception] on failure
  Future<void> deleteCategory(String category);
}
