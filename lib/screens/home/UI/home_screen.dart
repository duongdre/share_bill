import 'dart:io';
import 'dart:math';

import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_bill/gen/assets.gen.dart';
import 'package:share_bill/models/data_models/bill.dart';
import 'package:share_bill/models/data_models/group.dart';
import 'package:share_bill/models/data_models/person.dart';
import 'package:share_bill/screens/bill/controller/bill_provider.dart';
import 'package:share_bill/screens/group/UI/group_management_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_bill/screens/group/controller/group_provider.dart';
import 'package:share_bill/screens/person/UI/person_management_screen.dart';
import 'package:share_bill/screens/spent/UI/spent_screen.dart';
import 'package:uuid/uuid.dart';

import '../../../gen/colors.gen.dart';
import '../../../services/firebase_services/user_service.dart';
import '../../../utilities/utils/avatar_dialog.dart';
import '../../../utilities/utils/avatar_group.dart';
import '../../../utilities/utils/avatar_person.dart';
import '../../../utilities/utils/widget_list_bill.dart';
import '../../../utilities/utils/widget_list_group.dart';
import '../../bill/UI/bill_management_screen.dart';
import '../../group/UI/group_detail_screen.dart';
import '../../login/UI/login_screen.dart';
import '../../person/UI/person_detail_screen.dart';
import '../../person/controller/person_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  static const routeName = 'home';
  static const routePath = '/$routeName';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    _checkAuthAndLoadData();
    super.initState();
  }

  Future<void> _checkAuthAndLoadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Check if user is logged in
      if (!UserService.isUserLoggedIn()) {
        _navigateToLogin();
        return;
      }

      // Initialize user data if needed
      await UserService.initializeUserData();

      // Load all data
      await _loadInitialData();
    } catch (e) {
      print('Error in auth check and data loading: $e');
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToLogin() {
    if (mounted) {
      context.goNamed(LoginScreen.routeName);
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get the notifier and fetch all person data
      await ref.read(personNotifierProvider.notifier).fetchAllPerson();
      await ref.read(groupNotifierProvider.notifier).fetchAllGroup();
      await ref.read(billNotifierProvider.notifier).fetchAllBill();
    } catch (e) {
      print('Error loading initial data: $e');
      // You could show an error snackbar here
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(personNotifierProvider);
    ref.watch(groupNotifierProvider);
    ref.watch(billNotifierProvider);
    final persons = ref.read(personNotifierProvider.notifier).allPerson;
    final groups = ref.read(groupNotifierProvider.notifier).allGroup;
    final bills = ref.read(billNotifierProvider.notifier).getFirst5Bills();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: ColorName.background,
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: RefreshIndicator(
                  onRefresh: _loadInitialData,
                  child: Column(
                    children: [
                      header(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              homeAddSection(),
                              const SizedBox(height: 16),

                              /// Favorite person
                              Padding(
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: Text(
                                  "Favorite Persons",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 6),
                              favoritePersons(persons),
                              const SizedBox(height: 16),

                              /// Recent Groups
                              Padding(
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: Text(
                                  "Recent Groups",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              ListGroup(
                                groups: groups,
                                scrollable: true,
                                onGroupTap: (group) {
                                  // Handle group selection
                                },
                              ),
                              const SizedBox(height: 16),

                              /// Recent Payments
                              Padding(
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: Text(
                                  "Recent Payments",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              ListBill(
                                bills: bills,
                                scrollable: true,
                                onBillTap: (group) {
                                  // Handle group selection
                                },
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget header() {
    final userEmail = UserService.getCurrentUserEmail() ?? 'Unknown User';
    final userName = userEmail.split('@')[0];

    return Container(
      height: 56,
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: ColorName.white,
        boxShadow: [
          BoxShadow(color: ColorName.groupManagementBackground, blurRadius: 2, offset: Offset(2, 2)),
        ],
      ),
      child: Row(
        children: [
          // User info
          Expanded(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: 'Welcome back, ',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                children: [
                  TextSpan(
                    text: userName,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ColorName.homeBlackText),
                  ),
                ],
              ),
            ),
          ),
          Icon(
            Icons.notifications_none_sharp,
            size: 20,
          ),
          // Profile/Logout Button
          InkWell(
            onTap: _showUserMenu,
            child: Container(
              height: 32,
              width: 32,
              margin: EdgeInsets.only(left: 8, right: 16),
              decoration: BoxDecoration(
                color: ColorName.blackColor,
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                boxShadow: [
                  BoxShadow(
                    color: ColorName.homeGrayBalance,
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget homeAddSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => context.goNamed(PersonManagementScreen.routeName),
              child: Container(
                height: 68,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: ColorName.blueBackground
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_add, color: Colors.white),
                    SizedBox(height: 4),
                    Text('Add Person', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () => context.goNamed(GroupManagementScreen.routeName),
              child: Container(
                height: 68,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: ColorName.purpleBackground
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.group_add, color: Colors.white),
                    SizedBox(height: 4),
                    Text('Add Group', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () => context.goNamed(SpentScreen.routeNameFromHome),
              child: Container(
                height: 68,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: ColorName.greenBackground
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment, color: Colors.white),
                    SizedBox(height: 4),
                    Text('Add Expense', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget favoritePersons(List<Person> persons) {
    return Container(
      height: 84,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: persons.length,
          itemBuilder: (context, index) {
            final person = persons[index];
            return Stack(
              children: [
                InkWell(
                  onTap: () {
                    ref.read(personNotifierProvider.notifier).currentPersonDetail = person.copyWith();
                    context.goNamed(PersonDetailScreen.routeName);
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 14, right: 14),
                    child: AvatarPerson(
                      person: person,
                      size: 56,
                      isEditable: false,
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  margin: EdgeInsets.only(top: 62),
                  alignment: Alignment.topCenter,
                  child: Text(
                    person.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ColorName.loginTextColorGray,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                  ),
                )
              ],
            );
          }),
    );
  }

  Future<void> _handleLogout() async {
    try {
      // Show confirmation dialog
      final shouldLogout = await _showLogoutConfirmation();
      if (!shouldLogout) return;

      // Use a loading overlay instead of a dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return WillPopScope(
            onWillPop: () async => false, // Prevent back button
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ColorName.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: ColorName.homeGrayBalance.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(ColorName.homeBlackText),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Logging out...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ColorName.homeBlackText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );

      // Perform logout operations
      await _performLogout();

    } catch (e) {
      // Navigate back to close any dialogs, then show error
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error during logout: $e'),
            backgroundColor: ColorName.homeRedText,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _performLogout() async {

    // Sign out from Firebase Auth
    await UserService.signOut();

    // Small delay to ensure everything is processed
    await Future.delayed(Duration(milliseconds: 300));

    // Navigate to login screen using replacement to clear navigation stack
    if (mounted) {
      context.goNamed(LoginScreen.routeName);
    }
  }

  void _showUserMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // Allow custom height
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7, // Max 70% of screen height
          ),
          decoration: BoxDecoration(
            color: ColorName.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: ColorName.homeGrayBalance.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: SingleChildScrollView( // Make it scrollable
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: ColorName.homeGrayBalance,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // User info section
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: ColorName.blackColor,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: ColorName.homeGrayBalance,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                UserService.getCurrentUserEmail()?.split('@')[0] ?? 'User',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: ColorName.homeBlackText,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2),
                              Text(
                                UserService.getCurrentUserEmail() ?? '',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: ColorName.loginTextColorGray,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Menu items
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMenuItem(
                          icon: Icons.person_outline,
                          title: 'Profile',
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navigate to profile screen
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.settings_outlined,
                          title: 'Settings',
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navigate to settings screen
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navigate to help screen
                          },
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          height: 1,
                          color: ColorName.homeGrayHold,
                        ),
                        _buildMenuItem(
                          icon: Icons.logout,
                          title: 'Logout',
                          isDestructive: true,
                          onTap: () {
                            Navigator.pop(context);
                            _handleLogout();
                          },
                        ),
                      ],
                    ),
                  ),

                  // Bottom padding to ensure content is accessible
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDestructive ? ColorName.homeRedText.withOpacity(0.1) : ColorName.homeGrayHold,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 18,
                color: isDestructive ? ColorName.homeRedText : ColorName.homeBlackText,
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDestructive ? ColorName.homeRedText : ColorName.homeBlackText,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: ColorName.homeGrayBalance,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showLogoutConfirmation() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorName.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Logout',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ColorName.homeBlackText,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              fontSize: 16,
              color: ColorName.loginTextColorGray,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: ColorName.homeGrayBalance,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 8),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorName.homeRedText,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ) ?? false;
  }
}
