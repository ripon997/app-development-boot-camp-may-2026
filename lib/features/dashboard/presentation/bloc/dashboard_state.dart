part of 'dashboard_bloc.dart';

enum DashboardPeriod { week, month, year }

enum DashboardStatus { initial, loading, success, failure }

class CategorySummary {
  final Category category;
  final double total;
  final int count;

  const CategorySummary({
    required this.category,
    required this.total,
    required this.count,
  });
}

class DailyTotal {
  final DateTime date;
  final double income;
  final double expense;

  const DailyTotal({
    required this.date,
    required this.income,
    required this.expense,
  });
}

class DashboardState extends Equatable {
  final DashboardStatus status;
  final DashboardPeriod period;
  final List<CategorySummary> categorySummaries;
  final List<DailyTotal> dailyTotals;
  final double totalIncome;
  final double totalExpense;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.period = DashboardPeriod.month,
    this.categorySummaries = const [],
    this.dailyTotals = const [],
    this.totalIncome = 0,
    this.totalExpense = 0,
    this.errorMessage,
  });

  double get balance => totalIncome - totalExpense;
  double get savingsRate =>
      totalIncome > 0 ? ((totalIncome - totalExpense) / totalIncome) * 100 : 0;

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardPeriod? period,
    List<CategorySummary>? categorySummaries,
    List<DailyTotal>? dailyTotals,
    double? totalIncome,
    double? totalExpense,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      period: period ?? this.period,
      categorySummaries: categorySummaries ?? this.categorySummaries,
      dailyTotals: dailyTotals ?? this.dailyTotals,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        period,
        categorySummaries,
        dailyTotals,
        totalIncome,
        totalExpense,
        errorMessage,
      ];
}
