import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_bill/gen/colors.gen.dart';
import 'package:share_bill/utilities/utils/enum.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

import '../../models/data_models/bill.dart';
import '../../screens/bill/controller/bill_provider.dart';
import '../../screens/group/controller/group_provider.dart';
import '../../screens/person/controller/person_provider.dart';
import 'avatar_person.dart';

class DialogChoosePerson extends ConsumerStatefulWidget {
  const DialogChoosePerson({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DialogChoosePerson();
}

class _DialogChoosePerson extends ConsumerState<DialogChoosePerson> with SingleTickerProviderStateMixin {
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
  Widget build(BuildContext context) {
    ref.watch(billNotifierProvider);
    final currentSpentGroup = ref
        .read(billNotifierProvider.notifier)
        .currentSpentGroup;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
              margin: EdgeInsets.all(20.0),
              // padding: EdgeInsets.all(16.0),
              height: 240.0,
              decoration: ShapeDecoration(
                color: ColorName.spentBackGroundReceiveDialog,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 16.0, left: 20.0, right: 20.0),
                    child: Text(
                      "Người thực hiện khoản chi này",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ColorName.homeWhiteButtonBg,
                        fontSize: 12,
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
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: currentSpentGroup.members.length,
                        itemBuilder: (context, index) {
                          final memberInGroup = ref.read(personNotifierProvider.notifier).findPersonWithUid(currentSpentGroup.members.keys.toList()[index]);
                          if (memberInGroup != null) {
                            return InkWell(
                              onTap: () {
                                ref.read(billNotifierProvider.notifier).choosePerson(memberInGroup);
                              },
                              child: Stack(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        width: 106,
                                        alignment: Alignment.topCenter,
                                        padding: EdgeInsets.only(top: 16, left: 10, right: 10),
                                        child: AvatarPerson(
                                          person: memberInGroup,
                                          size: 80,
                                          isEditable: false,
                                        ),
                                      ),
                                      Container(
                                        width: 106,
                                        margin: EdgeInsets.only(top: 108),
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                          memberInGroup.getPersonName(),
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
                                  (ref
                                      .read(billNotifierProvider.notifier)
                                      .currentSpentPerson
                                      .uid == memberInGroup.uid)
                                      ? Container(
                                    margin: EdgeInsets.only(top: 12, left: 30),
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
                          } else {
                            return null;
                          }
                        }),
                  ),
                  InkWell(
                    onTap: () async {
                      final billGroup = ref.read(billNotifierProvider.notifier).currentSpentGroup.uid;
                      final billPerson = ref.read(billNotifierProvider.notifier).currentSpentPerson.uid;
                      final billAmount = ref.read(billNotifierProvider.notifier).currentAmount;
                      if (billGroup.isEmpty || billPerson.isEmpty || billAmount == 0) {
                        toastification.show(
                          title: Text('Vui lòng điền đầy đủ thông tin'),
                          style: ToastificationStyle.fillColored,
                          autoCloseDuration: const Duration(seconds: 3),
                        );
                      } else {
                        await ref.read(billNotifierProvider.notifier).addNewBill(
                          Bill(
                            uid: Uuid().v4(),
                            groupId: billGroup,
                            personId: billPerson,
                            amount: billAmount,
                          ),
                        );
                        toastification.show(
                          title: Text('Thành công thêm khoản chi tiêu'),
                          style: ToastificationStyle.fillColored,
                          autoCloseDuration: const Duration(seconds: 3),
                        );
                        context.pop();
                        context.pop();
                      }
                    },
                    child: Container(
                      height: 60,
                      // width: 120,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 12, left: 16, right: 16),
                      decoration: BoxDecoration(
                        color: ColorName.homeWhiteButtonBg,
                        borderRadius: const BorderRadius.all(Radius.circular(100)),
                        boxShadow: [
                          BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
                        ],
                      ),
                      child: Text(
                        "Spent money",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: ColorName.groupManagementBackGroundButton,
                          fontSize: 16,
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
                  )
                ],
              )),
        ),
      ),
    );
  }
}
