import 'package:equatable/equatable.dart';
import 'category.dart';

class Expense extends Equatable {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;
  final String? note;
  final bool isIncome;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.note,
    this.isIncome = false,
  });

  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    Category? category,
    String? note,
    bool? isIncome,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      note: note ?? this.note,
      isIncome: isIncome ?? this.isIncome,
    );
  }

  @override
  List<Object?> get props => [id, title, amount, date, category, note, isIncome];
}
