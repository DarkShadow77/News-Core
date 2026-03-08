import 'package:flutter/material.dart';

import '../../../app/view/pages/successful_page.dart';
import '../../../featured/auth/presentation/pages/authentication_page.dart';
import '../../../featured/onboarding/presentation/pages/splash_screen_page.dart';
import 'route_name.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteName.splashPage:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: const SplashScreenPage(),
      );
    case RouteName.authenticationPage:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: const AuthenticationPage(),
      );
    /* case RouteName.dashboardPage:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: const DashboardPage(),
      );*/

    ///Universal Success Page
    case RouteName.successfulPage:
      final args = settings.arguments! as SuccessfulPageParam;
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: SuccessfulPage(param: args),
      );

    default:
      return MaterialPageRoute<dynamic>(
        builder: (_) => Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
        ),
      );
  }
}

Route<dynamic> _getPageRoute({
  required String routeName,
  required Widget viewToShow,
}) {
  return MaterialPageRoute(
    settings: RouteSettings(name: routeName),
    builder: (_) => viewToShow,
  );
}
