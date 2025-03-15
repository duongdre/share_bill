import 'package:go_router/go_router.dart';
import 'package:share_bill/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/models/data_models/group.dart';
import 'package:share_bill/screens/home/UI/home_screen.dart';
import 'package:share_bill/screens/spent/UI/spent_screen.dart';

import '../../../gen/colors.gen.dart';
import '../../../models/data_models/person.dart';
import '../../../utilities/utils/group_avatar.dart';
import '../../../utilities/utils/person_avatar.dart';
import '../../person/UI/person_detail_screen.dart';
import '../../person/controller/person_provider.dart';
import '../controller/group_provider.dart';
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
    ref.watch(groupNotifierProvider);
    final groups = ref.read(groupNotifierProvider.notifier).allGroup;
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
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    return Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: groupWidget(group),
                        ),
                      ],
                    );
                  },
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
          InkWell(
            onTap: () {
              context.pop();
            },
            child: Text(
              "< Trang chủ",
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
          const Spacer(),
          InkWell(
            onTap: () {
              context.goNamed(GroupDetailScreen.routeName);
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

  Widget groupWidget(Group group) {
    return InkWell(
      onTap: () {
        ref.read(groupNotifierProvider.notifier).currentGroupDetail = group.copyWith();
        context.goNamed(GroupDetailScreen.routeName);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 16, bottom: 16),
        margin: EdgeInsets.only(bottom: 16, left: 8, right: 8),
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
                    group.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ColorName.homeBlackText,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    ref.read(groupNotifierProvider.notifier).deleteGroup(group.uid);
                  },
                  child: Icon(
                    Icons.delete_forever,
                    size: 29,
                  ),
                ),
                SizedBox(width: 12)
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 116,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: group.members.length,
                      itemBuilder: (context, index) {
                        final groupData = group.members.keys.toList();
                        if (group.members[groupData[index]] == true) {
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
                          return Container();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            totalSpentReceive(),
            SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Spacer(),
                  InkWell(
                    onTap: () {},
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
            margin: EdgeInsets.only(top: 16, bottom: 16),
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
}
