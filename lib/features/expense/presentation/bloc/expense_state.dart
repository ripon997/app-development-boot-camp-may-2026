part of 'expense_bloc.dart';

enum ExpenseStatus { initial, loading, success, failure }

class ExpenseState extends Equatable {
  final ExpenseStatus status;
  final List<Expense> expenses;
  final String? errorMessage;
  final String? successMessage;

  const ExpenseState({
    this.status = ExpenseStatus.initial,
    this.expenses = const [],
    this.errorMessage,
    this.successMessage,
  });

  double get totalIncome => expenses
      .where((e) => e.isIncome)
      .fold(0, (sum, e) => sum + e.amount);

  double get totalExpense => expenses
      .where((e) => !e.isIncome)
      .fold(0, (sum, e) => sum + e.amount);

  double get balance => totalIncome - totalExpense;

  ExpenseState copyWith({
    ExpenseStatus? status,
    List<Expense>? expenses,
    String? errorMessage,
    String? successMessage,
  }) {
    return ExpenseState(
      status: status ?? this.status,
      expenses: expenses ?? this.expenses,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [status, expenses, errorMessage, successMessage];
}
