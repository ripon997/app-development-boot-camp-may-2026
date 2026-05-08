part of 'expense_bloc.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class LoadExpenses extends ExpenseEvent {
  const LoadExpenses();
}

class LoadExpensesByDateRange extends ExpenseEvent {
  final DateTime from;
  final DateTime to;

  const LoadExpensesByDateRange({required this.from, required this.to});

  @override
  List<Object?> get props => [from, to];
}

class LoadExpensesByCategory extends ExpenseEvent {
  final String categoryId;

  const LoadExpensesByCategory({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class AddExpenseEvent extends ExpenseEvent {
  final Expense expense;

  const AddExpenseEvent({required this.expense});

  @override
  List<Object?> get props => [expense];
}

class UpdateExpenseEvent extends ExpenseEvent {
  final Expense expense;

  const UpdateExpenseEvent({required this.expense});

  @override
  List<Object?> get props => [expense];
}

class DeleteExpenseEvent extends ExpenseEvent {
  final String id;

  const DeleteExpenseEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
