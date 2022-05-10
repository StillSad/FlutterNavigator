import 'package:flutter/material.dart';

import '../page/details_page.dart';
import '../page/home_page.dart';
import '../page/splash_page.dart';

class AppRouteDelegate extends RouterDelegate<List<RouteSettings>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  List<MaterialPage> _pages = [];

  @override
  List<Page> get currentConfiguration => List.of(_pages);

  @override
  Widget build(BuildContext context) {
    print('AppRouteDelegate:build');

    return Navigator(
      key: navigatorKey,
      pages: List.of(_pages),
      onPopPage: _onPopPage,
    );
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    //处理路由退栈逻辑
    if (!route.didPop(result)) return false;

    if (_pages.isEmpty) return false;

    _pages.removeLast();
    return true;
  }

  @override
  Future<void> setNewRoutePath(List<RouteSettings> configuration) async {
    debugPrint('setNewRoutePath ${configuration.last.name}');

    _setPath(configuration
        .map((routeSettings) => _createPage(routeSettings))
        .toList());

  }

  void _setPath(List<MaterialPage> pages) {
    _pages.clear();
    _pages.addAll(pages);

    if(_pages.first.name != '/') {
      _pages.insert(0, _createPage(const RouteSettings(name: '/')));
    }

    notifyListeners();
  }

  void push({required String name, dynamic arguments}) {
    _pages.add(_createPage(RouteSettings(name: name, arguments: arguments)));
    notifyListeners();
  }

  void replace({required String name, dynamic arguments}) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    push(name: name, arguments: arguments);
  }

  MaterialPage _createPage(RouteSettings routeSettings) {
    Widget child;

    switch (routeSettings.name) {
      case "/home":
        child = const HomePage();
        break;
      case "/splash":
        child = const SplashPage();
        break;
      case "/details":
        child = DetailsPage(routeSettings.arguments! as Map<String,String>);
        break;
      default:
        child = const Scaffold();
    }

    return MaterialPage(
        child: child,
        key: Key(routeSettings.name!) as LocalKey,
        name: routeSettings.name,
        arguments: routeSettings.arguments);
  }
}
