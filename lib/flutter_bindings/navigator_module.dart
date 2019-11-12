import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:vader/flutter_bindings/navigator_routes.dart';
import 'package:vader/src/di_module.dart';

class NavigatorModule extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final NavigatorRoutes routes;
  final DiModule diModule;

  const NavigatorModule({
    Key key,
    @required this.navigatorKey,
    @required this.routes,
    @required this.diModule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<DiModule>(
      child: WillPopScope(
        onWillPop: () => navigatorKey.currentState.maybePop(),
        child: Navigator(
          key: navigatorKey,
          onGenerateRoute: routes.onGenerateRoute
        ),
      ),
    );
  }
}
