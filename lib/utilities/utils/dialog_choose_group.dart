import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_bill/gen/colors.gen.dart';
import 'package:share_bill/screens/bill/controller/bill_provider.dart';
import 'package:share_bill/utilities/utils/enum.dart';
import 'package:share_bill/utilities/utils/avatar_person.dart';
import 'package:toastification/toastification.dart';

import '../../models/data_models/group.dart';
import '../../models/data_models/person.dart';
import '../../screens/group/controller/group_provider.dart';
import '../../screens/person/controller/person_provider.dart';
import 'avatar_group.dart';

class DialogChooseGroup extends ConsumerStatefulWidget {
  const DialogChooseGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DialogChooseGroup();
}

class _DialogChooseGroup extends ConsumerState<DialogChooseGroup> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize after dependencies are available
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(billNotifierProvider);
    final persons = ref.read(personNotifierProvider.notifier).allPerson;
    final groups = ref.read(groupNotifierProvider.notifier).allGroup;
    final bills = ref.read(billNotifierProvider.notifier).allBill;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(20.0),
              height: 200.0,
              decoration: ShapeDecoration(
                color: ColorName.spentBackGroundReceiveDialog,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 16.0, left: 20.0, right: 20.0),
                    child: const Text(
                      "Người thực hiện khoản chi này",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ColorName.homeWhiteButtonBg,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 4.0,
                            color: ColorName.loginAvatarBackGround,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: groups.length,
                        itemBuilder: (context, index) {
                          final group = groups[index];
                          return InkWell(
                            onTap: () {
                              ref.read(billNotifierProvider.notifier).chooseGroup(group);
                            },
                            child: Stack(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: 132,
                                      alignment: Alignment.topCenter,
                                      padding: EdgeInsets.only(left: 10, right: 10),
                                      child: AvatarGroup(
                                        group: group,
                                        size: 80,
                                        isEditable: true,
                                      ),
                                    ),
                                    Container(
                                      width: 132,
                                      margin: EdgeInsets.only(top: 96),
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
                                ),
                                (ref.read(billNotifierProvider.notifier).currentSpentGroup.uid == group.uid)
                                    ? Container(
                                        margin: EdgeInsets.only(left: 30),
                                        child: const CircleAvatar(
                                          radius: 20,
                                          backgroundColor: ColorName.blueColor,
                                          child: Icon(
                                            Icons.check_circle_outline_outlined,
                                            size: 40,
                                            color: ColorName.homeWhiteAdd,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
