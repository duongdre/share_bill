import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_bill/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/screens/bill/controller/bill_provider.dart';
import 'package:share_bill/screens/home/UI/home_screen.dart';
import 'package:share_bill/screens/spent/UI/spent_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_bill/utilities/utils/dialog_add_member.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

import '../../../gen/colors.gen.dart';
import '../../../gen/fonts.gen.dart';
import '../../../models/data_models/bill.dart';
import '../../../models/data_models/group.dart';
import '../../../utilities/utils/avatar_dialog.dart';
import '../../../utilities/utils/dialog_choose_person.dart';
import '../../../utilities/utils/enum.dart';
import '../../../utilities/utils/avatar_person.dart';
import '../../person/controller/person_provider.dart';
import '../controller/group_provider.dart';

class GroupDetailScreen extends ConsumerStatefulWidget {
  const GroupDetailScreen({super.key});

  static const routeName = 'group_detail';
  static const routePath = '/$routeName';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen> {
  late TextEditingController nameController;
  late List<Bill> allBillOfGroup;
  late Map<String, double> groupWithTotalPaidByPerson;
  final FocusNode nameFocus = FocusNode();

  String bottomButtonName = "Trở lại";
  bool isNewGroup = true;

  @override
  void initState() {
    final groupData = ref.read(groupNotifierProvider.notifier).currentGroupDetail;
    if (groupData.uid.isEmpty) {
      isNewGroup = true;
    } else {
      isNewGroup = false;
      allBillOfGroup = ref.read(billNotifierProvider.notifier).getAllBillOfGroup(groupData.uid);
      calculatePersonAndTheirPaid(groupData);
    }
    nameController = TextEditingController(text: groupData.name);
    nameFocus.addListener(onFocusChange);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  void calculatePersonAndTheirPaid(Group group) {
    groupWithTotalPaidByPerson = ref.read(billNotifierProvider.notifier).getPersonWithPaidInGroup(group);
    for (final person in group.members.keys) {
      if (group.members[person] == true) {
        if (groupWithTotalPaidByPerson[person] == null) {
          groupWithTotalPaidByPerson[person] = 0;
        }
      }
    }
  }

  @override
  void dispose() {
    nameFocus.removeListener(onFocusChange);
    nameFocus.dispose();
    nameController.dispose();
    super.dispose();
  }

  void onFocusChange() {
    print("Focus: ${nameFocus.hasFocus.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    final currentGroupDetail = ref.read(groupNotifierProvider.notifier).currentGroupDetail;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: ColorName.groupManagementBackground,
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    header(),
                    teamList(),
                    Expanded(
                      child: SingleChildScrollView(scrollDirection: Axis.vertical, child: (!isNewGroup) ? historyTransaction() : Container()),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: bottomButton(currentGroupDetail),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      height: 65,
      padding: EdgeInsets.only(left: 16),
      alignment: Alignment.bottomLeft,
      child: InkWell(
        onTap: () {
          context.pop();
        },
        child: Text(
          "< Nhóm",
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
    );
  }

  Widget teamList() {
    ref.watch(groupNotifierProvider);
    return Column(
      children: [
        TextField(
          onChanged: (value) {
            final groupName = ref.read(groupNotifierProvider.notifier).currentGroupDetail.name;
            if (groupName == value) {
              setState(() {
                bottomButtonName = "Trở lại";
              });
            } else {
              setState(() {
                bottomButtonName = "Cập nhật";
              });
            }
          },
          focusNode: nameFocus,
          controller: nameController,
          textAlign: TextAlign.center,
          cursorColor: ColorName.homeBlackText,
          style: const TextStyle(
            color: ColorName.homeBlackText,
            fontSize: 28,
            fontWeight: FontWeight.w400,
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
              hintText: 'Nhập tên nhóm',
              hintStyle: TextStyle(
                color: ColorName.loginIconColorGray,
                fontSize: 28,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 4.0,
                    color: ColorName.homeGrayBalance,
                  ),
                ],
              )),
        ),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: groupWidget(
            ref.read(groupNotifierProvider.notifier).currentGroupDetail,
          ),
        )
      ],
    );
  }

  Widget groupWidget(Group group) {
    return Column(
      children: [
        const SizedBox(height: 18),
        SizedBox(
          height: 140,
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: group.members.length + 1,
                  itemBuilder: (context, index) {
                    final eachPerson = group.members.keys.toList();
                    if (index < group.members.length) {
                      if (group.members[eachPerson[index]] == true) {
                        return Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: AvatarPerson(
                                person: ref.read(personNotifierProvider.notifier).findPersonWithUid(eachPerson[index]),
                                size: 80,
                                isEditable: false,
                              ),
                            ),
                            Container(
                              width: 120,
                              margin: EdgeInsets.only(top: 96),
                              alignment: Alignment.topCenter,
                              child: Text(
                                ref.read(personNotifierProvider.notifier).findPersonWithUid(eachPerson[index])?.name ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: ColorName.loginTextColorGray,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                              ),
                            ),
                            Container(
                              width: 120,
                              margin: EdgeInsets.only(top: 120),
                              alignment: Alignment.topCenter,
                              child: Text(
                                NumberFormat.currency(locale: "vi_VN", symbol: "VNĐ").format(groupWithTotalPaidByPerson[eachPerson[index]]),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: ColorName.blackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                              ),
                            )
                          ],
                        );
                      } else {
                        return Container();
                      }
                    } else {
                      return InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => DialogAddMember(),
                            barrierColor: ColorName.blackColor.withOpacity(0.15),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.topCenter,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: ColorName.homeGrayHold,
                            child: Text(
                              "+",
                              style: TextStyle(
                                fontSize: 46,
                                fontFamily: FontFamily.raleway,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget historyTransaction() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: EdgeInsets.only(top: 16, bottom: 0, left: 16, right: 16),
      margin: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
      decoration: BoxDecoration(
        color: ColorName.homeWhiteButtonBg,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
        ],
      ),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: allBillOfGroup.length,
          itemBuilder: (context, index) {
            final bill = allBillOfGroup[index];
            return AvatarBill(
              bill: bill,
              size: 40,
            );
          }),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                ),
                Text(
                  "28 tháng 1 * 00:01 AM",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ColorName.loginTextColorGray,
                    fontSize: 12,
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
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget bottomButton(Group currentGroupDetail) {
    return InkWell(
      onTap: () async {
        if (isNewGroup) {
          if (nameController.text.isEmpty) return;
          //Only call add New Group
          currentGroupDetail.uid = Uuid().v4();
          currentGroupDetail.name = nameController.text;
          await ref.read(groupNotifierProvider.notifier).addNewGroup(
                currentGroupDetail,
              );
          toastification.show(
            title: Text('Thành công thêm mới'),
            style: ToastificationStyle.fillColored,
            autoCloseDuration: const Duration(seconds: 3),
          );
        } else {
          if (bottomButtonName == "Cập nhật") {
            //Call Update group
            await ref.read(groupNotifierProvider.notifier).updateGroupName(
                  currentGroupDetail.uid,
                  nameController.text,
                );
            toastification.show(
              title: Text('Thành công cập nhật thông tin'),
              style: ToastificationStyle.fillColored,
              autoCloseDuration: const Duration(seconds: 3),
            );
          }
        }
        context.pop();
      },
      child: Container(
        height: 60,
        width: 120,
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: ColorName.groupManagementBackGroundButton,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          boxShadow: [
            BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
          ],
        ),
        child: Text(
          (isNewGroup) ? "Thêm mới" : bottomButtonName,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: ColorName.homeWhiteButtonBg,
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
    );
  }
}
