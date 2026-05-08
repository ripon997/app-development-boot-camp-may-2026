import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/expense_repository.dart';

class DeleteExpense implements UseCase<String, DeleteExpenseParams> {
  final ExpenseRepository repository;

  DeleteExpense(this.repository);

  @override
  Future<Either<Failure, String>> call(DeleteExpenseParams params) {
    return repository.deleteExpense(params.id);
  }
}

class DeleteExpenseParams extends Equatable {
  final String id;

  const DeleteExpenseParams({required this.id});

  @override
  List<Object?> get props => [id];
}
