import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class AddExpense implements UseCase<Expense, AddExpenseParams> {
  final ExpenseRepository repository;

  AddExpense(this.repository);

  @override
  Future<Either<Failure, Expense>> call(AddExpenseParams params) {
    return repository.addExpense(params.expense);
  }
}

class AddExpenseParams extends Equatable {
  final Expense expense;

  const AddExpenseParams({required this.expense});

  @override
  List<Object?> get props => [expense];
}
