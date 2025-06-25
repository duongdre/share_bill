import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_bill/screens/login/UI/login_screen.dart';
import '../../services/firebase_services/user_service.dart';

class AuthGuard extends ConsumerWidget {
  final Widget child;

  const AuthGuard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if user is logged in
    if (!UserService.isUserLoggedIn()) {
      // If not logged in, redirect to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.goNamed(LoginScreen.routeName);
      });

      // Show loading while redirecting
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If logged in, show the child widget
    return child;
  }
}