import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_datasource.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> addTransaction(
      TransactionEntity transaction) async {
    try {
      await localDataSource.addTransaction(transaction);
      return const Right(null);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getAllTransactions() async {
    try {
      final transactions = await localDataSource.getAllTransactions();
      return Right(transactions);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TransactionEntity?>> getTransactionById(
      String id) async {
    try {
      final transaction = await localDataSource.getTransactionById(id);
      return Right(transaction);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTransaction(
      String id, TransactionEntity transaction) async {
    try {
      await localDataSource.updateTransaction(id, transaction);
      return const Right(null);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      await localDataSource.deleteTransaction(id);
      return const Right(null);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllTransactions() async {
    try {
      await localDataSource.deleteAllTransactions();
      return const Right(null);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }
}
