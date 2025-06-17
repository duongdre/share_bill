import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../gen/colors.gen.dart';
import '../controller/language_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  static const routeName = 'language_settings';
  static const routePath = '/$routeName';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final currentLocale = ref.watch(languageNotifierProvider);
    final languageNotifier = ref.read(languageNotifierProvider.notifier);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: ColorName.background,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, localizations),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildLanguageOption(
                      context: context,
                      title: 'English',
                      subtitle: 'English (United States)',
                      languageCode: 'en',
                      currentLanguage: currentLocale.languageCode,
                      onTap: () async {
                        await languageNotifier.changeLanguage('en');
                        if (context.mounted) {
                          _showLanguageChangedSnackBar(context, 'Language changed to English');
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildLanguageOption(
                      context: context,
                      title: 'Tiếng Việt',
                      subtitle: 'Vietnamese',
                      languageCode: 'vi',
                      currentLanguage: currentLocale.languageCode,
                      onTap: () async {
                        await languageNotifier.changeLanguage('vi');
                        if (context.mounted) {
                          _showLanguageChangedSnackBar(context, 'Đã chuyển sang tiếng Việt');
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                    _buildInfoCard(context, localizations),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations localizations) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
        color: ColorName.white,
        boxShadow: [
          BoxShadow(
            color: ColorName.groupManagementBackground,
            blurRadius: 2,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => context.pop(),
            child: const Icon(
              Icons.arrow_back,
              size: 25,
              color: ColorName.homeBlackText,
            ),
          ),
          const Spacer(),
          Text(
            localizations.settingsLanguage,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorName.homeBlackText,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 25), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String languageCode,
    required String currentLanguage,
    required VoidCallback onTap,
  }) {
    final isSelected = languageCode == currentLanguage;

    return Container(
      decoration: BoxDecoration(
        color: ColorName.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.withOpacity(0.1) : ColorName.homeGrayHold,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.language,
                  color: isSelected ? Colors.blue : ColorName.homeGrayBalance,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.blue : ColorName.homeBlackText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: ColorName.loginTextColorGray,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.blue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              localizations.settingsLanguageInfo,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageChangedSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}