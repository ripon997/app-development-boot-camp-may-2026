import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/expense.dart';
import '../bloc/expense_bloc.dart';

class ExpenseDetailPage extends StatelessWidget {
  final Expense expense;

  const ExpenseDetailPage({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final amountColor = expense.isIncome ? AppColors.income : AppColors.expense;
    final amountPrefix = expense.isIncome ? '+' : '-';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Details'),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(
              '${AppRoutes.editExpense}/${expense.id}',
              extra: expense,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.expense),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _HeroCard(
              expense: expense,
              amountColor: amountColor,
              amountPrefix: amountPrefix,
            ),
            const SizedBox(height: 16),
            _DetailCard(expense: expense),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Expense'),
        content: Text('Are you sure you want to delete "${expense.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.expense),
            onPressed: () {
              Navigator.of(ctx).pop();
              context
                  .read<ExpenseBloc>()
                  .add(DeleteExpenseEvent(id: expense.id));
              context.pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final Expense expense;
  final Color amountColor;
  final String amountPrefix;

  const _HeroCard({
    required this.expense,
    required this.amountColor,
    required this.amountPrefix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: expense.category.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(expense.category.icon,
                color: expense.category.color, size: 30),
          ),
          const SizedBox(height: 16),
          Text(expense.title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            '$amountPrefix\$${expense.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: amountColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: (expense.isIncome ? AppColors.income : AppColors.expense)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              expense.isIncome ? 'Income' : 'Expense',
              style: TextStyle(
                color: amountColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final Expense expense;

  const _DetailCard({required this.expense});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          _DetailRow(
            label: 'Category',
            value: expense.category.name,
            icon: expense.category.icon,
            iconColor: expense.category.color,
          ),
          const Divider(height: 24),
          _DetailRow(
            label: 'Date',
            value: DateFormat('EEEE, MMMM d, yyyy').format(expense.date),
            icon: Icons.calendar_today_outlined,
          ),
          if (expense.note != null && expense.note!.isNotEmpty) ...[
            const Divider(height: 24),
            _DetailRow(
              label: 'Note',
              value: expense.note!,
              icon: Icons.notes_outlined,
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon,
              color: iconColor ?? AppColors.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
