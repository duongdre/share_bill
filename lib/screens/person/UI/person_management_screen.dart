import 'package:go_router/go_router.dart';
import 'package:share_bill/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/models/data_models/person.dart';
import 'package:share_bill/screens/group/controller/group_provider.dart';
import 'package:share_bill/screens/home/UI/home_screen.dart';
import 'package:share_bill/screens/person/UI/person_detail_screen.dart';
import 'package:share_bill/screens/spent/UI/spent_screen.dart';
import 'package:share_bill/utilities/utils/enum.dart';
import 'package:share_bill/utilities/utils/widget_list_person.dart';

import '../../../gen/colors.gen.dart';
import '../../../utilities/utils/avatar_person.dart';
import '../../../utilities/utils/widget_animated_search_bar.dart';
import '../../bill/controller/bill_provider.dart';
import '../controller/person_provider.dart';

class PersonManagementScreen extends ConsumerStatefulWidget {
  static const routeName = 'person_management';
  static const routePath = '/$routeName';

  const PersonManagementScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PersonManagementScreenState();
}

class _PersonManagementScreenState extends ConsumerState<PersonManagementScreen> {
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
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
    ref.watch(personNotifierProvider);
    ref.watch(groupNotifierProvider);
    ref.watch(billNotifierProvider);
    final persons = ref.read(personNotifierProvider.notifier).allPerson;
    final groups = ref.read(groupNotifierProvider.notifier).allGroup;
    final bills = ref.read(billNotifierProvider.notifier).getFirst5Bills();
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
                header(),
                searchBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListPerson(
                          persons: persons,
                          scrollable: true,
                          onPersonTap: (person) {
                            ref.read(personNotifierProvider.notifier).currentPersonDetail = person.copyWith();
                            context.goNamed(PersonDetailScreen.routeName);
                          },
                        ),
                        const SizedBox(height: 16),
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

  // This is for change gridview items size
  // Widget _buildViewToggle() {
  // return Slider(
  //   value: ref.read(personNotifierProvider.notifier).itemSize,
  //   max: 165,
  //   min: 66,
  //   divisions: 10,
  //   onChanged: (value) {
  //     ref.read(personNotifierProvider.notifier).onChangeItemSize(value);
  //   },
  // );
  // }

  Widget header() {
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
          Align(
            alignment: Alignment.center,
            child: Text(
              "Person manager",
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
              Container(
                height: 32,
                width: 32,
                margin: EdgeInsets.only(left: 8, right: 16),
                decoration: BoxDecoration(
                  color: ColorName.blackColor,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget searchBar() {
    return AnimatedSearchBar(
      focusNode: _searchFocusNode, // Pass our focus node to the search bar
      onSearch: (value) {
        // ref.read(personNotifierProvider.notifier).searchPersons(value);
      },
      onClear: () {
        // ref.read(personNotifierProvider.notifier).resetSearchFilter();
      },
    );
  }
}
