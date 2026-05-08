


import 'package:hive_ce/hive_ce.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/expense.dart';

// typeId must be unique across all your Hive adapters
const int kExpenseTypeId = 0;

class ExpenseHiveModel {
  final String id;
  final String title;
  final double amount;
  final int dateMs;
  final String categoryId;
  final String? note;
  final bool isIncome;

  const ExpenseHiveModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.dateMs,
    required this.categoryId,
    this.note,
    required this.isIncome,
  });

  factory ExpenseHiveModel.fromExpense(Expense e) => ExpenseHiveModel(
        id: e.id,
        title: e.title,
        amount: e.amount,
        dateMs: e.date.millisecondsSinceEpoch,
        categoryId: e.category.id,
        note: e.note,
        isIncome: e.isIncome,
      );

  Expense toExpense() => Expense(
        id: id,
        title: title,
        amount: amount,
        date: DateTime.fromMillisecondsSinceEpoch(dateMs),
        category: DefaultCategories.findById(categoryId),
        note: note,
        isIncome: isIncome,
      );
}

// Manually written adapter — no code generation needed
class ExpenseHiveAdapter extends TypeAdapter<ExpenseHiveModel> {
  @override
  final int typeId = kExpenseTypeId; // Must match the const above

  @override
  ExpenseHiveModel read(BinaryReader reader) {
    final id = reader.readString();
    final title = reader.readString();
    final amount = reader.readDouble();
    final dateMs = reader.readInt();
    final categoryId = reader.readString();
    final hasNote = reader.readBool();
    final note = hasNote ? reader.readString() : null;
    final isIncome = reader.readBool();

    return ExpenseHiveModel(
      id: id,
      title: title,
      amount: amount,
      dateMs: dateMs,
      categoryId: categoryId,
      note: note,
      isIncome: isIncome,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseHiveModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeDouble(obj.amount);
    writer.writeInt(obj.dateMs);
    writer.writeString(obj.categoryId);
    writer.writeBool(obj.note != null);
    if (obj.note != null) writer.writeString(obj.note!);
    writer.writeBool(obj.isIncome);
  }
}