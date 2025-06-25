import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_bill/gen/colors.gen.dart';
import 'package:share_bill/screens/login/UI/login_screen.dart';

import '../../../gen/l10n/app_localizations.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  static const routeName = 'onboarding';
  static const routePath = '/onboarding';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingData> _onboardingData = [];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (mounted) {
      context.goNamed(LoginScreen.routeName);
    }
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    _onboardingData = [
      OnboardingData(
        title: localizations.welcomeToShareBill,
        subtitle: localizations.onB02,
        description: localizations.onB03,
        icon: Icons.receipt_long,
        color: ColorName.blueBackground,
        gradient: [Colors.blue.shade400, Colors.blue.shade600],
      ),
      OnboardingData(
        title: localizations.onB04,
        subtitle: localizations.onB05,
        description: localizations.onB06,
        icon: Icons.people,
        color: ColorName.purpleBackground,
        gradient: [Colors.purple.shade400, Colors.purple.shade600],
      ),
      OnboardingData(
        title: localizations.onB07,
        subtitle: localizations.onB08,
        description: localizations.onB09,
        icon: Icons.group_add,
        color: ColorName.greenBackground,
        gradient: [Colors.green.shade400, Colors.green.shade600],
      ),
      OnboardingData(
        title: localizations.onB10,
        subtitle: localizations.onB11,
        description: localizations.onB12,
        icon: Icons.payment,
        color: ColorName.homeRedText,
        gradient: [Colors.orange.shade400, Colors.red.shade500],
      ),
      OnboardingData(
        title: localizations.onB13,
        subtitle: localizations.onB14,
        description: localizations.onB15,
        icon: Icons.analytics,
        color: ColorName.blackColor,
        gradient: [Colors.indigo.shade400, Colors.indigo.shade600],
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _onboardingData[_currentPage].gradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: TextButton(
                  onPressed: _skipOnboarding,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    localizations.skip,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // PageView content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    return _buildOnboardingPage(_onboardingData[index]);
                  },
                ),
              ),

              // Bottom section with dots and button
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _onboardingData.length,
                        (index) => _buildDot(index),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Next/Get Started button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: _onboardingData[_currentPage].gradient[1],
                          elevation: 8,
                          shadowColor: Colors.black.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _currentPage == _onboardingData.length - 1 ? localizations.getStarted : localizations.next,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with animated container
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 600),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    data.icon,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 50),

          // Title
          TweenAnimationBuilder<Offset>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: const Offset(0, 50), end: Offset.zero),
            builder: (context, value, child) {
              return Transform.translate(
                offset: value,
                child: Opacity(
                  opacity: 1 - (value.dy / 50),
                  child: Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Subtitle
          TweenAnimationBuilder<Offset>(
            duration: const Duration(milliseconds: 1000),
            tween: Tween(begin: const Offset(0, 30), end: Offset.zero),
            builder: (context, value, child) {
              return Transform.translate(
                offset: value,
                child: Opacity(
                  opacity: 1 - (value.dy / 30),
                  child: Text(
                    data.subtitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 30),

          // Description
          TweenAnimationBuilder<Offset>(
            duration: const Duration(milliseconds: 1200),
            tween: Tween(begin: const Offset(0, 20), end: Offset.zero),
            builder: (context, value, child) {
              return Transform.translate(
                offset: value,
                child: Opacity(
                  opacity: 1 - (value.dy / 20),
                  child: Text(
                    data.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.white : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final List<Color> gradient;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.gradient,
  });
}
