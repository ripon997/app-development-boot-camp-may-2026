import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/dashboard_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const LoadDashboard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<DashboardBloc>().add(const LoadDashboard()),
              child: CustomScrollView(
                slivers: [
                  _buildAppBar(context),
                  _buildPeriodToggle(context, state),
                  if (state.status == DashboardStatus.loading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else ...[
                    _buildSpendingBreakdown(context, state),
                    _buildBudgetProgress(context),
                    _buildSpendingTrend(context, state),
                    _buildInsightCards(context),
                    _buildBudgetButton(context),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildAppBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColors.mintCircle),
              child: const Icon(Icons.person_rounded,
                  size: 22, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            const Text(
              'Analytics',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications_outlined,
                  color: AppColors.textPrimary),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildPeriodToggle(
      BuildContext context, DashboardState state) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Container(
          height: 44,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              _PeriodTab(
                label: 'Weekly',
                isSelected: state.period == DashboardPeriod.week,
                onTap: () => context
                    .read<DashboardBloc>()
                    .add(const ChangeDashboardPeriod(DashboardPeriod.week)),
              ),
              _PeriodTab(
                label: 'Monthly',
                isSelected: state.period == DashboardPeriod.month,
                onTap: () => context
                    .read<DashboardBloc>()
                    .add(const ChangeDashboardPeriod(DashboardPeriod.month)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSpendingBreakdown(
      BuildContext context, DashboardState state) {
    final now = DateTime.now();
    final total = state.totalExpense;
    final summaries = state.categorySummaries.take(3).toList();

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 8,
                  offset: Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Spending Breakdown',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary),
                  ),
                  Text(
                    DateFormat('MMMM yyyy').format(now),
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'TOTAL',
                style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              Center(
                child: Text(
                  '\$${total.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 20),
              if (summaries.isEmpty)
                const Center(
                  child: Text('No expense data',
                      style: TextStyle(color: AppColors.textSecondary)),
                )
              else
                ...summaries.map((cs) {
                  final pct = total > 0 ? cs.total / total : 0.0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: cs.category.color, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(cs.category.name,
                              style: const TextStyle(
                                  fontSize: 14, color: AppColors.textPrimary)),
                        ),
                        Text(
                          '\$${cs.total.toStringAsFixed(0)} (${(pct * 100).toStringAsFixed(0)}%)',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildBudgetProgress(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 8,
                  offset: Offset(0, 2)),
            ],
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Budget Progress',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary),
              ),
              SizedBox(height: 18),
              _BudgetBar(
                  label: 'Essentials',
                  percent: 0.82,
                  usedLabel: '82% used',
                  color: AppColors.primary),
              SizedBox(height: 14),
              _BudgetBar(
                  label: 'Lifestyle',
                  percent: 0.45,
                  usedLabel: '45% used',
                  color: Color(0xFF6C63FF)),
              SizedBox(height: 14),
              _BudgetBar(
                  label: 'Dining Out',
                  percent: 0.95,
                  usedLabel: '95% used',
                  color: AppColors.expense,
                  isWarning: true),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSpendingTrend(
      BuildContext context, DashboardState state) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 8,
                  offset: Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Spending Trend',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 140,
                child: state.dailyTotals.isEmpty
                    ? const Center(
                        child: Text('No data',
                            style:
                                TextStyle(color: AppColors.textSecondary)))
                    : LineChart(_buildTrendChart(state)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData _buildTrendChart(DashboardState state) {
    final totals = state.dailyTotals;
    final spots = <FlSpot>[];
    for (var i = 0; i < totals.length; i++) {
      spots.add(FlSpot(i.toDouble(), totals[i].expense));
    }
    final months = ['FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL'];
    return LineChartData(
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        leftTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: totals.length > 6
                ? (totals.length / 6).ceilToDouble()
                : 1,
            getTitlesWidget: (value, meta) {
              final idx = value.toInt();
              if (idx < 0 || idx >= totals.length) {
                return const SizedBox.shrink();
              }
              final isLast = idx == totals.length - 1;
              final label = totals.length <= 6
                  ? months[idx % 6]
                  : DateFormat('d').format(totals[idx].date);
              return Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                      isLast ? FontWeight.w700 : FontWeight.w400,
                  color: isLast
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              );
            },
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: AppColors.primary,
          barWidth: 2.5,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, _, __, idx) {
              final isLast = idx == spots.length - 1;
              return FlDotCirclePainter(
                radius: isLast ? 5 : 3,
                color: AppColors.primary,
                strokeWidth: isLast ? 2 : 0,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.primary.withValues(alpha: 0.06),
          ),
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildInsightCards(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EEFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb_outline_rounded,
                      color: Color(0xFF6C63FF), size: 24),
                  SizedBox(height: 10),
                  Text(
                    'Saving Opportunity',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6C63FF)),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'You spent 15% more on entertainment this month than your average. Consider cutting back next week.',
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6C63FF),
                        height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.trending_up_rounded,
                      color: Colors.white, size: 24),
                  SizedBox(height: 10),
                  Text(
                    'Budget Health',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Great job! You are currently \$450 under your total budget for this month. Keep it up!',
                    style: TextStyle(
                        fontSize: 13, color: Colors.white70, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildBudgetButton(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => context.push(AppRoutes.budget),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28)),
              elevation: 0,
            ),
            icon: const Icon(Icons.pie_chart_outline_rounded, size: 20),
            label: const Text('View Budget Tracking',
                style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }
}

class _PeriodTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodTab(
      {required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _BudgetBar extends StatelessWidget {
  final String label;
  final double percent;
  final String usedLabel;
  final Color color;
  final bool isWarning;

  const _BudgetBar({
    required this.label,
    required this.percent,
    required this.usedLabel,
    required this.color,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary)),
            Text(
              usedLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isWarning ? AppColors.expense : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
