import 'package:flutter/material.dart';
import 'package:share_bill/gen/colors.gen.dart';
import 'package:share_bill/gen/l10n/app_localizations.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final double? iconSize;
  final Color? iconColor;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.iconSize = 64,
    this.iconColor = ColorName.loginTextColorGray,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: ColorName.textBlack,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: ColorName.loginTextColorGray,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Specific empty state widgets
class EmptyPersonsState extends StatelessWidget {

  const EmptyPersonsState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return EmptyState(
      icon: Icons.person_add_outlined,
      title: localizations.noPersonsYet,
      description: localizations.startByAddingPeopleToTrackExpenses,
    );
  }
}

class EmptyGroupsState extends StatelessWidget {

  const EmptyGroupsState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return EmptyState(
      icon: Icons.group_add_outlined,
      title: localizations.noGroupsYet,
      description: localizations.createGroupsToOrganizeExpenses,
    );
  }
}

class EmptyBillsState extends StatelessWidget {

  const EmptyBillsState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return EmptyState(
      icon: Icons.receipt_long_outlined,
      title: localizations.noBillsYet,
      description: localizations.startTrackingExpensesByAddingBills,
    );
  }
}

class EmptySearchState extends StatelessWidget {
  final String searchQuery;
  final String type; // "persons", "groups", "bills"

  const EmptySearchState({
    super.key,
    required this.searchQuery,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return EmptyState(
      icon: Icons.search_off_outlined,
      title: localizations.noResultsFound,
      description: "No data found for: \"$searchQuery\"",
      iconColor: ColorName.homeGrayBalance,
    );
  }
}