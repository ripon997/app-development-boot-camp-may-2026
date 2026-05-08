import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../expense/domain/entities/expense.dart';
import '../../../expense/presentation/bloc/expense_bloc.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(const LoadExpenses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async =>
                context.read<ExpenseBloc>().add(const LoadExpenses()),
            child: CustomScrollView(
              slivers: [
                _buildAppBar(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BalanceCard(
                          balance: state.balance,
                          income: state.totalIncome,
                          expense: state.totalExpense,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                label: 'Income',
                                amount: state.totalIncome,
                                icon: Icons.arrow_upward_rounded,
                                iconColor: AppColors.income,
                                iconBg: const Color(0xFFE8F8EE),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                label: 'Expenses',
                                amount: state.totalExpense,
                                icon: Icons.arrow_downward_rounded,
                                iconColor: AppColors.expense,
                                iconBg: const Color(0xFFFDE8E8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _QuickActions(
                          onAddExpense: () =>
                              context.push(AppRoutes.addExpense),
                        ),
                        const SizedBox(height: 24),
                        _MonthlySpendingCard(
                          expenses: state.expenses
                              .where((e) => !e.isIncome)
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                        _RecentTransactions(
                          expenses: state.expenses.take(5).toList(),
                          onSeeAll: () =>
                              context.go(AppRoutes.transactions),
                          onTap: (e) => context.push(
                            '${AppRoutes.expenseDetail}/${e.id}',
                            extra: e,
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addExpense),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      floating: true,
      snap: true,
      elevation: 0,
      toolbarHeight: 64,
      title: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.mintCircle,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.divider),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'MExpense',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.textPrimary,
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

// ── Balance Card ─────────────────────────────────────────────────────────────

class _BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;

  const _BalanceCard({
    required this.balance,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0.00', 'en_US');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF25A85E), Color(0xFF1D8F50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.balanceCard.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TOTAL BALANCE',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${fmt.format(balance)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 80,
                height: 36,
                child: _SparklineChart(income: income, expense: expense),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(
                Icons.credit_card_outlined,
                color: Colors.white70,
                size: 16,
              ),
              SizedBox(width: 6),
              Text(
                'Personal Savings',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SparklineChart extends StatelessWidget {
  final double income;
  final double expense;

  const _SparklineChart({required this.income, required this.expense});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        minX: 0,
        maxX: 5,
        minY: 0,
        maxY: 1,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 0.3),
              FlSpot(1, 0.5),
              FlSpot(2, 0.4),
              FlSpot(3, 0.7),
              FlSpot(4, 0.55),
              FlSpot(5, 0.8),
            ],
            isCurved: true,
            color: Colors.white.withValues(alpha: 0.9),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}

// ── Stat Cards (Income / Expense) ─────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const _StatCard({
    required this.label,
    required this.amount,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0.00', 'en_US');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '\$${fmt.format(amount)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Quick Actions ─────────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  final VoidCallback onAddExpense;

  const _QuickActions({required this.onAddExpense});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.document_scanner_outlined,
                label: 'Scan Receipt',
                onTap: onAddExpense,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.swap_horiz_rounded,
                label: 'Transfer',
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Monthly Spending Chart ────────────────────────────────────────────────────

class _MonthlySpendingCard extends StatelessWidget {
  final List<Expense> expenses;

  const _MonthlySpendingCard({required this.expenses});

  List<double> _last7Months() {
    final now = DateTime.now();
    final totals = List<double>.filled(7, 0);
    for (final e in expenses) {
      final diff = (now.year - e.date.year) * 12 + (now.month - e.date.month);
      if (diff >= 0 && diff < 7) {
        totals[6 - diff] += e.amount;
      }
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final totals = _last7Months();
    final maxY = totals.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monthly Spending',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => context.go(AppRoutes.analytics),
                child: const Text(
                  'View Reports',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (value, meta) {
                        final now = DateTime.now();
                        final month = DateTime(
                          now.year,
                          now.month - (6 - value.toInt()),
                        );
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            DateFormat('MMM').format(month),
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barGroups: List.generate(7, (i) {
                  final isLast = i == 6;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: totals[i] == 0 ? 0.1 : totals[i],
                        color: isLast ? AppColors.primary : AppColors.mintCircle,
                        width: 28,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }),
                maxY: maxY > 0 ? maxY * 1.2 : 100,
                alignment: BarChartAlignment.spaceAround,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Recent Transactions ───────────────────────────────────────────────────────

class _RecentTransactions extends StatelessWidget {
  final List<Expense> expenses;
  final VoidCallback onSeeAll;
  final void Function(Expense) onTap;

  const _RecentTransactions({
    required this.expenses,
    required this.onSeeAll,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: onSeeAll,
              child: const Text(
                'See All',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (expenses.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'No transactions yet',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          )
        else
          ...expenses.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _TransactionTile(expense: e, onTap: () => onTap(e)),
            ),
          ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onTap;

  const _TransactionTile({required this.expense, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0.00', 'en_US');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: expense.category.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                expense.category.icon,
                color: expense.category.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    expense.category.name,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${expense.isIncome ? '+' : '-'}\$${fmt.format(expense.amount)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: expense.isIncome ? AppColors.income : AppColors.expense,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
