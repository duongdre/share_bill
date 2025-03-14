import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_bill/gen/colors.gen.dart';
import 'package:share_bill/utilities/utils/enum.dart';
import 'package:share_bill/utilities/utils/person_avatar.dart';

import '../../screens/person/controller/person_provider.dart';

class DialogAddMember extends ConsumerStatefulWidget {
  const DialogAddMember({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DialogAddMember();
}

class _DialogAddMember extends ConsumerState<DialogAddMember> with SingleTickerProviderStateMixin {
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
    final persons = ref.read(personNotifierProvider.notifier).allPerson;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(20.0),
              height: 260.0,
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
                        fontSize: 20,
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
                        itemCount: persons.length,
                        itemBuilder: (context, index) {
                          final person = persons[index];
                          return InkWell(
                            onTap: () {},
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 16, left: 10, right: 10),
                                  child: PersonAvatar(
                                    person: person,
                                    size: 80,
                                    isEditable: false,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 30),
                                  // TODO: HERE
                                  child: const CircleAvatar(
                                    radius: 20,
                                    backgroundColor: ColorName.blueColor,
                                    child: Icon(
                                      Icons.check_circle_outline_outlined,
                                      size: 40,
                                      color: ColorName.homeWhiteAdd,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  margin: EdgeInsets.only(top: 104),
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
                            ),
                          );
                        }),
                  ),
                  InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: Container(
                      height: 60,
                      // width: 120,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
                      decoration: BoxDecoration(
                        color: ColorName.homeWhiteButtonBg,
                        borderRadius: const BorderRadius.all(Radius.circular(100)),
                        boxShadow: [
                          BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
                        ],
                      ),
                      child: Text(
                        "Thêm",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: ColorName.groupManagementBackGroundButton,
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
                  )
                ],
              )),
        ),
      ),
    );
  }
}
