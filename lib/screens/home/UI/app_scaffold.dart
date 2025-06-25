import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_bill/screens/home/controller/home_provider.dart';
import 'package:share_bill/screens/spent/UI/spent_screen.dart';
import '../../../gen/colors.gen.dart';
import 'package:share_bill/gen/l10n/app_localizations.dart';

import '../../../services/app_services/ad_service.dart';

class AppScaffold extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffold({
    super.key,
    required this.navigationShell,
  });

  @override
  ConsumerState<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends ConsumerState<AppScaffold> {
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.navigationShell.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: widget.navigationShell, // This displays the current tab's content
      resizeToAvoidBottomInset: false, // This prevents the scaffold from resizing when keyboard appears
      floatingActionButton: Container(
        height: 56,
        width: 56,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
        child: FloatingActionButton(
          onPressed: () {
            // Handle add button press
            context.pushNamed(SpentScreen.routeNameFromHome);
          },
          backgroundColor: Colors.blue,
          elevation: 2,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true, // This makes body extend behind the bottom app bar
      bottomNavigationBar: MediaQuery.of(context).viewInsets.bottom > 0
          ? null  // Hide bottom navigation when keyboard is visible
          : Container(
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: ColorName.whiteLightShadow,
              blurRadius: 80,
            ),
          ],
        ),
        child: BottomAppBar(
          elevation: 8.0,
          notchMargin: 8.0,
          shape: const CircularNotchedRectangle(),
          color: Colors.white,
          clipBehavior: Clip.antiAlias, // Ensures clean notch cutting
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Home tab
                _buildNavItem(
                  context: context,
                  index: 0,
                  currentIndex: widget.navigationShell.currentIndex,
                  icon: Icons.home,
                  label: localizations.home,
                  onTap: () => _handleNavigation(0),
                ),
                // Groups tab
                _buildNavItem(
                  context: context,
                  index: 1,
                  currentIndex: widget.navigationShell.currentIndex,
                  icon: Icons.payment,
                  label: localizations.expenses,
                  onTap: () => _handleNavigation(1),
                ),
                // Empty space for the FAB
                const SizedBox(width: 60),
                // Expenses tab
                _buildNavItem(
                  context: context,
                  index: 2,
                  currentIndex: widget.navigationShell.currentIndex,
                  icon: Icons.group,
                  label: localizations.groups,
                  onTap: () => _handleNavigation(2),
                ),
                // Profile tab
                _buildNavItem(
                  context: context,
                  index: 3,
                  currentIndex: widget.navigationShell.currentIndex,
                  icon: Icons.person,
                  label: localizations.persons,
                  onTap: () => _handleNavigation(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Handle navigation with ad tracking
  void _handleNavigation(int index) {
    // Only trigger ad logic if actually changing tabs
    if (_previousIndex != index) {
      print('🔄 Navigation: Tab $_previousIndex → Tab $index');

      // Track screen navigation for ads
      AdService().onScreenNavigation();

      // Update previous index
      _previousIndex = index;
    }

    // Perform the actual navigation
    widget.navigationShell.goBranch(index);
    ref.read(homeNotifierProvider.notifier).setValue(index);
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required int currentIndex,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isSelected = index == currentIndex;
    final color = isSelected ? Colors.blue : Colors.grey;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}