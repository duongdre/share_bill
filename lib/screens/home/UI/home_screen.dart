import 'dart:io';
import 'dart:math';

import 'package:go_router/go_router.dart';
import 'package:share_bill/gen/assets.gen.dart';
import 'package:share_bill/models/data_models/person.dart';
import 'package:share_bill/screens/group/UI/group_management_screen.dart';
import 'package:share_bill/screens/home/controller/home_screen_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_bill/screens/person/UI/person_management_screen.dart';
import 'package:share_bill/screens/spent/UI/spent_screen.dart';
import 'package:share_bill/screens/transaction/UI/transaction_management_screen.dart';
import 'package:uuid/uuid.dart';

import '../../../gen/colors.gen.dart';
import '../../../utilities/utils/person_avatar.dart';

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
      final homeScreenNotifier = ref.read(homeScreenTotalNotifierProvider.notifier);
      await homeScreenNotifier.fetchAllPerson();
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
    final homeProvider = ref.watch(homeScreenTotalNotifierProvider);
    final persons = ref.read(homeScreenTotalNotifierProvider.notifier).allPerson;
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
                              balance(homeProvider, context),
                              sendReceiveAndFriends(persons),
                              groupList(),
                              historyTransaction(),
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
        // ref.read(homeScreenTotalNotifierProvider.notifier).addNewPerson(Person(
        //       uid: Uuid().v4(),
        //       name: "HungIct",
        //       yearOfBirth: 1997,
        //       avtUrl: "",
        //       groupId: [],
        //     ));
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

  Widget balance(HomeScreenTotalState homeProvider, BuildContext context) {
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
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "\$${homeProvider.totalSpent}",
            style: const TextStyle(
              color: ColorName.blackColor,
              fontSize: 48,
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
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                ref.read(homeScreenTotalNotifierProvider.notifier).minusTotalSpent(100.0);
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
                        fontSize: 24,
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
          height: 200,
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
                    "Bạn thân",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ColorName.homeBlackText,
                      fontSize: 20,
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
                        fontSize: 18,
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
                          Container(
                            child: PersonAvatar(
                              person: person,
                              size: 80,
                              isEditable: true,
                            ),
                          ),
                          Container(
                            width: 100,
                            margin: EdgeInsets.only(top: 96),
                            alignment: Alignment.topCenter,
                            child: Text(
                              person.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: ColorName.loginTextColorGray,
                                fontSize: 16,
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

  Widget groupList() {
    return Container(
      height: 200,
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
                "Nhóm bạn",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: ColorName.homeBlackText,
                  fontSize: 20,
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
                    fontSize: 18,
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  eachGroup(),
                  eachGroup(),
                  eachGroup(),
                  eachGroup(),
                  eachGroup(),
                  eachGroup(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget historyTransaction() {
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
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () async {
                  context.goNamed(TransactionManagementScreen.routeName);
                },
                child: Text(
                  "xem thêm",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.double,
                    color: ColorName.homeBlackText,
                    fontSize: 18,
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
          eachTransaction(),
          eachTransaction(),
          eachTransaction(),
          eachTransaction(),
          eachTransaction(),
          eachTransaction(),
          eachTransaction(),
          eachTransaction()
        ],
      ),
    );
  }

  Widget eachGroup() {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Stack(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: ColorName.homeWhiteAdd,
              borderRadius: BorderRadius.all(Radius.circular(100)),
              boxShadow: [
                BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(2, 2)),
              ],
            ),
          ),
          Container(
            height: 80,
            width: 80,
            margin: EdgeInsets.only(top: 4, left: 4),
            decoration: BoxDecoration(
              color: ColorName.homeWhiteAdd,
              borderRadius: BorderRadius.all(Radius.circular(100)),
              boxShadow: [
                BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(2, 2)),
              ],
            ),
          ),
          Container(
            height: 80,
            width: 80,
            margin: EdgeInsets.only(top: 8, left: 8),
            decoration: BoxDecoration(
              color: ColorName.homeWhiteAdd,
              borderRadius: BorderRadius.all(Radius.circular(100)),
              boxShadow: [
                BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(2, 2)),
              ],
            ),
          ),
          Container(
            height: 40,
            width: 40,
            margin: EdgeInsets.only(top: 50, left: 50),
            decoration: BoxDecoration(
              color: ColorName.homeWhiteButtonBg,
              borderRadius: BorderRadius.all(Radius.circular(100)),
              boxShadow: [
                BoxShadow(color: ColorName.homeWhiteButtonBg, blurRadius: 4, offset: Offset(2, 2)),
              ],
            ),
          ),
          Container(
            width: 100,
            margin: EdgeInsets.only(top: 96),
            child: Text(
              "Hương Dương",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: ColorName.loginTextColorGray,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }

  Widget eachTransaction() {
    return Container(
      margin: EdgeInsets.only(bottom: 20, right: 16),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: ColorName.homeWhiteAdd,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  boxShadow: [
                    BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(2, 2)),
                  ],
                ),
              ),
              Container(
                height: 80,
                width: 80,
                margin: EdgeInsets.only(top: 4, left: 4),
                decoration: BoxDecoration(
                  color: ColorName.homeWhiteAdd,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  boxShadow: [
                    BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(2, 2)),
                  ],
                ),
              ),
              Container(
                height: 80,
                width: 80,
                margin: EdgeInsets.only(top: 8, left: 8),
                decoration: BoxDecoration(
                  color: ColorName.homeWhiteAdd,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  boxShadow: [
                    BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(2, 2)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ăn tất niên",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ColorName.homeBlackText,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                ),
                Text(
                  "28 tháng 1 * 00:01 AM",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ColorName.loginTextColorGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Text(
            "-\$500k",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: ColorName.homeRedText,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
