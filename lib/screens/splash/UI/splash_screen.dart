import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_bill/screens/login/UI/login_screen.dart';

import '../../../gen/assets.gen.dart';
import '../../home/UI/home_screen.dart';
import '../../../services/firebase_services/user_service.dart';
import 'onboarding_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  static const routeName = '/';
  static const routePath = routeName;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Show splash for at least 2 seconds for better UX
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Check if user has completed onboarding
      final prefs = await SharedPreferences.getInstance();
      final hasCompletedOnboarding = prefs.getBool('onboarding_completed') ?? false;

      if (!hasCompletedOnboarding) {
        // First time user - show onboarding
        if (mounted) {
          context.goNamed(OnboardingScreen.routeName);
        }
        return;
      }

      // Check if user is logged in
      final isLoggedIn = UserService.isUserLoggedIn();

      if (isLoggedIn) {
        // User is logged in - go to home
        if (mounted) {
          context.goNamed(HomeScreen.routeName);
        }
      } else {
        // User needs to login
        if (mounted) {
          context.goNamed(LoginScreen.routeName);
        }
      }
    } catch (e) {
      print('Error during app initialization: $e');
      // Fallback to login screen on error
      if (mounted) {
        context.goNamed(LoginScreen.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade600,
              Colors.purple.shade600,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 1500),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.receipt_long,
                      size: 60,
                      color: Colors.blue.shade600,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 30),

            // App Name
            TweenAnimationBuilder<Offset>(
              duration: Duration(milliseconds: 1000),
              tween: Tween(begin: Offset(0, 50), end: Offset.zero),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: value,
                  child: Opacity(
                    opacity: 1 - (value.dy / 50),
                    child: Text(
                      'Share Bill',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 12),

            // Tagline
            TweenAnimationBuilder<Offset>(
              duration: Duration(milliseconds: 1200),
              tween: Tween(begin: Offset(0, 30), end: Offset.zero),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: value,
                  child: Opacity(
                    opacity: 1 - (value.dy / 30),
                    child: Text(
                      'Split expenses with friends',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 60),

            // Loading indicator
            TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 2000),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}