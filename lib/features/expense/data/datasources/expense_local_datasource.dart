
import 'package:uuid/uuid.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/expense.dart';
import '../models/expense_hive_model.dart';
import 'package:hive_ce/hive.dart';

abstract class ExpenseLocalDataSource {
  Future<List<Expense>> getExpenses();
  Future<Expense> addExpense(Expense expense);
  Future<Expense> updateExpense(Expense expense);
  Future<String> deleteExpense(String id);
  Future<List<Expense>> getExpensesByDateRange(DateTime from, DateTime to);
  Future<List<Expense>> getExpensesByCategory(String categoryId);
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final Box<ExpenseHiveModel> _box;

  ExpenseLocalDataSourceImpl(this._box) {
    if (_box.isEmpty) _seedDummyData();
  }

  List<Expense> _sorted(Iterable<ExpenseHiveModel> models) {
    final list = models.map((m) => m.toExpense()).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<List<Expense>> getExpenses() async =>
      _sorted(_box.values);

  @override
  Future<Expense> addExpense(Expense expense) async {
    final model = ExpenseHiveModel.fromExpense(
      expense.copyWith(id: const Uuid().v4()),
    );
    await _box.put(model.id, model);
    return model.toExpense();
  }

  @override
  Future<Expense> updateExpense(Expense expense) async {
    if (!_box.containsKey(expense.id)) {
      throw const NotFoundException(message: 'Expense not found');
    }
    final model = ExpenseHiveModel.fromExpense(expense);
    await _box.put(expense.id, model);
    return expense;
  }

  @override
  Future<String> deleteExpense(String id) async {
    if (!_box.containsKey(id)) {
      throw const NotFoundException(message: 'Expense not found');
    }
    await _box.delete(id);
    return id;
  }

  @override
  Future<List<Expense>> getExpensesByDateRange(
      DateTime from, DateTime to) async {
    return _sorted(
      _box.values.where(
        (m) =>
            m.dateMs >= from.millisecondsSinceEpoch &&
            m.dateMs <= to.millisecondsSinceEpoch,
      ),
    );
  }

  @override
  Future<List<Expense>> getExpensesByCategory(String categoryId) async {
    return _sorted(
      _box.values.where((m) => m.categoryId == categoryId),
    );
  }

  void _seedDummyData() {
    final now = DateTime.now();
    final seeds = [
      _seed('Grocery Shopping', 85.50, now.subtract(const Duration(days: 1)),
          'food', note: 'Weekly groceries from Whole Foods'),
      _seed('Uber Ride', 18.75, now.subtract(const Duration(days: 1)),
          'transport'),
      _seed('Netflix Subscription', 15.99,
          now.subtract(const Duration(days: 2)), 'entertainment'),
      _seed('Monthly Salary', 4500.00, now.subtract(const Duration(days: 3)),
          'other',
          note: 'August salary', isIncome: true),
      _seed('Electricity Bill', 120.00,
          now.subtract(const Duration(days: 4)), 'bills'),
      _seed('Gym Membership', 49.99, now.subtract(const Duration(days: 5)),
          'health'),
      _seed('New Shoes', 89.00, now.subtract(const Duration(days: 6)),
          'shopping'),
      _seed('Online Course', 29.99, now.subtract(const Duration(days: 7)),
          'education',
          note: 'Flutter advanced course'),
      _seed('Lunch with Team', 42.00, now.subtract(const Duration(days: 8)),
          'food'),
      _seed('Internet Bill', 60.00, now.subtract(const Duration(days: 9)),
          'bills'),
      _seed('Freelance Payment', 800.00,
          now.subtract(const Duration(days: 10)), 'other',
          isIncome: true),
      _seed('Pharmacy', 35.20, now.subtract(const Duration(days: 12)),
          'health'),
      _seed('Movie Tickets', 28.00, now.subtract(const Duration(days: 14)),
          'entertainment'),
      _seed('Coffee Shop', 12.50, now.subtract(const Duration(days: 15)),
          'food'),
      _seed('Bus Pass', 55.00, now.subtract(const Duration(days: 16)),
          'transport'),
    ];
    final map = {for (final m in seeds) m.id: m};
    _box.putAll(map);
  }

  ExpenseHiveModel _seed(
    String title,
    double amount,
    DateTime date,
    String categoryId, {
    String? note,
    bool isIncome = false,
  }) {
    return ExpenseHiveModel(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      dateMs: date.millisecondsSinceEpoch,
      categoryId: categoryId,
      note: note,
      isIncome: isIncome,
    );
  }
}
