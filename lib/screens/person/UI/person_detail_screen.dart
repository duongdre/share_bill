import 'package:go_router/go_router.dart';
import 'package:share_bill/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/screens/spent/UI/spent_screen.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

import '../../../gen/colors.gen.dart';
import '../../../models/data_models/person.dart';
import '../../../utilities/utils/person_avatar.dart';
import '../controller/person_provider.dart';

class PersonDetailScreen extends ConsumerStatefulWidget {
  static const routeName = 'person_detail';
  static const routePath = '/$routeName';

  const PersonDetailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends ConsumerState<PersonDetailScreen> {
  bool isShowingGroup = true;
  late TextEditingController nameController;
  late TextEditingController describeController;
  bool isNewPerson = true;

  @override
  void initState() {
    ref.read(personNotifierProvider.notifier).isLoadingImage = false;
    final currentPersonDetail = ref.read(personNotifierProvider.notifier).currentPersonDetail;
    if (currentPersonDetail.uid.isEmpty) {
      isNewPerson = true;
    } else {
      isNewPerson = false;
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
              const Spacer(),
              bottomButton(currentPersonDetail),
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
              "< Bạn bè",
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
              toastification.show(
                title: Text('Tính năng sẽ sớm ra mắt'),
                style: ToastificationStyle.fillColored,
                autoCloseDuration: const Duration(seconds: 3),
              );
            },
            child: Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 8, right: 16),
              decoration: BoxDecoration(
                color: ColorName.homeWhiteButtonBg,
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                boxShadow: [
                  BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
                ],
              ),
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
                PersonAvatar(
                  person: currentPersonDetail,
                  size: 160,
                  isEditable: true,
                ),
                (ref.read(personNotifierProvider.notifier).isLoadingImage) ? Container(
                  alignment: Alignment.center,
                  child: Transform.scale(
                    scale: 2,
                    child: const CircularProgressIndicator(
                        strokeWidth: 8,
                    ),
                  ),
                ) : const SizedBox()
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
          TextField(
            controller: describeController,
            keyboardType: TextInputType.multiline,
            textAlign: TextAlign.center,
            cursorColor: ColorName.homeBlackText,
            style: const TextStyle(
              color: ColorName.homeBlackText,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Gợi nhớ hoặc mô tả về người dùng này ",
              hintStyle: const TextStyle(
                color: ColorName.loginIconColorGray,
                fontSize: 20,
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
                title: Text('Tính năng sẽ sớm ra mắt'),
                style: ToastificationStyle.fillColored,
                autoCloseDuration: const Duration(seconds: 2),
              );
            },
            child: Container(
              height: 60,
              width: 120,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 16, bottom: 24, left: 16, right: 8),
              decoration: BoxDecoration(
                // color: ColorName.groupManagementBackGroundButton,
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                border: Border.all(),
                // boxShadow: [
                //   BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
                // ],
              ),
              child: Text(
                "Danh sách nhóm",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: ColorName.loginAvatarBackGround,
                  fontSize: 20,
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
                title: Text('Tính năng sẽ sớm ra mắt'),
                style: ToastificationStyle.fillColored,
                autoCloseDuration: const Duration(seconds: 2),
              );
            },
            child: Container(
              height: 60,
              width: 120,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 16, bottom: 24, left: 8, right: 16),
              decoration: BoxDecoration(
                color: ColorName.groupManagementBackGroundButton,
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                boxShadow: [
                  BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
                ],
              ),
              child: Text(
                "Lịch sử thu chi",
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
          ),
        ),
      ],
    );
  }

  Widget teamList() {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 16, bottom: 16),
        margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
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
                    "Tên nhóm",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ColorName.homeBlackText,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
            // SizedBox(height: 12),
            Container(
              // color: Colors.red,
              padding: EdgeInsets.only(bottom: 0),
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
            margin: EdgeInsets.only(bottom: 16),
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

  Widget historyTransaction() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
      margin: EdgeInsets.only(left: 16, right: 16),
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
                currentPersonDetail.uid,
                currentPersonDetail.toMap(),
              );
          context.pop();
          toastification.show(
            title: Text('Thành công sửa thông tin'),
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
