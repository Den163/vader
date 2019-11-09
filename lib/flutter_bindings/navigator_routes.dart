import 'package:flutter/cupertino.dart';

typedef Route NavigatorRouteBuilder(RouteSettings settings);

abstract class NavigatorRoutes {
  Map<String, NavigatorRouteBuilder> get routes;
  final initialRoute = '/';

  Route<T> onGenerateRoute<T>(RouteSettings routeSettings) {
    return routes[routeSettings.name](routeSettings);
  }
}