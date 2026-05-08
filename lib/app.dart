import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/expense/presentation/bloc/expense_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExpenseBloc>(
          create: (_) => sl<ExpenseBloc>(),
        ),
        BlocProvider<DashboardBloc>(
          create: (_) => sl<DashboardBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'MExpense',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: sl<AppRouter>().router,
      ),
    );
  }
}
