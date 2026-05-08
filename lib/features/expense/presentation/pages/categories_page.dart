import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/category.dart';
import '../bloc/expense_bloc.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(const LoadExpenses());
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
                Expanded(
                  child: BlocBuilder<ExpenseBloc, ExpenseState>(
                    builder: (context, state) {
                      final counts = _countByCategory(state);
                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                        child: Column(
                          children: [
                            ...DefaultCategories.expenseCategories.map(
                              (cat) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _CategoryCard(
                                  category: cat,
                                  count: counts[cat.id] ?? 0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildSpendingTip(state),
                          ],
                        ),
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
                onPressed: () {},
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
      padding: const EdgeInsets.fromLTRB(20, 8, 12, 0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.mintCircle),
            child: const Icon(Icons.person_rounded, size: 22, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 4),
                  Text(
                    'Add\nNew',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildSpendingTip(ExpenseState state) {
    final topCat = _topCategory(state);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Spending Tip',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13, color: Colors.white70, height: 1.5),
              children: [
                const TextSpan(text: 'Most of your expenses this month fall under '),
                TextSpan(
                  text: topCat,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(text: '. Consider setting a category limit.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, int> _countByCategory(ExpenseState state) {
    final counts = <String, int>{};
    for (final e in state.expenses) {
      if (!e.isIncome) {
        counts[e.category.id] = (counts[e.category.id] ?? 0) + 1;
      }
    }
    return counts;
  }

  String _topCategory(ExpenseState state) {
    final counts = _countByCategory(state);
    if (counts.isEmpty) return 'Shopping';
    final topId = counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    return DefaultCategories.findById(topId).name;
  }
}

class _CategoryCard extends StatelessWidget {
  final Category category;
  final int count;

  const _CategoryCard({required this.category, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: category.color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(category.icon, color: category.color, size: 26),
        ),
        title: Text(
          category.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          '$count Transaction${count == 1 ? '' : 's'}',
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
        onTap: () {},
      ),
    );
  }
}
