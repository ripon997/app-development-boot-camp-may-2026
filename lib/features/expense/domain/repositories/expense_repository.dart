import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, List<Expense>>> getExpenses();
  Future<Either<Failure, Expense>> addExpense(Expense expense);
  Future<Either<Failure, Expense>> updateExpense(Expense expense);
  Future<Either<Failure, String>> deleteExpense(String id);
  Future<Either<Failure, List<Expense>>> getExpensesByDateRange(
    DateTime from,
    DateTime to,
  );
  Future<Either<Failure, List<Expense>>> getExpensesByCategory(String categoryId);
}
