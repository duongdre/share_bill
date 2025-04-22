import 'package:go_router/go_router.dart';
import 'package:share_bill/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/screens/bill/controller/bill_provider.dart';
import 'package:share_bill/screens/group/controller/group_provider.dart';
import 'package:share_bill/screens/home/UI/home_screen.dart';
import 'package:share_bill/screens/person/UI/person_detail_screen.dart';
import 'package:share_bill/screens/person/controller/person_provider.dart';
import 'package:share_bill/screens/spent/UI/spent_screen.dart';
import 'package:share_bill/utilities/utils/enum.dart';

import '../../../gen/colors.gen.dart';
import '../../../utilities/utils/avatar_dialog.dart';

class BillManagementScreen extends ConsumerStatefulWidget {
  static const routeName = 'bill_management';
  static const routePath = '/$routeName';

  const BillManagementScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BillManagementScreenState();
}

class _BillManagementScreenState extends ConsumerState<BillManagementScreen> {
  bool isShowingGroup = true;

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(billNotifierProvider);
    final bills = ref.read(billNotifierProvider.notifier).allBill;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: ColorName.groupManagementBackground,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  header(),
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: bills.length,
                        itemBuilder: (context, index) {
                          double bottomMargin = (index == bills.length - 1) ? 120 : 0;
                          final bill = (bills + bills + bills + bills)[index];
                          return Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: bottomMargin, left: 16, right: 4),
                                child: AvatarBill(
                                  bill: bill,
                                  size: 60,
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ],
              ),
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
          InkWell(
            onTap: () {
              context.pop();
            },
            child: Text(
              "< Trang chủ",
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
          const Spacer(),
          InkWell(
            onTap: () {
              context.goNamed(SpentScreen.routeNameFromBillManagement);
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
}
