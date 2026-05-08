import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class UpdateExpense implements UseCase<Expense, UpdateExpenseParams> {
  final ExpenseRepository repository;

  UpdateExpense(this.repository);

  @override
  Future<Either<Failure, Expense>> call(UpdateExpenseParams params) {
    return repository.updateExpense(params.expense);
  }
}

class UpdateExpenseParams extends Equatable {
  final Expense expense;

  const UpdateExpenseParams({required this.expense});

  @override
  List<Object?> get props => [expense];
}
