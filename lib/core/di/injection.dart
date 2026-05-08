
import 'package:get_it/get_it.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/expense/data/datasources/expense_local_datasource.dart';
import '../../features/expense/data/models/expense_hive_model.dart';
import '../../features/expense/data/repositories/expense_repository_impl.dart';
import '../../features/expense/domain/repositories/expense_repository.dart';
import '../../features/expense/domain/usecases/add_expense.dart';
import '../../features/expense/domain/usecases/delete_expense.dart';
import '../../features/expense/domain/usecases/get_expenses.dart';
import '../../features/expense/domain/usecases/update_expense.dart';
import '../../features/expense/presentation/bloc/expense_bloc.dart';
import '../constants/app_constants.dart';
import '../network/network_info.dart';
import '../router/app_router.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  await _initHive();
  _registerCore();
  _registerDataSources();
  _registerRepositories();
  _registerUseCases();
  _registerBlocs();
}

Future<void> _initHive() async {
  final dir = await getApplicationDocumentsDirectory();

  // Guard: only init if not already initialized
  if (!Hive.isAdapterRegistered(kExpenseTypeId)) {
    Hive.init(dir.path);
    Hive.registerAdapter(ExpenseHiveAdapter());
  }

  // Guard: only open box if not already open
  if (!Hive.isBoxOpen(AppConstants.expenseBoxName)) {
    await Hive.openBox<ExpenseHiveModel>(AppConstants.expenseBoxName);
  }
}

void _registerCore() {
  sl.registerLazySingleton<AppRouter>(() => AppRouter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
}

void _registerDataSources() {
  sl.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSourceImpl(
      Hive.box<ExpenseHiveModel>(AppConstants.expenseBoxName),
    ),
  );
}

void _registerRepositories() {
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(localDataSource: sl()),
  );
}

void _registerUseCases() {
  sl.registerLazySingleton(() => GetExpenses(sl()));
  sl.registerLazySingleton(() => AddExpense(sl()));
  sl.registerLazySingleton(() => UpdateExpense(sl()));
  sl.registerLazySingleton(() => DeleteExpense(sl()));
}

void _registerBlocs() {
  sl.registerFactory(
    () => ExpenseBloc(
      getExpenses: sl(),
      addExpense: sl(),
      updateExpense: sl(),
      deleteExpense: sl(),
    ),
  );
  sl.registerFactory(
    () => DashboardBloc(getExpenses: sl()),
  );
}