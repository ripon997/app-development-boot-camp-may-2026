import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/expense.dart';
import '../bloc/expense_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _activeFilter = 'This Month';

  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(const LoadExpenses());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildAppBar(),
                _buildSearchBar(),
                _buildFilterChips(),
                Expanded(
                  child: BlocConsumer<ExpenseBloc, ExpenseState>(
                    listener: (context, state) {
                      if (state.status == ExpenseStatus.failure &&
                          state.errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.errorMessage!),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state.status == ExpenseStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final filtered = _filterExpenses(state.expenses);
                      if (filtered.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.receipt_long_outlined,
                                  size: 64, color: AppColors.textSecondary),
                              SizedBox(height: 16),
                              Text(
                                'No transactions found',
                                style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: () async =>
                            context.read<ExpenseBloc>().add(const LoadExpenses()),
                        child: _buildGroupedList(filtered),
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 28,
              right: 20,
              child: FloatingActionButton(
                onPressed: () => context.push(AppRoutes.addExpense),
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                child: const Icon(Icons.add_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
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
            'Transactions',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
        decoration: InputDecoration(
          hintText: 'Search transactions...',
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          prefixIcon: const Icon(Icons.search_rounded,
              color: AppColors.textSecondary, size: 22),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['This Month', 'Category', 'Type', 'Me'];
    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final f = filters[i];
          final selected = _activeFilter == f;
          return GestureDetector(
            onTap: () => setState(() => _activeFilter = f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.divider,
                ),
              ),
              child: Text(
                f,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGroupedList(List<Expense> expenses) {
    final grouped = _groupByDate(expenses);
    final keys = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final dateKey = keys[index];
        final items = grouped[dateKey]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 6),
              child: Text(
                _headerLabel(dateKey).toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: 8,
                      offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                children: [
                  for (int i = 0; i < items.length; i++) ...[
                    if (i > 0)
                      const Divider(
                          height: 1,
                          indent: 72,
                          endIndent: 16,
                          color: AppColors.divider),
                    _TransactionTile(expense: items[i]),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
        );
      },
    );
  }

  List<Expense> _filterExpenses(List<Expense> all) {
    var list = all;
    if (_searchQuery.isNotEmpty) {
      list = list
          .where((e) =>
              e.title.toLowerCase().contains(_searchQuery) ||
              e.category.name.toLowerCase().contains(_searchQuery))
          .toList();
    }
    if (_activeFilter == 'This Month') {
      final now = DateTime.now();
      list = list
          .where((e) =>
              e.date.year == now.year && e.date.month == now.month)
          .toList();
    } else if (_activeFilter == 'Category') {
      // no-op: show all, could add category filter sheet
    } else if (_activeFilter == 'Type') {
      // no-op: show all, could add type filter
    }
    return list;
  }

  Map<String, List<Expense>> _groupByDate(List<Expense> expenses) {
    final map = <String, List<Expense>>{};
    for (final e in expenses) {
      final key = DateFormat('yyyy-MM-dd').format(e.date);
      map.putIfAbsent(key, () => []).add(e);
    }
    return map;
  }

  String _headerLabel(String dateKey) {
    final date = DateTime.parse(dateKey);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) return 'Today';
    if (d == yesterday) return 'Yesterday';
    return DateFormat('MMMM d').format(date);
  }
}

class _TransactionTile extends StatelessWidget {
  final Expense expense;

  const _TransactionTile({required this.expense});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: expense.category.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(expense.category.icon,
                color: expense.category.color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 3),
                Text(
                  '${DateFormat('hh:mm a').format(expense.date)} • ${expense.category.name}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            '${expense.isIncome ? '+' : '-'}\$${expense.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: expense.isIncome ? AppColors.income : AppColors.expense,
            ),
          ),
        ],
      ),
    );
  }
}
