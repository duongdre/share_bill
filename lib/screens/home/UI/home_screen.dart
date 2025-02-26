import 'dart:io';
import 'dart:math';

import 'package:go_router/go_router.dart';
import 'package:share_bill/gen/assets.gen.dart';
import 'package:share_bill/models/data_models/person.dart';
import 'package:share_bill/screens/group_management/UI/group_management_screen.dart';
import 'package:share_bill/screens/home/controller/home_screen_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_bill/screens/spent/UI/spent_screen.dart';
import 'package:uuid/uuid.dart';

import '../../../gen/colors.gen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  static const routeName = 'home';
  static const routePath = '/$routeName';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = ref.watch(homeScreenTotalNotifierProvider);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: ColorName.homeWhiteAdd,
          image: DecorationImage(opacity: 0.5, image: Assets.images.gridBg.provider(), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            children: [
              header(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      balance(homeProvider, context),
                      sendReceiveAndAds(),
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
    );
  }

  Widget header() {
    return Container(
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
          SizedBox(height: 8),
          FittedBox(
            child: Container(
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
              decoration: BoxDecoration(
                color: ColorName.homeGrayHold,
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                boxShadow: [
                  BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(2, 2)),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                "Tổng nợ: \$2,500",
                style: const TextStyle(
                  color: ColorName.homeGrayBalance,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget sendReceiveAndAds() {
    return Column(
      children: [
        SizedBox(height: 30),
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
        // Ads
        /*Container(
          height: 120,
          width: double.infinity,
          padding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
          margin: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
          decoration: BoxDecoration(
            color: ColorName.blackColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Thông báo cho bạn bè về số nợ của họ",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ColorName.homeGrayHold,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Giúp bạn bè không \"quên\" về số tiền mà họ đang nợ bạn sau mỗi dịp đáng nhớ",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ColorName.loginTextColorGray,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                    )
                  ],
                ),
              ),
              Transform.rotate(
                angle: 30 * pi / 180,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.notifications_active,
                    color: ColorName.whiteColor,
                    size: 60,
                  ),
                ),
              )
            ],
          ),
        )*/
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
              Text(
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
