import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../expense/domain/entities/category.dart';
import '../../../expense/domain/entities/expense.dart';
import '../../../expense/domain/usecases/get_expenses.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetExpenses getExpenses;

  DashboardBloc({required this.getExpenses}) : super(const DashboardState()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<ChangeDashboardPeriod>(_onChangePeriod);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    await _fetchAndProcess(emit, state.period);
  }

  Future<void> _onChangePeriod(
    ChangeDashboardPeriod event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(
      status: DashboardStatus.loading,
      period: event.period,
    ));
    await _fetchAndProcess(emit, event.period);
  }

  Future<void> _fetchAndProcess(
    Emitter<DashboardState> emit,
    DashboardPeriod period,
  ) async {
    final now = DateTime.now();
    final from = _startDateFor(period, now);

    final result = await getExpenses(
      GetExpensesParams(from: from, to: now),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: failure.message,
      )),
      (expenses) {
        final categorySummaries = _buildCategorySummaries(expenses);
        final dailyTotals = _buildDailyTotals(expenses, from, now);
        final totalIncome = expenses
            .where((e) => e.isIncome)
            .fold(0.0, (s, e) => s + e.amount);
        final totalExpense = expenses
            .where((e) => !e.isIncome)
            .fold(0.0, (s, e) => s + e.amount);

        emit(state.copyWith(
          status: DashboardStatus.success,
          categorySummaries: categorySummaries,
          dailyTotals: dailyTotals,
          totalIncome: totalIncome,
          totalExpense: totalExpense,
        ));
      },
    );
  }

  DateTime _startDateFor(DashboardPeriod period, DateTime now) {
    switch (period) {
      case DashboardPeriod.week:
        return now.subtract(const Duration(days: 7));
      case DashboardPeriod.month:
        return DateTime(now.year, now.month, 1);
      case DashboardPeriod.year:
        return DateTime(now.year, 1, 1);
    }
  }

  List<CategorySummary> _buildCategorySummaries(List<Expense> expenses) {
    final map = <String, double>{};
    final countMap = <String, int>{};
    final categoryMap = <String, Category>{};

    for (final e in expenses.where((e) => !e.isIncome)) {
      map[e.category.id] = (map[e.category.id] ?? 0) + e.amount;
      countMap[e.category.id] = (countMap[e.category.id] ?? 0) + 1;
      categoryMap[e.category.id] = e.category;
    }

    return map.entries
        .map((entry) => CategorySummary(
              category: categoryMap[entry.key]!,
              total: entry.value,
              count: countMap[entry.key]!,
            ))
        .toList()
      ..sort((a, b) => b.total.compareTo(a.total));
  }

  List<DailyTotal> _buildDailyTotals(
    List<Expense> expenses,
    DateTime from,
    DateTime to,
  ) {
    final map = <String, DailyTotal>{};
    final days = to.difference(from).inDays + 1;

    for (var i = 0; i < days; i++) {
      final date = from.add(Duration(days: i));
      final key =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      map[key] = DailyTotal(date: date, income: 0, expense: 0);
    }

    for (final e in expenses) {
      final key =
          '${e.date.year}-${e.date.month.toString().padLeft(2, '0')}-${e.date.day.toString().padLeft(2, '0')}';
      final existing = map[key];
      if (existing != null) {
        map[key] = DailyTotal(
          date: existing.date,
          income: existing.income + (e.isIncome ? e.amount : 0),
          expense: existing.expense + (!e.isIncome ? e.amount : 0),
        );
      }
    }

    return map.values.toList()..sort((a, b) => a.date.compareTo(b.date));
  }
}
