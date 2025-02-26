import 'package:go_router/go_router.dart';
import 'package:share_bill/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/screens/home/UI/home_screen.dart';
import 'package:share_bill/screens/person_profile/UI/person_profile_screen.dart';
import 'package:share_bill/screens/spent/UI/spent_screen.dart';

import '../../../gen/colors.gen.dart';
import 'group_detail_screen.dart';

class GroupManagementScreen extends ConsumerStatefulWidget {
  const GroupManagementScreen({super.key});

  static const routeName = 'group_management';
  static const routePath = '/$routeName';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupManagementScreenState();
}

class _GroupManagementScreenState extends ConsumerState<GroupManagementScreen> {
  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      teamList(),
                      teamList(),
                      teamList(),
                      teamList(),
                      teamList(),
                      teamList(),
                      closeButton(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      height: 100,
      child: Row(
        children: [
          SizedBox(width: 16),
          Text(
            "Groups",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: ColorName.homeBlackText,
              fontSize: 20,
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
          const Spacer(),
          InkWell(
            onTap: () {
              _showPopupMenu();
            },
            child: Container(
              height: 50,
              width: 120,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 8, right: 16),
              decoration: BoxDecoration(
                color: ColorName.homeWhiteButtonBg,
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                boxShadow: [
                  BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
                ],
              ),
              child: Text(
                "New",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: ColorName.homeBlackText,
                  fontSize: 20,
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
    );
  }

  Widget teamList() {
    return InkWell(
      onTap: () {
        context.goNamed(GroupDetailScreen.routeName);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 16, bottom: 16),
        margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
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
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    "Tên nhóm",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ColorName.homeBlackText,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
            // SizedBox(height: 12),
            Container(
              // color: Colors.red,
              padding: EdgeInsets.only(bottom: 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      margin: EdgeInsets.only(top: 4, bottom: 8, left: 8, right: 8),
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
                      margin: EdgeInsets.only(top: 4, bottom: 8, left: 8, right: 8),
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
                      margin: EdgeInsets.only(top: 4, bottom: 8, left: 8, right: 8),
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
                      margin: EdgeInsets.only(top: 4, bottom: 8, left: 8, right: 8),
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
                      margin: EdgeInsets.only(top: 4, bottom: 8, left: 8, right: 8),
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
                      margin: EdgeInsets.only(top: 4, bottom: 8, left: 8, right: 8),
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
                      margin: EdgeInsets.only(top: 4, bottom: 8, left: 8, right: 8),
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
                      margin: EdgeInsets.only(top: 4, bottom: 8, left: 8, right: 8),
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
              ),
            ),
            totalSpentReceive(),
            SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Spacer(),
                  InkWell(
                    onTap: () {
                      context.goNamed(SpentScreen.routeName);
                    },
                    child: Container(
                      height: 40,
                      width: 280,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 8, right: 16),
                      decoration: BoxDecoration(
                        color: ColorName.homeWhiteButtonBg,
                        borderRadius: const BorderRadius.all(Radius.circular(100)),
                        boxShadow: [
                          BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 8, offset: Offset(1, 1)),
                        ],
                      ),
                      child: Text(
                        "Thêm khoản chi cho nhóm",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: ColorName.homeBlackText,
                          fontSize: 20,
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
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget totalSpentReceive() {
    return Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 16),
            child: Text(
              "-\$xxx.xxx",
              style: const TextStyle(
                color: ColorName.homeRedText,
                fontSize: 32,
                fontWeight: FontWeight.w700,
                letterSpacing: -2,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 16),
            child: Text(
              "+\$xxx.xxx",
              style: const TextStyle(
                color: ColorName.spentBackGroundReceiveDialog,
                fontSize: 32,
                fontWeight: FontWeight.w700,
                letterSpacing: -2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget closeButton() {
    return InkWell(
      onTap: () {
        context.pop();
      },
      child: Container(
        height: 60,
        width: 120,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 16, bottom: 24),
        decoration: BoxDecoration(
          color: ColorName.groupManagementBackGroundButton,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          boxShadow: [
            BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
          ],
        ),
        child: Text(
          "Close",
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: ColorName.homeWhiteButtonBg,
            fontSize: 20,
            fontWeight: FontWeight.w400,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 4.0,
                color: ColorName.loginAvatarBackGround,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPopupMenu() async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(1000, 100, 100, 100),
      items: [
        PopupMenuItem<String>(child: const Text("New Group"), value: "New Group"),
        PopupMenuItem<String>(child: const Text("New Person"), value: "New Person"),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == "New Group") {
        print("New Group");
      } else {
        print("New Person");
        context.goNamed(PersonProfileScreen.routeName);
      }
    });
  }
}
