import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../screens/home/controller/home_screen_provider.dart';

class AppRouteObserver extends NavigatorObserver {
  final ProviderRef ref;
  AppRouteObserver(this.ref);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('AppRouteObserver didPush: $route');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('AppRouteObserver didPop: $route');
    if (route.settings.name == 'person_detail') {
      ref.read(homeScreenTotalNotifierProvider.notifier).clearNewPersonData();
    }
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
