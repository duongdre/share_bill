import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/screens/bill/controller/bill_provider.dart';
import 'package:share_bill/screens/group/controller/group_provider.dart';
import '../../screens/person/controller/person_provider.dart';

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
      ref.read(personNotifierProvider.notifier).clearNewPersonData();
    }
    if (route.settings.name == 'group_detail') {
      ref.read(groupNotifierProvider.notifier).clearNewGroupData();
    }
    if (route.settings.name == '/home/spent' || route.settings.name == '/bill_management/spent') {
      ref.read(billNotifierProvider.notifier).removeCurrentSpent();
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
