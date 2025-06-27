import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/screens/bill/controller/bill_provider.dart';
import 'package:share_bill/utilities/utils/widget_list_bill.dart';
import '../../../gen/colors.gen.dart';
import '../../../utilities/utils/empty_state.dart';
import '../../../utilities/utils/widget_animated_search_bar.dart';
import '../../../utilities/utils/widget_manegement_header.dart';
import 'package:share_bill/gen/l10n/app_localizations.dart';

class BillManagementScreen extends ConsumerStatefulWidget {
  static const routeName = 'bill_management';
  static const routePath = '/$routeName';

  const BillManagementScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BillManagementScreenState();
}

class _BillManagementScreenState extends ConsumerState<BillManagementScreen> {
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  @override
  void dispose() {
    // Always remember to dispose focus nodes
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ref.watch(billNotifierProvider);
    final billNotifier = ref.read(billNotifierProvider.notifier);
    final bills = billNotifier.displayBills;
    final hasSearchQuery = billNotifier.searchQuery.isNotEmpty;

    return GestureDetector(
      behavior: HitTestBehavior.translucent, // Ensures taps are detected even on empty areas
      onTap: () {
        // Hide keyboard and remove focus when tapping elsewhere
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: ColorName.background,
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    WidgetManagementHeader(title: localizations.groupManager),
                    searchBar(),
                    Expanded(
                      child: bills.isEmpty
                          ? _buildEmptyState(hasSearchQuery, billNotifier.searchQuery)
                          : SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListBill(
                                    bills: bills,
                                    scrollable: true,
                                    onBillTap: (bill) {},
                                  ),
                                  const SizedBox(height: 32),
                                ],
                              ),
                            ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool hasSearchQuery, String searchQuery) {
    if (hasSearchQuery) {
      return EmptySearchState(
        searchQuery: searchQuery,
        type: "bills",
      );
    } else {
      return const EmptyBillsState();
    }
  }

  Widget searchBar() {
    return AnimatedSearchBar(
      focusNode: _searchFocusNode, // Pass our focus node to the search bar
      onSearch: (value) {
        print(value);
        ref.read(billNotifierProvider.notifier).searchBills(value);
      },
      onClear: () {
        ref.read(billNotifierProvider.notifier).resetSearchFilter();
      },
    );
  }
}
