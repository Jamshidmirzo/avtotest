import 'package:avtotest/presentation/features/education/presentation/screens/education_screen.dart';
import 'package:avtotest/presentation/features/home/presentation/home_screen.dart';
import 'package:avtotest/presentation/features/navigation/presentation/navigation_screen.dart';
import 'package:avtotest/presentation/features/settings/settings_screen.dart';
import 'package:flutter/material.dart';

class TabNavigatorRoutes {
  static const String root = '/';
}

class TabNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final NavItemEnum tabItem;

  const TabNavigator({required this.tabItem, required this.navigatorKey, super.key});

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> with AutomaticKeepAliveClientMixin {
  Map<String, WidgetBuilder> _routeBuilders({required BuildContext context, required RouteSettings routeSettings}) {
    switch (widget.tabItem) {
      case NavItemEnum.main:
        return {TabNavigatorRoutes.root: (context) => HomeScreen()};
      case NavItemEnum.education:
        return {TabNavigatorRoutes.root: (context) => EducationScreen()};
      case NavItemEnum.settings:
        return {TabNavigatorRoutes.root: (context) => SettingsScreen()};
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final routeBuilders = _routeBuilders(
      context: context,
      routeSettings: const RouteSettings(name: TabNavigatorRoutes.root),
    );

    return Navigator(
      key: widget.navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name]!(context),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

PageRouteBuilder fade({required Widget page, RouteSettings? settings}) => PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
          opacity: CurvedAnimation(
            curve: const Interval(0, 1),
            parent: animation,
          ),
          child: child,
        ),
    settings: settings,
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => page);
