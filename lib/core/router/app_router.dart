import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/budget/presentation/pages/budget_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/expense/domain/entities/expense.dart';
import '../../features/expense/presentation/pages/add_expense_page.dart';
import '../../features/expense/presentation/pages/add_income_page.dart';
import '../../features/expense/presentation/pages/categories_page.dart';
import '../../features/expense/presentation/pages/expense_detail_page.dart';
import '../../features/expense/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/home_tab_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';

class AppRouter {
  GoRouter get router => _router;

  final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [
      // ── Auth flow ────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (_, __) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (_, __) => const RegisterPage(),
      ),

      // ── Main shell with bottom nav ───────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) =>
            _MainShell(location: state.uri.toString(), child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (_, __) => const HomeTabPage(),
          ),
          GoRoute(
            path: AppRoutes.analytics,
            name: 'analytics',
            builder: (_, __) => const DashboardPage(),
          ),
          GoRoute(
            path: AppRoutes.budget,
            name: 'budget',
            builder: (_, __) => const BudgetPage(),
          ),
          GoRoute(
            path: AppRoutes.transactions,
            name: 'transactions',
            builder: (_, __) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (_, __) => const ProfilePage(),
          ),
          GoRoute(
            path: AppRoutes.categories,
            name: 'categories',
            builder: (_, __) => const CategoriesPage(),
          ),
        ],
      ),

      // ── Expense / Income flows (full-screen, above shell) ─────────────────
      GoRoute(
        path: AppRoutes.addExpense,
        name: 'addExpense',
        builder: (_, __) => const AddExpensePage(),
      ),
      GoRoute(
        path: '${AppRoutes.editExpense}/:id',
        name: 'editExpense',
        builder: (context, state) {
          final expense = state.extra as Expense;
          return AddExpensePage(expenseToEdit: expense);
        },
      ),
      GoRoute(
        path: '${AppRoutes.expenseDetail}/:id',
        name: 'expenseDetail',
        builder: (context, state) {
          final expense = state.extra as Expense;
          return ExpenseDetailPage(expense: expense);
        },
      ),
      GoRoute(
        path: AppRoutes.addIncome,
        name: 'addIncome',
        builder: (_, __) => const AddIncomePage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}

// ── Main shell with 4-tab bottom navigation ──────────────────────────────────

class _MainShell extends StatelessWidget {
  final String location;
  final Widget child;

  const _MainShell({required this.location, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _BottomNavBar(location: location),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final String location;

  const _BottomNavBar({required this.location});

  int get _selectedIndex {
    if (location.startsWith(AppRoutes.analytics) ||
        location.startsWith(AppRoutes.budget)) {
      return 1;
    }
    if (location.startsWith(AppRoutes.transactions)) {
      return 2;
    }
    if (location.startsWith(AppRoutes.profile) ||
        location.startsWith(AppRoutes.categories)) {
      return 3;
    }
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
      case 1:
        context.go(AppRoutes.analytics);
      case 2:
        context.go(AppRoutes.transactions);
      case 3:
        context.go(AppRoutes.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => _onTap(context, i),
        backgroundColor: AppColors.surface,
        elevation: 0,
        height: 64,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_rounded),
            selectedIcon: Icon(Icons.show_chart_rounded),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
