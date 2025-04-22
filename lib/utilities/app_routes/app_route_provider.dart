import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_bill/screens/group/UI/group_detail_screen.dart';
import 'package:share_bill/screens/group/UI/group_management_screen.dart';
import 'package:share_bill/screens/login/UI/create_account_screen.dart';
import 'package:share_bill/screens/login/UI/login_screen.dart';
import 'package:share_bill/screens/person/UI/person_management_screen.dart';
import 'package:share_bill/screens/spent/UI/spent_screen.dart';
import 'package:share_bill/utilities/utils/dialog_add_member.dart';
import '../../models/data_models/person.dart';
import '../../screens/bill/UI/bill_management_screen.dart';
import '../../screens/home/UI/app_scaffold.dart';
import '../../screens/home/UI/home_screen.dart';
import '../../screens/person/UI/person_detail_screen.dart';
import '../../screens/splash/UI/splash_screen.dart';
import 'app_route_observer.dart';

part 'app_route_provider.g.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

@riverpod
Uri currentRoute(ref) {
  return ref.watch(routeInformationProvider).imgValue.uri;
}

final routeInformationProvider = ChangeNotifierProvider<GoRouteInformationProvider>((ref) {
  final router = ref.watch(routerProvider);
  return router.routeInformationProvider;
});

final routerProvider = Provider<GoRouter>(
      (ref) => GoRouter(
    observers: [AppRouteObserver(ref)],
    navigatorKey: _rootNavigatorKey,
    initialLocation: HomeScreen.routePath,
    routes: [
      GoRoute(
        path: SplashScreen.routePath,
        name: SplashScreen.routeName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: LoginScreen.routePath,
        name: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
        routes: [
          GoRoute(
            path: CreateAccountScreen.routePath,
            name: CreateAccountScreen.routeName,
            builder: (context, state) => const CreateAccountScreen(),
          ),
        ],
      ),
      // StatefulShellRoute for bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // The StatefulShellRoute passes the navigationShell to our custom scaffold
          return AppScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: HomeScreen.routePath,
                name: HomeScreen.routeName,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: BillManagementScreen.routePath,
                name: BillManagementScreen.routeName,
                builder: (context, state) => const BillManagementScreen(),
                routes: [
                  GoRoute(
                    path: SpentScreen.routePathFromBillManagement,
                    name: SpentScreen.routeNameFromBillManagement,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const SpentScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: SpentScreen.routePathFromHome,
                name: SpentScreen.routeNameFromHome,
                builder: (context, state) => const SpentScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: GroupManagementScreen.routePath,
                name: GroupManagementScreen.routeName,
                builder: (context, state) => const GroupManagementScreen(),
                routes: [
                  GoRoute(
                    path: GroupDetailScreen.routePath,
                    name: GroupDetailScreen.routeName,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const GroupDetailScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: PersonManagementScreen.routePath,
                name: PersonManagementScreen.routeName,
                builder: (context, state) => const PersonManagementScreen(),
                routes: [
                  GoRoute(
                    path: PersonDetailScreen.routePath,
                    name: PersonDetailScreen.routeName,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const PersonDetailScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  ),
);