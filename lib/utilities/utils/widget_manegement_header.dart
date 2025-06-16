import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/gen/colors.gen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../screens/setting/UI/language_setting_screen.dart';
import '../../screens/setting/controller/language_provider.dart';
import '../../services/firebase_services/user_service.dart';
import 'package:go_router/go_router.dart';

class WidgetManagementHeader extends ConsumerWidget {
  final String title;
  final Widget? leadingWidget;
  final List<Widget>? customActions;
  final bool showUserSection;

  const WidgetManagementHeader({
    Key? key,
    required this.title,
    this.leadingWidget,
    this.customActions,
    this.showUserSection = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userEmail = UserService.getCurrentUserEmail() ?? 'Unknown User';
    final userName = userEmail.split('@')[0];
    final localizations = AppLocalizations.of(context);

    return Container(
      height: 56,
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: ColorName.white,
        boxShadow: [
          BoxShadow(color: ColorName.groupManagementBackground, blurRadius: 2, offset: Offset(2, 2)),
        ],
      ),
      child: Stack(
        children: [
          (title == "Home")
              ? Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: '${localizations.welcomeBack}, ',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                children: [
                  TextSpan(
                    text: userName,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ColorName.homeBlackText),
                  ),
                ],
              ),
            ),
          )
              : Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.notifications_none_sharp,
                size: 20,
              ),
              InkWell(
                onTap: () => _showUserMenu(context, ref),
                child: Container(
                  height: 32,
                  width: 32,
                  margin: EdgeInsets.only(left: 8, right: 16),
                  decoration: BoxDecoration(
                    color: ColorName.blackColor,
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
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
        ],
      ),
    );
  }

  void _showUserMenu(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final currentLanguage = ref.read(languageNotifierProvider.notifier).currentLanguageName;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
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
            child: SingleChildScrollView(
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
                          context: context,
                          icon: Icons.person_outline,
                          title: localizations.menuProfile,
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navigate to profile screen
                          },
                        ),
                        _buildMenuItem(
                          context: context,
                          icon: Icons.language,
                          title: '${localizations.menuLanguage} ($currentLanguage)',
                          onTap: () {
                            Navigator.pop(context);
                            context.pushNamed(LanguageSettingsScreen.routeName);
                          },
                        ),
                        _buildMenuItem(
                          context: context,
                          icon: Icons.settings_outlined,
                          title: localizations.menuSettings,
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navigate to settings screen
                          },
                        ),
                        _buildMenuItem(
                          context: context,
                          icon: Icons.help_outline,
                          title: localizations.menuHelp,
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
                          context: context,
                          icon: Icons.logout,
                          title: localizations.menuLogout,
                          isDestructive: true,
                          onTap: () {
                            Navigator.pop(context);
                            _handleLogout(context, localizations);
                          },
                        ),
                      ],
                    ),
                  ),

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
    required BuildContext context,
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

  Future<void> _handleLogout(BuildContext context, AppLocalizations localizations) async {
    try {
      final shouldLogout = await _showLogoutConfirmation(context, localizations);
      if (!shouldLogout) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return WillPopScope(
            onWillPop: () async => false,
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
                      localizations.pleaseWait,
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

      await UserService.signOut();
      await Future.delayed(Duration(milliseconds: 300));

      if (context.mounted) {
        context.goNamed('login');
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${localizations.error}: $e'),
            backgroundColor: ColorName.homeRedText,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<bool> _showLogoutConfirmation(BuildContext context, AppLocalizations localizations) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorName.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            localizations.logout,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ColorName.homeBlackText,
            ),
          ),
          content: Text(
            localizations.logoutConfirmation,
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
                localizations.cancel,
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
                  localizations.logout,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ) ??
        false;
  }
}