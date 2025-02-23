import 'package:flutter/cupertino.dart';

class AppRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('AppRouteObserver didPush: $route');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('AppRouteObserver didPop: $route');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('AppRouteObserver didRemove: $route');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print('AppRouteObserver didReplace: $newRoute');
  }
}