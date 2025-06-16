import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/screens/bill/controller/bill_provider.dart';
import 'package:share_bill/utilities/utils/dialog_add_member.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';
import '../../../gen/colors.gen.dart';
import '../../../gen/fonts.gen.dart';
import '../../../models/data_models/bill.dart';
import '../../../models/data_models/group.dart';
import '../../../utilities/utils/avatar_person.dart';
import '../../../utilities/utils/widget_list_bill.dart';
import '../../person/controller/person_provider.dart';
import '../controller/group_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  bool isUpdateInfo = false;
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
    final localizations = AppLocalizations.of(context);
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
                    header(currentGroupDetail, localizations),
                    teamList(),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 16, top: 24, bottom: 16),
                              child: Text(
                                localizations.recentExpenses,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: ColorName.homeBlackText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            recentPayments(),
                            const SizedBox(height: 120)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Container(
                //   alignment: Alignment.bottomCenter,
                //   child: bottomButton(currentGroupDetail),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget header(Group currentGroupDetail, AppLocalizations localizations) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
        color: ColorName.white,
        boxShadow: [
          BoxShadow(color: ColorName.groupManagementBackground, blurRadius: 2, offset: Offset(2, 2)),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              context.pop();
            },
            child: const Icon(
              Icons.arrow_back,
              size: 25,
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 56,
            width: 200,
            child: TextField(
              onChanged: (value) {
                final groupName = ref.read(groupNotifierProvider.notifier).currentGroupDetail.name;
                if (groupName == value) {
                  setState(() {
                    isUpdateInfo = false;
                  });
                } else {
                  setState(() {
                    isUpdateInfo = true;
                  });
                }
              },
              focusNode: nameFocus,
              controller: nameController,
              textAlign: TextAlign.center,
              cursorColor: ColorName.homeBlackText,
              style: const TextStyle(
                color: ColorName.homeBlackText,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: -22.0),
                  border: InputBorder.none,
                  hintText: localizations.enterGroupName,
                  hintStyle: const TextStyle(
                    color: ColorName.loginIconColorGray,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () async {
              if (isNewGroup) {
                if (nameController.text.isEmpty) return;
                //Only call add New Group
                currentGroupDetail.uid = const Uuid().v4();
                currentGroupDetail.name = nameController.text;
                await ref.read(groupNotifierProvider.notifier).addNewGroup(
                      currentGroupDetail,
                    );
                toastification.show(
                  title: Text(localizations.addNewGroupSuccessfully),
                  style: ToastificationStyle.fillColored,
                  autoCloseDuration: const Duration(seconds: 3),
                );
              } else {
                if (isUpdateInfo == true) {
                  //Call Update group
                  await ref.read(groupNotifierProvider.notifier).updateGroupName(
                        currentGroupDetail.uid,
                        nameController.text,
                      );
                  toastification.show(
                    title: Text(localizations.updateInformationSuccessfully),
                    style: ToastificationStyle.fillColored,
                    autoCloseDuration: const Duration(seconds: 3),
                  );
                }
              }
              context.pop();
            },
            child: getHeaderIcon(),
          )
        ],
      ),
    );
  }

  Widget? getHeaderIcon() {
    IconData? data = Icons.add;
    if (isNewGroup) {
      data = Icons.add;
    } else {
      if (isUpdateInfo) {
        data = Icons.check_circle_outline;
      } else {
        return Container();
      }
    }
    return Icon(
      data,
      size: 32,
    );
  }

  Widget teamList() {
    ref.watch(groupNotifierProvider);
    return Container(
      color: ColorName.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: groupWidget(
              ref.read(groupNotifierProvider.notifier).currentGroupDetail,
            ),
          )
        ],
      ),
    );
  }

  Widget groupWidget(Group group) {
    final localizations = AppLocalizations.of(context);
    return Column(
      children: [
        const SizedBox(height: 18),
        SizedBox(
          height: 120,
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
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: AvatarPerson(
                                person: ref.read(personNotifierProvider.notifier).findPersonWithUid(eachPerson[index]),
                                size: 60,
                                isEditable: false,
                              ),
                            ),
                            Container(
                              width: 100,
                              margin: const EdgeInsets.only(top: 76),
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
                              width: 100,
                              margin: const EdgeInsets.only(top: 100),
                              alignment: Alignment.topCenter,
                              child: Text(
                                NumberFormat.currency(locale: "vi_VN", symbol: localizations.currency).format(groupWithTotalPaidByPerson[eachPerson[index]] ?? 0),
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
                            builder: (_) => const DialogAddMember(),
                            barrierColor: ColorName.blackColor.withOpacity(0.55),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 16, right: 10),
                          alignment: Alignment.topCenter,
                          child: const CircleAvatar(
                            radius: 31,
                            backgroundColor: ColorName.homeGrayHold,
                            child: Text(
                              "+",
                              style: TextStyle(
                                fontSize: 38,
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

  Widget recentPayments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListBill(
          bills: allBillOfGroup,
          scrollable: true,
          onBillTap: (bill) {
            ///TODO: Bill click
          },
        ),
      ],
    );
  }
}
