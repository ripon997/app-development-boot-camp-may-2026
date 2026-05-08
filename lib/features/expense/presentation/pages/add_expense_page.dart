import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/expense.dart';
import '../bloc/expense_bloc.dart';

class AddExpensePage extends StatefulWidget {
  final Expense? expenseToEdit;

  const AddExpensePage({super.key, this.expenseToEdit});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  late Category _selectedCategory;
  late DateTime _selectedDate;
  String _paymentMethod = 'Credit Card';

  bool get _isEditing => widget.expenseToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final e = widget.expenseToEdit!;
      _amountCtrl.text = e.amount.toStringAsFixed(2);
      _noteCtrl.text = e.note ?? '';
      _selectedCategory = e.category;
      _selectedDate = e.date;
    } else {
      _selectedCategory = DefaultCategories.expenseCategories.first;
      _selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state.status == ExpenseStatus.success && state.successMessage != null) {
            context.pop();
          }
          if (state.status == ExpenseStatus.failure && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!), backgroundColor: AppColors.error),
            );
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAmountSection(),
                      const SizedBox(height: 24),
                      _buildCategorySection(),
                      const SizedBox(height: 20),
                      _buildDateField(),
                      const SizedBox(height: 20),
                      _buildPaymentMethod(),
                      const SizedBox(height: 20),
                      _buildNotesField(),
                      const SizedBox(height: 20),
                      _buildAttachBox(),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              _buildSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary, size: 22),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: Text(
              _isEditing ? 'Edit Expense' : 'Add Expense',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildAmountSection() {
    return Center(
      child: Column(
        children: [
          const Text(
            'AMOUNT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '\$',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 4),
              IntrinsicWidth(
                child: TextField(
                  controller: _amountCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    hintText: '0.00',
                    hintStyle: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w300,
                      color: AppColors.textSecondary,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 84,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: DefaultCategories.expenseCategories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final cat = DefaultCategories.expenseCategories[index];
              final isSelected = _selectedCategory.id == cat.id;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? cat.color.withValues(alpha: 0.2)
                            : cat.color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: cat.color, width: 2.5)
                            : null,
                      ),
                      child: Icon(cat.icon, color: cat.color, size: 24),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _shortName(cat.name),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? cat.color : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _shortName(String name) {
    final map = {
      'Food & Drink': 'Dining',
      'Transport': 'Transport',
      'Shopping': 'Shopping',
      'Health': 'Health',
      'Entertainment': 'Entertain',
      'Bills': 'Bills',
      'Education': 'Education',
      'Other': 'Other',
    };
    return map[name] ?? name;
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Color(0x06000000), blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_outlined, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 12),
                Text(
                  DateFormat('MMM dd, yyyy').format(_selectedDate),
                  style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _PaymentChip(
              icon: Icons.credit_card_rounded,
              label: 'Credit Card',
              isSelected: _paymentMethod == 'Credit Card',
              onTap: () => setState(() => _paymentMethod = 'Credit Card'),
            ),
            const SizedBox(width: 12),
            _PaymentChip(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Cash',
              isSelected: _paymentMethod == 'Cash',
              onTap: () => setState(() => _paymentMethod = 'Cash'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notes (Optional)',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _noteCtrl,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'What was this for?',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachBox() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFCCCCCC), style: BorderStyle.solid),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, size: 30, color: AppColors.textSecondary),
            SizedBox(height: 8),
            Text(
              'Attach Receipt',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          final isLoading = state.status == ExpenseStatus.loading;
          return SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                elevation: 0,
              ),
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.check_circle_outline_rounded, size: 22),
              label: Text(
                _isEditing ? 'Update Expense' : 'Save Expense',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _save() {
    final amount = double.tryParse(_amountCtrl.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }
    final expense = Expense(
      id: widget.expenseToEdit?.id ?? const Uuid().v4(),
      title: _selectedCategory.name,
      amount: amount,
      date: _selectedDate,
      category: _selectedCategory,
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      isIncome: false,
    );
    if (_isEditing) {
      context.read<ExpenseBloc>().add(UpdateExpenseEvent(expense: expense));
    } else {
      context.read<ExpenseBloc>().add(AddExpenseEvent(expense: expense));
    }
  }
}

class _PaymentChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accent : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.accent : AppColors.divider,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: isSelected ? Colors.white : AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
