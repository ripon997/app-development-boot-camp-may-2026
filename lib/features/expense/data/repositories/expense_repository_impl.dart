import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_datasource.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;

  const ExpenseRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Expense>>> getExpenses() async {
    return _tryCatch(() => localDataSource.getExpenses());
  }

  @override
  Future<Either<Failure, Expense>> addExpense(Expense expense) async {
    return _tryCatch(() => localDataSource.addExpense(expense));
  }

  @override
  Future<Either<Failure, Expense>> updateExpense(Expense expense) async {
    return _tryCatch(() => localDataSource.updateExpense(expense));
  }

  @override
  Future<Either<Failure, String>> deleteExpense(String id) async {
    return _tryCatch(() => localDataSource.deleteExpense(id));
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpensesByDateRange(
    DateTime from,
    DateTime to,
  ) async {
    return _tryCatch(() => localDataSource.getExpensesByDateRange(from, to));
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpensesByCategory(
    String categoryId,
  ) async {
    return _tryCatch(() => localDataSource.getExpensesByCategory(categoryId));
  }

  Future<Either<Failure, T>> _tryCatch<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
