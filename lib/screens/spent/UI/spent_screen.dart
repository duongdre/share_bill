import 'dart:ffi';

import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_bill/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/models/data_models/group.dart';
import 'package:share_bill/screens/group/controller/group_provider.dart';
import 'package:share_bill/screens/home/UI/home_screen.dart';
import 'package:share_bill/screens/person/controller/person_provider.dart';
import 'package:share_bill/utilities/utils/dialog_choose_group.dart';
import 'package:share_bill/utilities/utils/dialog_choose_person.dart';
import 'package:share_bill/utilities/utils/enum.dart';
import 'package:share_bill/utilities/utils/avatar_group.dart';

import '../../../gen/colors.gen.dart';
import '../../../utilities/utils/utils.dart';
import '../../bill/UI/bill_management_screen.dart';
import '../../bill/controller/bill_provider.dart';

class SpentScreen extends ConsumerStatefulWidget {
  const SpentScreen({super.key});

  static const routeNameFromHome = '${HomeScreen.routePath}/spent';
  static const routePathFromHome = '/spent';

  static const routeNameFromBillManagement = '${BillManagementScreen.routePath}/spent';
  static const routePathFromBillManagement = '/spent';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SpentScreenState();
}

class _SpentScreenState extends ConsumerState<SpentScreen> {
  late TextEditingController amountController;
  int currentAmount = 0;

  @override
  void initState() {
    amountController = TextEditingController(text: ref.read(groupNotifierProvider.notifier).currentGroupDetail.name);

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(billNotifierProvider);
    final group = ref.read(billNotifierProvider.notifier).currentSpentGroup;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: ColorName.spentBackGround,
        ),
        child: SafeArea(
          child: Column(
            children: [
              header(),
              chooseGroup(group),
              Expanded(
                child: amout(),
              ),
              keyboard(),
              spentButton()
            ],
          ),
        ),
      ),
    );
  }

  // header
  Widget header() {
    return Container(
      height: 100,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              context.pop();
            },
            child: Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                color: ColorName.homeWhiteButtonBg,
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                boxShadow: [
                  BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
                ],
              ),
              child: Text(
                "<",
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
          ),
          Spacer(),
          Text(
            "Spent money",
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
          Spacer(),
          InkWell(
            onTap: () {},
            child: Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: ColorName.homeWhiteButtonBg,
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                boxShadow: [
                  BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
                ],
              ),
              child: Text(
                "?",
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
    );
  }

  // chooseGroup
  Widget chooseGroup(Group group) {
    return Container(
      height: 176,
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
      margin: const EdgeInsets.only(left: 16, right: 16),
      decoration: const BoxDecoration(
        color: ColorName.homeWhiteButtonBg,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    group.getNameForSpent(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ColorName.homeBlackText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: AvatarGroup(
                  group: group,
                  size: 80,
                ),
              ),
              Expanded(child: groupInfos(group)),
            ],
          )
        ],
      ),
    );
  }

  Widget groupInfos(Group group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.bottomLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  ref.read(billNotifierProvider.notifier).getAllMemberNameOfChoseGroup(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ColorName.homeBlackText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                ),
              ),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => DialogChooseGroup(),
                    barrierColor: ColorName.blackColor.withOpacity(0.15),
                  );
                },
                child: Container(
                  height: 40,
                  width: 80,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: ColorName.spentBackGroundButton,
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    boxShadow: [
                      BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 1, offset: Offset(1, 1)),
                    ],
                  ),
                  child: const Text(
                    "Nhóm",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ColorName.homeBlackText,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Total Spent: \$NaN",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: ColorName.homeBlackText,
              fontSize: 12,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  // amount
  Widget amout() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 16),
      child: TextField(
        controller: amountController,
        textAlign: TextAlign.center,
        cursorColor: ColorName.homeBlackText,
        style: const TextStyle(
          color: ColorName.homeBlackText,
          fontSize: 54,
          fontWeight: FontWeight.w500,
          shadows: <Shadow>[
            Shadow(
              offset: Offset(2.0, 2.0),
              blurRadius: 4.0,
              color: ColorName.homeGrayBalance,
            ),
          ],
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabled: false,
          hintText: 'Nhập số tiền',
          hintStyle: TextStyle(
            color: ColorName.loginIconColorGray,
            fontSize: 54,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
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
    );
  }

  // keyboard
  Widget keyboard() {
    final numpadData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "000", "0", "x"];

    return Container(
      height: 308,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 16),
      decoration: const BoxDecoration(
        color: ColorName.homeWhiteButtonBg,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
        ],
      ),
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
      child: Column(
        children: [
          for (int item1 in [0, 1, 2, 3])
            Row(
              children: [
                for (int item2 in [1, 2, 3])
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        print(numpadData[item2 + item1 * 3 - 1]);
                        final number = numpadData[item2 + item1 * 3 - 1];
                        if (number == "000") {
                          currentAmount = currentAmount * 1000;
                        } else if (isNumeric(number)) {
                          currentAmount = currentAmount * 10 + int.parse(number);
                        } else {
                          currentAmount = currentAmount ~/ 10;
                        }
                        amountController.text = NumberFormat.currency(locale: "vi_VN", symbol: "Đ").format(currentAmount);
                      },
                      child: Container(
                        height: 60,
                        margin: const EdgeInsets.all(4),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: ColorName.spentBackGroundButton,
                          borderRadius: const BorderRadius.all(Radius.circular(100)),
                          boxShadow: [
                            BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
                          ],
                        ),
                        child: Text(
                          numpadData[item2 + item1 * 3 - 1],
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
                    ),
                  )
              ],
            )
        ],
      ),
    );
  }

  // spent button
  Widget spentButton() {
    return InkWell(
      onTap: () {
        ref.read(billNotifierProvider.notifier).changeAmount(currentAmount);
        showDialog(
          context: context,
          builder: (_) => DialogChoosePerson(),
          barrierColor: ColorName.blackColor.withOpacity(0.15),
        );
      },
      child: Container(
        height: 60,
        // width: 120,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
        decoration: BoxDecoration(
          color: ColorName.groupManagementBackGroundButton,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          boxShadow: [
            BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
          ],
        ),
        child: Text(
          "Spent money",
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
}
