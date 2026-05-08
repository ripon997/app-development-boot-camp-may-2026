import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class GetExpenses implements UseCase<List<Expense>, GetExpensesParams> {
  final ExpenseRepository repository;

  GetExpenses(this.repository);

  @override
  Future<Either<Failure, List<Expense>>> call(GetExpensesParams params) {
    if (params.from != null && params.to != null) {
      return repository.getExpensesByDateRange(params.from!, params.to!);
    }
    if (params.categoryId != null) {
      return repository.getExpensesByCategory(params.categoryId!);
    }
    return repository.getExpenses();
  }
}

class GetExpensesParams extends Equatable {
  final DateTime? from;
  final DateTime? to;
  final String? categoryId;

  const GetExpensesParams({this.from, this.to, this.categoryId});

  const GetExpensesParams.all() : from = null, to = null, categoryId = null;

  @override
  List<Object?> get props => [from, to, categoryId];
}
