import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_bill/screens/group/UI/group_detail_screen.dart';
import 'package:share_bill/screens/group/UI/group_management_screen.dart';
import 'package:share_bill/screens/login/UI/create_account_screen.dart';
import 'package:share_bill/screens/login/UI/login_screen.dart';
import 'package:share_bill/screens/person/UI/person_management_screen.dart';
import 'package:share_bill/screens/spent/UI/spent_screen.dart';
import '../../screens/bill/UI/bill_management_screen.dart';
import '../../screens/home/UI/app_scaffold.dart';
import '../../screens/home/UI/home_screen.dart';
import '../../screens/person/UI/person_detail_screen.dart';
import '../../screens/setting/UI/language_setting_screen.dart';
import '../../screens/splash/UI/onboarding_screen.dart';
import '../../screens/splash/UI/splash_screen.dart';
import '../../services/firebase_services/user_service.dart';
import '../utils/auth_guard.dart';
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
    initialLocation: SplashScreen.routePath,
    redirect: (context, state) {
      final isLoggedIn = UserService.isUserLoggedIn();
      final isOnAuthPages = state.uri.toString() == LoginScreen.routePath ||
          state.uri.toString() == '/create_account' ||
          state.uri.toString() == SplashScreen.routePath ||
          state.uri.toString() == OnboardingScreen.routePath;

      print('🔍 Navigation redirect check:');
      print('  - Current location: ${state.uri.toString()}');
      print('  - Is logged in: $isLoggedIn');
      print('  - Is on auth pages: $isOnAuthPages');

      // If not logged in and trying to access protected routes, redirect to login
      if (!isLoggedIn && !isOnAuthPages) {
        print('  - Redirecting to login (not logged in)');
        return LoginScreen.routePath;
      }

      // If logged in and trying to access login pages, redirect to home
      if (isLoggedIn && isOnAuthPages && state.uri.toString() != SplashScreen.routePath) {
        print('  - Redirecting to home (already logged in)');
        return HomeScreen.routePath;
      }

      if (isLoggedIn && (state.uri.toString() == LoginScreen.routePath ||
          state.uri.toString() == '/create_account' ||
          state.uri.toString() == OnboardingScreen.routePath)) {
        print('  - Redirecting to home (already logged in)');
        return HomeScreen.routePath;
      }

      print('  - No redirect needed');
      return null; // No redirect needed
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: SplashScreen.routePath,
        name: SplashScreen.routeName,
        builder: (context, state) {
          print('📱 Building SplashScreen');
          return const SplashScreen();
        },
      ),

      // Onboarding Screen
      GoRoute(
        path: OnboardingScreen.routePath,
        name: OnboardingScreen.routeName,
        builder: (context, state) {
          print('📖 Building OnboardingScreen');
          return const OnboardingScreen();
        },
      ),

      // Login Screen
      GoRoute(
        path: LoginScreen.routePath,
        name: LoginScreen.routeName,
        builder: (context, state) {
          print('🔐 Building LoginScreen');
          return const LoginScreen();
        },
      ),

      // Create Account Screen (separate route, not nested)
      GoRoute(
        path: '/create_account',
        name: CreateAccountScreen.routeName,
        builder: (context, state) {
          print('📝 Building CreateAccountScreen');
          return const CreateAccountScreen();
        },
      ),

      GoRoute(
        path: LanguageSettingsScreen.routePath,
        name: LanguageSettingsScreen.routeName,
        builder: (context, state) {
          print('🌐 Building LanguageSettingsScreen');
          return const LanguageSettingsScreen();
        },
      ),

      // // Spent Screen (from Home)
      // GoRoute(
      //   path: SpentScreen.routePathFromHome,
      //   name: SpentScreen.routeNameFromHome,
      //   parentNavigatorKey: _rootNavigatorKey,
      //   builder: (context, state) {
      //     print('💰 Building SpentScreen (from home)');
      //     return AuthGuard(child: const SpentScreen());
      //   },
      // ),

      // StatefulShellRoute for bottom navigation (Protected routes)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          print('🏗️ Building AppScaffold with shell');
          // The StatefulShellRoute passes the navigationShell to our custom scaffold
          return AuthGuard(
            child: AppScaffold(navigationShell: navigationShell),
          );
        },
        branches: [
          // Home Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: HomeScreen.routePath,
                name: HomeScreen.routeName,
                builder: (context, state) {
                  print('🏠 Building HomeScreen');
                  return const HomeScreen();
                },
                routes: [
                  GoRoute(
                    path: SpentScreen.routePathFromHome,
                    name: SpentScreen.routeNameFromHome,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      print('💰 Building SpentScreen (from bill management)');
                      return const SpentScreen();
                    },
                  ),
                ]
              ),
            ],
          ),

          // Bill Management Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: BillManagementScreen.routePath,
                name: BillManagementScreen.routeName,
                builder: (context, state) {
                  print('📋 Building BillManagementScreen');
                  return const BillManagementScreen();
                },
                routes: [
                  GoRoute(
                    path: SpentScreen.routePathFromBillManagement,
                    name: SpentScreen.routeNameFromBillManagement,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      print('💰 Building SpentScreen (from bill management)');
                      return const SpentScreen();
                    },
                  ),
                ],
              ),
            ],
          ),

          // Group Management Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: GroupManagementScreen.routePath,
                name: GroupManagementScreen.routeName,
                builder: (context, state) {
                  print('👥 Building GroupManagementScreen');
                  return const GroupManagementScreen();
                },
                routes: [
                  GoRoute(
                    path: GroupDetailScreen.routePath,
                    name: GroupDetailScreen.routeName,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      print('👥 Building GroupDetailScreen');
                      return const GroupDetailScreen();
                    },
                  ),
                ],
              ),
            ],
          ),

          // Person Management Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: PersonManagementScreen.routePath,
                name: PersonManagementScreen.routeName,
                builder: (context, state) {
                  print('👤 Building PersonManagementScreen');
                  return const PersonManagementScreen();
                },
                routes: [
                  GoRoute(
                    path: PersonDetailScreen.routePath,
                    name: PersonDetailScreen.routeName,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      print('👤 Building PersonDetailScreen');
                      return const PersonDetailScreen();
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    // Error handling
    errorBuilder: (context, state) {
      print('❌ Router error: ${state.error}');
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('Navigation Error'),
              SizedBox(height: 8),
              Text('${state.error}'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(HomeScreen.routePath),
                child: Text('Go Home'),
              ),
            ],
          ),
        ),
      );
    },
  ),
);