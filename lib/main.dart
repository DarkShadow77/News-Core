import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:path_provider/path_provider.dart';

import 'app/theme/app_themes.dart';
import 'app/theme/bloc/theme_bloc.dart';
import 'core/constants/navigators/route_name.dart';
import 'core/constants/navigators/router.dart';
import 'core/constants/strings.dart';
import 'core/di/service_locator.dart';
import 'core/utils/local_storage.dart';
import 'featured/auth/presentation/bloc/auth_bloc.dart';
import 'featured/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'featured/home/presentation/manager/news_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize Hive for local storage
  await Hive.initFlutter();

  //Initialize dotenv for environment variables
  await dotenv.load(fileName: ".env.development");

  final storageDir = await getApplicationDocumentsDirectory();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : storageDir,
  );

  await initDI();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _localStorage = LocalStorageHelper();

  @override
  void initState() {
    super.initState();
    _isFirstRun();
  }

  Future<void> _isFirstRun() async {
    //Check and store if its user's first time opening the app
    bool firstRun = await IsFirstRun.isFirstRun();

    _localStorage.setIsFirstRun(firstRun);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<ThemeBloc>()),
          BlocProvider(create: (_) => sl<AuthBloc>()),
          BlocProvider(create: (_) => sl<DashboardBloc>()),
          BlocProvider(
            create: (_) => sl<NewsBloc>()..add(const FetchTopHeadlinesEvent()),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeMode>(
          builder: (context, themeMode) {
            return ScreenUtilInit(
              designSize: const Size(390, 844),
              builder: (BuildContext context, Widget? child) {
                return GetMaterialApp(
                  title: Strings.appName,
                  debugShowCheckedModeBanner: false,
                  theme: lightTheme,
                  darkTheme: darkTheme,
                  themeMode: themeMode,
                  onGenerateRoute: generateRoute,
                  initialRoute: RouteName.splashPage,
                  builder: (context, child) {
                    final mediaQuery = MediaQuery.of(context);

                    return MediaQuery(
                      data: mediaQuery.copyWith(
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      child: child!,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
