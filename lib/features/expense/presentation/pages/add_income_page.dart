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

class AddIncomePage extends StatefulWidget {
  const AddIncomePage({super.key});

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  Category _selectedCategory = DefaultCategories.incomeCategories.first;
  DateTime _selectedDate = DateTime.now();

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
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAmountSection(),
                      const SizedBox(height: 28),
                      _buildCategorySection(),
                      const SizedBox(height: 24),
                      _buildDateField(),
                      const SizedBox(height: 20),
                      _buildNotesField(),
                      const SizedBox(height: 20),
                      _buildAttachBox(),
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
          const Expanded(
            child: Text(
              'Add Income',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: AppColors.textSecondary, size: 22),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection() {
    return Column(
      children: [
        const Text(
          'ENTER AMOUNT',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
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
                  color: AppColors.textSecondary,
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
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.accent, width: 2),
                  ),
                  contentPadding: EdgeInsets.only(bottom: 4),
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ],
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
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.6,
          children: DefaultCategories.incomeCategories.map((cat) {
            final isSelected = _selectedCategory.id == cat.id;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.divider,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: const [
                    BoxShadow(color: Color(0x06000000), blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: cat.color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(cat.icon, color: cat.color, size: 22),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cat.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date of Transaction',
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
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_outlined, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    DateFormat('MM/dd/yyyy').format(_selectedDate),
                    style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
                  ),
                ),
                const Icon(Icons.calendar_today_outlined, color: AppColors.textSecondary, size: 18),
              ],
            ),
          ),
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
            hintText: 'Add details about this income...',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            prefixIcon: const Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 0, 0),
              child: Icon(Icons.edit_note_rounded, color: AppColors.textSecondary, size: 22),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 44),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.divider)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.divider)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
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
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider, style: BorderStyle.solid, width: 1.5),
        ),
        child: const Column(
          children: [
            Icon(Icons.add_a_photo_outlined, size: 32, color: AppColors.textSecondary),
            SizedBox(height: 10),
            Text(
              'Attach Proof of Income',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
            SizedBox(height: 4),
            Text(
              'PDF, JPG, or PNG up to 5MB',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
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
                backgroundColor: AppColors.primary,
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
              label: const Text(
                'Save Income',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
      id: const Uuid().v4(),
      title: _selectedCategory.name,
      amount: amount,
      date: _selectedDate,
      category: _selectedCategory,
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      isIncome: true,
    );
    context.read<ExpenseBloc>().add(AddExpenseEvent(expense: expense));
  }
}
