import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/expense.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/delete_expense.dart';
import '../../domain/usecases/get_expenses.dart';
import '../../domain/usecases/update_expense.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final GetExpenses getExpenses;
  final AddExpense addExpense;
  final UpdateExpense updateExpense;
  final DeleteExpense deleteExpense;

  ExpenseBloc({
    required this.getExpenses,
    required this.addExpense,
    required this.updateExpense,
    required this.deleteExpense,
  }) : super(const ExpenseState()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<LoadExpensesByDateRange>(_onLoadExpensesByDateRange);
    on<LoadExpensesByCategory>(_onLoadExpensesByCategory);
    on<AddExpenseEvent>(_onAddExpense);
    on<UpdateExpenseEvent>(_onUpdateExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
  }

  Future<void> _onLoadExpenses(
    LoadExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(state.copyWith(status: ExpenseStatus.loading));
    final result = await getExpenses(const GetExpensesParams.all());
    result.fold(
      (failure) => emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: failure.message,
      )),
      (expenses) => emit(state.copyWith(
        status: ExpenseStatus.success,
        expenses: expenses,
      )),
    );
  }

  Future<void> _onLoadExpensesByDateRange(
    LoadExpensesByDateRange event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(state.copyWith(status: ExpenseStatus.loading));
    final result = await getExpenses(
      GetExpensesParams(from: event.from, to: event.to),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: failure.message,
      )),
      (expenses) => emit(state.copyWith(
        status: ExpenseStatus.success,
        expenses: expenses,
      )),
    );
  }

  Future<void> _onLoadExpensesByCategory(
    LoadExpensesByCategory event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(state.copyWith(status: ExpenseStatus.loading));
    final result = await getExpenses(
      GetExpensesParams(categoryId: event.categoryId),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: failure.message,
      )),
      (expenses) => emit(state.copyWith(
        status: ExpenseStatus.success,
        expenses: expenses,
      )),
    );
  }

  Future<void> _onAddExpense(
    AddExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    final result = await addExpense(AddExpenseParams(expense: event.expense));
    result.fold(
      (failure) => emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: failure.message,
      )),
      (expense) {
        final updated = [expense, ...state.expenses];
        emit(state.copyWith(
          status: ExpenseStatus.success,
          expenses: updated,
          successMessage: 'Expense added successfully',
        ));
      },
    );
  }

  Future<void> _onUpdateExpense(
    UpdateExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    final result =
        await updateExpense(UpdateExpenseParams(expense: event.expense));
    result.fold(
      (failure) => emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: failure.message,
      )),
      (updated) {
        final expenses = state.expenses.map((e) {
          return e.id == updated.id ? updated : e;
        }).toList();
        emit(state.copyWith(
          status: ExpenseStatus.success,
          expenses: expenses,
          successMessage: 'Expense updated successfully',
        ));
      },
    );
  }

  Future<void> _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    final result = await deleteExpense(DeleteExpenseParams(id: event.id));
    result.fold(
      (failure) => emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: failure.message,
      )),
      (id) {
        final expenses = state.expenses.where((e) => e.id != id).toList();
        emit(state.copyWith(
          status: ExpenseStatus.success,
          expenses: expenses,
          successMessage: 'Expense deleted',
        ));
      },
    );
  }
}
