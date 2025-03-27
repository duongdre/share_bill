import 'dart:io';
import 'dart:math';

import 'package:go_router/go_router.dart';
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
import '../../../utilities/utils/avatar_dialog.dart';
import '../../../utilities/utils/avatar_group.dart';
import '../../../utilities/utils/avatar_person.dart';
import '../../bill/UI/bill_management_screen.dart';
import '../../group/UI/group_detail_screen.dart';
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

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    _loadInitialData();
    super.initState();
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
        decoration: BoxDecoration(
          color: ColorName.homeWhiteAdd,
          image: DecorationImage(opacity: 0.5, image: Assets.images.gridBg.provider(), fit: BoxFit.cover),
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
                            children: [
                              balance(context),
                              sendReceiveAndFriends(persons),
                              groupList(groups),
                              historyTransaction(bills),
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
    return InkWell(
      onTap: () {
        // ref.read(billNotifierProvider.notifier).addNewBill(
        //       Bill(
        //         uid: Uuid().v4(),
        //         groupId: "7f6fc0e2-dc64-48bd-a332-855aa0e45f4d",
        //         personId: "77ad1052-8407-4d0d-baf7-6ae4a8c4ac54",
        //         amount: 2500000,
        //         description: "",
        //         createdAt: DateTime.now().millisecondsSinceEpoch,
        //       ),
        //     );
      },
      child: SizedBox(
        height: 100,
        child: Row(
          children: [
            //Logo
            Image(
              image: Assets.images.logo.provider(),
              fit: BoxFit.fill,
            ),
            const Spacer(),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: ColorName.whiteColor,
                borderRadius: const BorderRadius.all(Radius.circular(100)),
              ),
            ),
            Container(
              height: 50,
              width: 120,
              margin: EdgeInsets.only(left: 8, right: 16),
              decoration: BoxDecoration(
                color: ColorName.blackColor,
                borderRadius: const BorderRadius.all(Radius.circular(100)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget balance(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8),
          Text(
            "Duong's ${AppLocalizations.of(context).homeTotalSpent}",
            style: const TextStyle(
              color: ColorName.homeGrayBalance,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "\$${0}",
            style: const TextStyle(
              color: ColorName.blackColor,
              fontSize: 44,
              fontWeight: FontWeight.w700,
              letterSpacing: -2,
            ),
          ),
        ],
      ),
    );
  }

  Widget sendReceiveAndFriends(List<Person> persons) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                context.goNamed(SpentScreen.routeNameFromHome);
              },
              child: Container(
                height: 60,
                width: MediaQuery.sizeOf(context).width / 2 - 8 * 3,
                decoration: BoxDecoration(
                  color: ColorName.homeWhiteButtonBg,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(2, 2)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_upward_rounded,
                      size: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Chi thêm",
                      style: const TextStyle(
                        color: ColorName.homeBlackText,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                context.goNamed(SpentScreen.routeNameFromHome);
              },
              child: Container(
                height: 60,
                width: MediaQuery.sizeOf(context).width / 2 - 8 * 3,
                decoration: BoxDecoration(
                  color: ColorName.homeWhiteButtonBg,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(2, 2)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_downward_rounded,
                      size: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Nhận thêm",
                      style: const TextStyle(
                        color: ColorName.homeBlackText,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 160,
          width: double.infinity,
          padding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
          margin: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
          decoration: BoxDecoration(
            color: ColorName.homeWhiteButtonBg,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Bạn bè",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ColorName.homeBlackText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () async {
                      context.goNamed(PersonManagementScreen.routeName);
                    },
                    child: Text(
                      "xem thêm",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.double,
                        color: ColorName.homeBlackText,
                        fontSize: 14,
                        // fontWeight: FontWeight.w500,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 4.0,
                            color: ColorName.homeGrayBalance,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Expanded(
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
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: AvatarPerson(
                                person: person,
                                size: 60,
                                isEditable: false,
                              ),
                            ),
                          ),
                          Container(
                            width: 80,
                            margin: EdgeInsets.only(top: 76),
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
              )
            ],
          ),
        )
      ],
    );
  }

  Widget groupList(List<Group> groups) {
    return Container(
      height: 160,
      width: double.infinity,
      padding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
      margin: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: ColorName.homeWhiteButtonBg,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Nhóm",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: ColorName.homeBlackText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () async {
                  context.goNamed(GroupManagementScreen.routeName);
                },
                child: Text(
                  "xem thêm",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.double,
                    color: ColorName.homeBlackText,
                    fontSize: 14,
                    // fontWeight: FontWeight.w500,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 4.0,
                        color: ColorName.homeGrayBalance,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          ref.read(groupNotifierProvider.notifier).currentGroupDetail = group.copyWith();
                          context.goNamed(GroupDetailScreen.routeName);
                        },
                        child: Container(
                          width: 112,
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: AvatarGroup(
                            group: group,
                            size: 60,
                            isEditable: true,
                          ),
                        ),
                      ),
                      Container(
                        width: 112,
                        margin: EdgeInsets.only(top: 76),
                        alignment: Alignment.topCenter,
                        child: Text(
                          group.name,
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
          )
        ],
      ),
    );
  }

  Widget historyTransaction(List<Bill> bills) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
      margin: EdgeInsets.only(top: 16, bottom: 64, left: 16, right: 16),
      decoration: BoxDecoration(
        color: ColorName.homeWhiteButtonBg,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Lịch sử chi tiêu",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: ColorName.homeBlackText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () async {
                  context.goNamed(BillManagementScreen.routeName);
                },
                child: Text(
                  "xem thêm",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.double,
                    color: ColorName.homeBlackText,
                    fontSize: 14,
                    // fontWeight: FontWeight.w500,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 4.0,
                        color: ColorName.homeGrayBalance,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 60 * bills.length.toDouble(),
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: bills.length,
                itemBuilder: (context, index) {
                  final bill = bills[index];
                  return AvatarBill(
                    bill: bill,
                    size: 40,
                  );
                }),
          )
        ],
      ),
    );
  }
}
