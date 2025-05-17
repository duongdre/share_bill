import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_bill/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/screens/spent/UI/spent_screen.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

import '../../../gen/colors.gen.dart';
import '../../../models/data_models/bill.dart';
import '../../../models/data_models/group.dart';
import '../../../models/data_models/person.dart';
import '../../../utilities/utils/avatar_dialog.dart';
import '../../../utilities/utils/avatar_group.dart';
import '../../../utilities/utils/avatar_person.dart';
import '../../bill/controller/bill_provider.dart';
import '../../group/controller/group_provider.dart';
import '../controller/person_provider.dart';

class PersonDetailScreen extends ConsumerStatefulWidget {
  static const routeName = 'person_detail';
  static const routePath = '/$routeName';

  const PersonDetailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends ConsumerState<PersonDetailScreen> {
  late TextEditingController nameController;
  late TextEditingController describeController;
  late List<Bill> allBillOfPerson;
  late List<Group> allGroupOfPerson;
  bool isNewPerson = true;
  bool isShowingGroup = true;

  @override
  void initState() {
    ref.read(personNotifierProvider.notifier).isLoadingImage = false;
    final currentPersonDetail = ref.read(personNotifierProvider.notifier).currentPersonDetail;
    if (currentPersonDetail.uid.isEmpty) {
      isNewPerson = true;
    } else {
      isNewPerson = false;
      allBillOfPerson = ref.read(billNotifierProvider.notifier).getAllBillOfPerson(currentPersonDetail.uid);
      allGroupOfPerson = ref.read(groupNotifierProvider.notifier).getAllGroupOfAPerson(currentPersonDetail.uid);
    }
    nameController = TextEditingController(text: currentPersonDetail.name ?? "");
    describeController = TextEditingController(text: currentPersonDetail.describe ?? "");
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    describeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(personNotifierProvider);
    final currentPersonDetail = ref.read(personNotifierProvider.notifier).currentPersonDetail;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: ColorName.groupManagementBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              header(),
              avatar(currentPersonDetail),
              switchButton(),
              (isNewPerson) ? const Spacer() : Expanded(child: groupOrHistoryTransaction()),
              bottomButton(currentPersonDetail),
            ],
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      height: 56,
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: ColorName.white,
        boxShadow: [
          BoxShadow(color: ColorName.groupManagementBackground, blurRadius: 2, offset: Offset(2, 2)),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.arrow_back,
            size: 25,
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              toastification.show(
                title: Text('Tính năng sẽ sớm ra mắt'),
                style: ToastificationStyle.fillColored,
                autoCloseDuration: const Duration(seconds: 3),
              );
            },
            child: Icon(
              Icons.settings,
              size: 32,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 4.0,
                  color: ColorName.homeGrayBalance,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget avatar(Person currentPersonDetail) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              boxShadow: [
                BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
              ],
            ),
            child: Stack(
              children: [
                AvatarPerson(
                  person: currentPersonDetail,
                  size: 160,
                  isEditable: true,
                ),
                (ref.read(personNotifierProvider.notifier).isLoadingImage)
                    ? Container(
                        alignment: Alignment.center,
                        child: Transform.scale(
                          scale: 2,
                          child: const CircularProgressIndicator(
                            strokeWidth: 8,
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
          SizedBox(height: 8),
          TextField(
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
                hintText: 'Nhập tên',
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
          TextField(
            controller: describeController,
            keyboardType: TextInputType.multiline,
            textAlign: TextAlign.center,
            cursorColor: ColorName.homeBlackText,
            style: const TextStyle(
              color: ColorName.homeBlackText,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Gợi nhớ hoặc mô tả về người dùng này ",
              hintStyle: const TextStyle(
                color: ColorName.loginIconColorGray,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              hintMaxLines: 3,
            ),
            minLines: 1,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget switchButton() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                isShowingGroup = true;
              });
              toastification.show(
                title: Text('Group của X'),
                style: ToastificationStyle.fillColored,
                autoCloseDuration: const Duration(seconds: 2),
              );
            },
            child: Container(
              height: 60,
              width: 120,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 16, bottom: 24, left: 16, right: 8),
              decoration: (isShowingGroup)
                  ? const BoxDecoration(
                      color: ColorName.groupManagementBackGroundButton,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      boxShadow: [
                        BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
                      ],
                    )
                  : BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(100)),
                      border: Border.all(),
                    ),
              child: Text(
                "Danh sách nhóm",
                overflow: TextOverflow.ellipsis,
                style: (isShowingGroup)
                    ? const TextStyle(
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
                      )
                    : const TextStyle(
                        color: ColorName.loginAvatarBackGround,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 4.0,
                            color: ColorName.homeWhiteButtonBg,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                isShowingGroup = false;
              });
              toastification.show(
                title: Text('Lịch sử chi tiêu của X'),
                style: ToastificationStyle.fillColored,
                autoCloseDuration: const Duration(seconds: 2),
              );
            },
            child: Container(
              height: 60,
              width: 120,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 16, bottom: 24, left: 8, right: 16),
              decoration: (isShowingGroup)
                  ? BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(100)),
                      border: Border.all(),
                    )
                  : const BoxDecoration(
                      color: ColorName.groupManagementBackGroundButton,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      boxShadow: [
                        BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
                      ],
                    ),
              child: Text(
                "Lịch sử chi tiêu",
                overflow: TextOverflow.ellipsis,
                style: (isShowingGroup)
                    ? const TextStyle(
                        color: ColorName.loginAvatarBackGround,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 4.0,
                            color: ColorName.homeWhiteButtonBg,
                          ),
                        ],
                      )
                    : const TextStyle(
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
          ),
        ),
      ],
    );
  }

  Widget groupOrHistoryTransaction() {
    if (isShowingGroup) {
      return historyGroup();
    } else {
      return historyTransaction();
    }
  }

  Widget historyGroup() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, bottom: 0, left: 16, right: 16),
      margin: const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
      decoration: const BoxDecoration(
        color: ColorName.homeWhiteButtonBg,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
        ],
      ),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: allGroupOfPerson.length,
          itemBuilder: (context, index) {
            final group = allGroupOfPerson[index];
            return Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 8, right: 16),
                  child: AvatarGroup(
                    group: group,
                    size: 80,
                  ),
                ),
                Expanded(child: groupInfos(group)),
              ],
            );
          }),
    );
  }

  Widget groupInfos(Group group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            group.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: ColorName.homeBlackText,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          ref.read(billNotifierProvider.notifier).getAllMemberNameOfAGroup(group),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: ColorName.homeBlackText,
            fontSize: 12,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 2,
        ),
        Text(
          NumberFormat.currency(locale: "vi_VN", symbol: "VNĐ").format(
              ref.read(billNotifierProvider.notifier).getGroupWithTotalPaidByPerson(ref.read(personNotifierProvider.notifier).currentPersonDetail.uid, group)),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: ColorName.homeBlackText,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 1,
        ),
      ],
    );
  }

  Widget historyTransaction() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, bottom: 0, left: 16, right: 16),
      margin: const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
      decoration: const BoxDecoration(
        color: ColorName.homeWhiteButtonBg,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
        ],
      ),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: allBillOfPerson.length,
          itemBuilder: (context, index) {
            final bill = allBillOfPerson[index];
            return AvatarBill(
              bill: bill,
              size: 40,
            );
          }),
    );
  }

  Widget bottomButton(Person currentPersonDetail) {
    return InkWell(
      onTap: () async {
        currentPersonDetail.name = nameController.text;
        currentPersonDetail.describe = describeController.text;
        if (isNewPerson) {
          currentPersonDetail.uid = Uuid().v4();
          await ref.read(personNotifierProvider.notifier).addNewPerson(currentPersonDetail);
          context.pop();
          toastification.show(
            title: Text('Thành công thêm mới'),
            style: ToastificationStyle.fillColored,
            autoCloseDuration: const Duration(seconds: 3),
          );
        } else {
          print("${currentPersonDetail.name}");
          await ref.read(personNotifierProvider.notifier).updatePersonDetails(
                ref.read(personNotifierProvider.notifier).currentPersonDetail.uid,
                currentPersonDetail.toMap(),
              );
          context.pop();
          toastification.show(
            title: Text('Thành công cập nhật thông tin'),
            style: ToastificationStyle.fillColored,
            autoCloseDuration: const Duration(seconds: 3),
          );
        }
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
          (isNewPerson) ? "Thêm" : "Cập nhật",
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
