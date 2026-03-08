import 'package:get_it/get_it.dart';

import '../../app/theme/bloc/theme_bloc.dart';
import '../../featured/dashboard/presentation/bloc/dashboard_bloc.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  // Remote data sources
  // sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());

  // Repositories
  /*sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemoteDataSource: sl<AuthRemoteDataSource>()),
  );*/

  // Blocs (Factories - because Blocs are short-lived)
  sl.registerSingleton<ThemeBloc>(ThemeBloc());
  sl.registerSingleton<DashboardBloc>(DashboardBloc());
  /*sl.registerSingleton<AuthBloc>(AuthBloc(repo: sl<AuthRepository>()));
  sl.registerSingleton<DashboardBloc>(DashboardBloc()
  );*/
}
