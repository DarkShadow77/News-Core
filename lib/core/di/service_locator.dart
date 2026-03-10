// lib/core/di/service_locator.dart
import 'package:get_it/get_it.dart';

import '../../app/theme/bloc/theme_bloc.dart';
import '../../core/services/hive_storage_service.dart';
import '../../featured/auth/presentation/bloc/auth_bloc.dart';
import '../../featured/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../featured/home/data/repository/news_repository.dart';
import '../../featured/home/data/repository/news_repository_impl.dart';
import '../../featured/home/presentation/manager/news_bloc.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  // Initialize Hive Storage Service
  final hiveStorage = HiveStorageService();
  await hiveStorage.init();

  // Register storage service as singleton
  sl.registerLazySingleton<HiveStorageService>(() => hiveStorage);

  // Repositories
  sl.registerLazySingleton<NewsRepository>(() => NewsRepositoryImpl());

  // Blocs
  sl.registerSingleton<ThemeBloc>(ThemeBloc());
  sl.registerSingleton<AuthBloc>(
    AuthBloc(storageService: sl<HiveStorageService>()),
  );
  sl.registerSingleton<DashboardBloc>(DashboardBloc());
  sl.registerFactory<NewsBloc>(
    () => NewsBloc(repository: sl<NewsRepository>()),
  );
}
