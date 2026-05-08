abstract class AppConstants {
  static const String appName = 'MExpense';
  static const String expenseBoxName = 'expenses_box';
  static const String categoryBoxName = 'categories_box';
  static const String settingsBoxName = 'settings_box';
}

abstract class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/';
  static const String analytics = '/analytics';
  static const String budget = '/budget';
  static const String transactions = '/transactions';
  static const String profile = '/profile';
  static const String categories = '/categories';
  static const String addExpense = '/expense/add';
  static const String editExpense = '/expense/edit';
  static const String expenseDetail = '/expense/detail';
  static const String addIncome = '/income/add';
  static const String dashboard = '/dashboard';
}
