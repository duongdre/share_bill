import 'package:go_router/go_router.dart';
import 'package:share_bill/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/screens/home/UI/home_screen.dart';
import 'package:share_bill/screens/spent/UI/spent_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_bill/utilities/utils/dialogAddMember.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

import '../../../gen/colors.gen.dart';
import '../../../gen/fonts.gen.dart';
import '../../../models/data_models/group.dart';
import '../../../utilities/utils/dialogConfirmExpanseCollection.dart';
import '../../../utilities/utils/enum.dart';
import '../../../utilities/utils/person_avatar.dart';
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
  final FocusNode nameFocus = FocusNode();

  String bottomButtonName = "Trở lại";
  bool isNewGroup = true;

  @override
  void initState() {
    if (ref.read(groupNotifierProvider.notifier).currentGroupDetail.uid.isEmpty) {
      isNewGroup = true;
    } else {
      isNewGroup = false;
    }
    nameController = TextEditingController(text: ref.read(groupNotifierProvider.notifier).currentGroupDetail.name);
    nameFocus.addListener(onFocusChange);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
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
    ref.watch(groupNotifierProvider);
    final currentGroupDetail = ref.read(groupNotifierProvider.notifier).currentGroupDetail;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
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
                    teamList(),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            totalSpentReceive(),
                            historyTransaction(),
                          ],
                        ),
                      ),
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
    );
  }

  Widget teamList() {
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
            fontSize: 32,
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
              hintText: 'Nhập tên',
              hintStyle: TextStyle(
                color: ColorName.loginIconColorGray,
                fontSize: 32,
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
          height: 116,
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: group.members.length + 1,
                  itemBuilder: (context, index) {
                    final groupData = group.members.keys.toList();
                    if (index < group.members.length) {
                      return Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: PersonAvatar(
                              person: ref.read(personNotifierProvider.notifier).findPersonWithUid(groupData[index]),
                              size: 80,
                              isEditable: false,
                            ),
                          ),
                          Container(
                            width: 100,
                            margin: EdgeInsets.only(top: 96),
                            alignment: Alignment.topCenter,
                            child: Text(
                              ref.read(personNotifierProvider.notifier).findPersonWithUid(groupData[index])?.name ?? "",
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
                    } else {
                      return InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => DialogAddMember(),
                            barrierColor: ColorName.blackColor.withOpacity(0.15),
                          );
                          // ref.read(groupNotifierProvider.notifier).currentGroupDetail.members.addAll(other);
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
                                fontSize: 50,
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
                fontSize: 48,
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
                fontSize: 48,
                fontWeight: FontWeight.w700,
                letterSpacing: -2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget historyTransaction() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
      margin: EdgeInsets.only(bottom: 120, left: 16, right: 16),
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
              title: Text('Thành công sửa thông tin'),
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
