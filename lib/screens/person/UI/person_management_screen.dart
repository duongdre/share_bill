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
  bool isShowingGroup = true;
  bool _isLoading = true;
  final FocusNode _searchFocusNode = FocusNode();
  ViewMode _currentViewMode = ViewMode.grid; // Default to list view
  PersonMenuItem? selectedPersonMenuItem;

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    _loadInitialData();
    super.initState();
  }

  @override
  void dispose() {
    // Always remember to dispose focus nodes
    _searchFocusNode.dispose();
    super.dispose();
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: RefreshIndicator(
                    onRefresh: _loadInitialData,
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
                                  viewMode: _currentViewMode,
                                  gridItemSize: ref.read(personNotifierProvider.notifier).itemSize,
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

  /* Widget build(BuildContext context) {
    ref.watch(personNotifierProvider);
    final persons = ref.read(personNotifierProvider.notifier).allPerson;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: ColorName.groupManagementBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              header(),
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: persons.length,
                    itemBuilder: (context, index) {
                      final person = persons[index];
                      return Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: personWidget(person),
                          ),
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }*/

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
      child: Row(
        children: [
          Icon(
            Icons.arrow_back,
            size: 25,
          ),
          const Spacer(),
          Text(
            "Person manager",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          PopupMenuButton<PersonMenuItem>(
            child: Icon(
              Icons.more_vert,
              size: 25,
            ),
            onSelected: (PersonMenuItem item) {
              FocusScope.of(context).unfocus();
              setState(() {
                switch (item) {
                  case PersonMenuItem.listView:
                    _currentViewMode = ViewMode.list;
                    break;
                  case PersonMenuItem.gridView:
                    _currentViewMode = ViewMode.grid;
                    break;
                }
                selectedPersonMenuItem = item;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<PersonMenuItem>>[
              PopupMenuItem<PersonMenuItem>(
                value: PersonMenuItem.gridView,
                child: Row(
                  children: [
                    Text('View as Grid  '),
                    Icon(
                      Icons.grid_view,
                      color: ColorName.textBlack,
                    ),
                  ],
                ),
              ),
              PopupMenuItem<PersonMenuItem>(
                value: PersonMenuItem.listView,
                child: Row(
                  children: [
                    Text('View as List  '),
                    Icon(
                      Icons.view_list,
                      color: ColorName.textBlack,
                    ),
                  ],
                ),
              ),
            ],
          )
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

  Widget personWidget(Person person) {
    return InkWell(
      onTap: () {
        ref.read(personNotifierProvider.notifier).currentPersonDetail = person.copyWith();
        context.goNamed(PersonDetailScreen.routeName);
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
        child: Container(
          padding: EdgeInsets.only(bottom: 0),
          child: Row(
            children: [
              Container(
                height: 60,
                width: 60,
                margin: EdgeInsets.only(top: 4, bottom: 8, left: 8, right: 8),
                child: AvatarPerson(
                  person: person,
                  size: 60,
                  isEditable: false,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ColorName.homeBlackText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 4.0,
                            color: ColorName.homeGrayBalance,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      person.getPersonDescribe(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ColorName.homeGrayBalance,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  // Before delete a person, needed to delete all person's present in each group
                  ref.read(groupNotifierProvider.notifier).deleteAPersonFromAllGroup(person.uid);
                  ref.read(personNotifierProvider.notifier).deletePerson(person.uid);
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                    color: ColorName.groupManagementBackground,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: ColorName.blackColor,
                    ),
                    boxShadow: [
                      BoxShadow(color: ColorName.homeBlackText, blurRadius: 1, offset: Offset(2, 2)),
                    ],
                  ),
                  child: Text(
                    "Xóa",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ColorName.homeBlackText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 4.0,
                          color: ColorName.homeGrayBalance,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
