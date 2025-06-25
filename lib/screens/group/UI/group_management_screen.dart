import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/utilities/utils/widget_list_group.dart';
import '../../../gen/colors.gen.dart';
import '../../../utilities/utils/widget_animated_search_bar.dart';
import '../../../utilities/utils/widget_manegement_header.dart';
import '../../bill/controller/bill_provider.dart';
import '../controller/group_provider.dart';
import 'group_detail_screen.dart';
import 'package:share_bill/gen/l10n/app_localizations.dart';

class GroupManagementScreen extends ConsumerStatefulWidget {
  const GroupManagementScreen({super.key});

  static const routeName = 'group_management';
  static const routePath = '/$routeName';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupManagementScreenState();
}

class _GroupManagementScreenState extends ConsumerState<GroupManagementScreen> {
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
    ref.watch(groupNotifierProvider);
    final groups = ref.read(groupNotifierProvider.notifier).displayGroups;
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
            child: Column(
              children: [
                WidgetManagementHeader(title: localizations.groupManager,),
                searchBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListGroup(
                          groups: groups,
                          scrollable: true,
                          onGroupTap: (group) {
                            ref.read(groupNotifierProvider.notifier).currentGroupDetail = group.copyWith();
                            context.goNamed(GroupDetailScreen.routeName);
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

  Widget searchBar() {
    return AnimatedSearchBar(
      focusNode: _searchFocusNode, // Pass our focus node to the search bar
      onSearch: (value) {
        print(value);
        ref.read(groupNotifierProvider.notifier).searchGroups(value);
      },
      onClear: () {
        ref.read(groupNotifierProvider.notifier).resetSearchFilter();
      },
    );
  }
}
