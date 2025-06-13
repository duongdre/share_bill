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
import '../../../utilities/utils/widget_manegement_header.dart';
import '../../bill/UI/bill_management_screen.dart';
import '../../group/UI/dialog_add_group.dart';
import '../../group/UI/group_detail_screen.dart';
import '../../login/UI/login_screen.dart';
import '../../person/UI/dialog_add_person.dart';
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
                      const WidgetManagementHeader(title: 'Home',),
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

  Widget homeAddSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => _showAddPersonDialog(),
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
              onTap: () => _showAddGroupDialog(),
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

  void _showAddPersonDialog() {
    // Clear any existing person data
    ref.read(personNotifierProvider.notifier).clearNewPersonData();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const DialogAddPerson(),
    );
  }

  void _showAddGroupDialog() {
    // Clear any existing group data
    ref.read(groupNotifierProvider.notifier).clearNewGroupData();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const DialogAddGroup(),
    );
  }
}
