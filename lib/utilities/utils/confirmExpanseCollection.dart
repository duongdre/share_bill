import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_bill/gen/colors.gen.dart';
import 'package:share_bill/utilities/utils/enum.dart';

class DialogExpanseCollection extends ConsumerStatefulWidget {
  final ExpanseCollection collection;

  const DialogExpanseCollection(this.collection, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DialogExpanseCollectionState();
}

class _DialogExpanseCollectionState extends ConsumerState<DialogExpanseCollection> with SingleTickerProviderStateMixin {
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
                color: (widget.collection == ExpanseCollection.expanse) ? ColorName.spentBackGroundSpentDialog : ColorName.spentBackGroundReceiveDialog,
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
                        (widget.collection == ExpanseCollection.expanse) ? "Spent money" : "Receive money",
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
