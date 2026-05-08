import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  @override
  List<Object?> get props => [id, name];
}

abstract class DefaultCategories {
  static const List<Category> expenseCategories = [
    Category(id: 'food', name: 'Food & Drink', icon: Icons.restaurant, color: Color(0xFFFF6B6B)),
    Category(id: 'transport', name: 'Transport', icon: Icons.directions_car, color: Color(0xFF4D96FF)),
    Category(id: 'shopping', name: 'Shopping', icon: Icons.shopping_bag, color: Color(0xFFCC5DE8)),
    Category(id: 'health', name: 'Health', icon: Icons.favorite, color: Color(0xFF6BCB77)),
    Category(id: 'entertainment', name: 'Entertainment', icon: Icons.movie, color: Color(0xFFFFD93D)),
    Category(id: 'bills', name: 'Bills', icon: Icons.receipt, color: Color(0xFFFF922B)),
    Category(id: 'education', name: 'Education', icon: Icons.school, color: Color(0xFF6C63FF)),
    Category(id: 'other', name: 'Other', icon: Icons.more_horiz, color: Color(0xFF9E9E9E)),
  ];

  static const List<Category> incomeCategories = [
    Category(id: 'salary', name: 'Salary', icon: Icons.attach_money_rounded, color: Color(0xFF25A85E)),
    Category(id: 'bonus', name: 'Bonus', icon: Icons.card_giftcard_rounded, color: Color(0xFFFFD93D)),
    Category(id: 'freelance', name: 'Freelance', icon: Icons.computer_rounded, color: Color(0xFF6C63FF)),
    Category(id: 'gift', name: 'Gift', icon: Icons.redeem_rounded, color: Color(0xFFCC5DE8)),
  ];

  static const List<Category> all = [
    ...expenseCategories,
    ...incomeCategories,
  ];

  static Category get other => expenseCategories.last;

  static Category findById(String id) =>
      all.firstWhere((c) => c.id == id, orElse: () => other);
}
