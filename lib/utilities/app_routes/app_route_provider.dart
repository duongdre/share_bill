import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_bill/screens/group/UI/group_detail_screen.dart';
import 'package:share_bill/screens/group/UI/group_management_screen.dart';
import 'package:share_bill/screens/person/UI/person_management_screen.dart';
import 'package:share_bill/screens/spent/UI/spent_screen.dart';
import 'package:share_bill/screens/transaction/UI/transaction_management_screen.dart';
import '../../models/data_models/person.dart';
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
      (ref) =>
      GoRouter(
        observers: [AppRouteObserver(ref)],
        navigatorKey: _rootNavigatorKey,
        initialLocation: SplashScreen.routeName,
        routes: [
          GoRoute(
            path: SplashScreen.routePath,
            name: SplashScreen.routeName,
            builder: (context, state) => const SplashScreen(),
            routes: [],
          ),
          GoRoute(
            path: HomeScreen.routePath,
            name: HomeScreen.routeName,
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                path: SpentScreen.routePathFromHome,
                name: SpentScreen.routeNameFromHome,
                builder: (context, state) => const SpentScreen(),
                routes: [],
              ),
              GoRoute(
                path: GroupManagementScreen.routePath,
                name: GroupManagementScreen.routeName,
                builder: (context, state) => const GroupManagementScreen(),
                routes: [
                  GoRoute(
                    path: SpentScreen.routePath,
                    name: SpentScreen.routeName,
                    builder: (context, state) => const SpentScreen(),
                    routes: [],
                  ),
                  GoRoute(
                    path: GroupDetailScreen.routePath,
                    name: GroupDetailScreen.routeName,
                    builder: (context, state) => const GroupDetailScreen(),
                    routes: [],
                  ),
                ],
              ),
              GoRoute(
                path: PersonManagementScreen.routePath,
                name: PersonManagementScreen.routeName,
                builder: (context, state) => const PersonManagementScreen(),
                routes: [
                  GoRoute(
                    path: PersonDetailScreen.routePath,
                    name: PersonDetailScreen.routeName,
                    builder: (context, state) {
                      String? personData = state.extra as String?; // -> casting is important
                      return PersonDetailScreen(personUid: personData);
                    },
                    routes: [
                      GoRoute(
                        path: SpentScreen.routePathFromPerson,
                        name: SpentScreen.routeNameFromPerson,
                        builder: (context, state) => const SpentScreen(),
                        routes: [],
                      ),
                    ],
                  ),
                ],
              ),
              GoRoute(
                path: TransactionManagementScreen.routePath,
                name: TransactionManagementScreen.routeName,
                builder: (context, state) => const TransactionManagementScreen(),
                routes: [
                  GoRoute(
                    path: SpentScreen.routePathFromTransaction,
                    name: SpentScreen.routeNameFromTransaction,
                    builder: (context, state) => const SpentScreen(),
                    routes: [],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
);
