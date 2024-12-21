import 'dart:developer';

import 'package:flutter/material.dart';

final List<Route> routeStack = [];

class AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    routeStack.add(route);
    _logNav(route, 'push');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    routeStack.remove(route);
    _logNav(route, 'pop');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (newRoute != null && oldRoute != null) {
      final index = routeStack.indexOf(oldRoute);
      routeStack[index] = newRoute;
      _logNav(newRoute, 'replace');
    }
  }

  void _logNav(Route? route, String action) {
    if (route != null) {
      log('Screen: ${route.settings.name} * $action');
    }
  }
}
