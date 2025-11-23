import 'package:dartz/dartz.dart';
import '../../domain/entities/add_transaction_entity.dart';
import '../../domain/repositories/add_transaction_repository.dart';
import '../../../../core/error/failure.dart';
import '../datasources/add_transaction_local_datasource.dart';
import '../models/add_transaction_model.dart';

class AddTransactionRepositoryImpl implements AddTransactionRepository {
  final AddTransactionLocalDataSource localDataSource;

  AddTransactionRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, AddTransactionEntity>> addTransaction(
      AddTransactionEntity transaction) async {
    try {
      final model = AddTransactionModel.fromEntity(transaction);
      final result = await localDataSource.addTransaction(model);
      return Right(result.toEntity());
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AddTransactionEntity>>>
      getAllTransactions() async {
    try {
      final models = await localDataSource.getAllTransactions();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AddTransactionEntity?>> getTransactionById(
      String id) async {
    try {
      final model = await localDataSource.getTransactionById(id);
      return Right(model?.toEntity());
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTransaction(
      AddTransactionEntity transaction) async {
    try {
      final model = AddTransactionModel.fromEntity(transaction);
      await localDataSource.updateTransaction(model);
      return const Right(null);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransactionById(String id) async {
    try {
      await localDataSource.deleteTransactionById(id);
      return const Right(null);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addCategory(String category) async {
    try {
      await localDataSource.addCategory(category);
      return const Right(null);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAllCategories() async {
    try {
      final categories = await localDataSource.getAllCategories();
      return Right(categories);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String category) async {
    try {
      await localDataSource.deleteCategory(category);
      return const Right(null);
    } on Exception catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }
}
