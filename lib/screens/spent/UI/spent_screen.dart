import 'dart:ffi';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_bill/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/models/data_models/group.dart';
import 'package:share_bill/screens/group/controller/group_provider.dart';
import 'package:share_bill/screens/home/UI/home_screen.dart';
import 'package:share_bill/screens/person/controller/person_provider.dart';
import 'package:share_bill/utilities/utils/enum.dart';
import 'package:share_bill/utilities/utils/avatar_group.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

import '../../../gen/colors.gen.dart';
import '../../../models/data_models/bill.dart';
import '../../../utilities/utils/avatar_person.dart';
import '../../../utilities/utils/utils.dart';
import '../../../utilities/utils/widget_date_time_input_field.dart';
import '../../bill/UI/bill_management_screen.dart';
import '../../bill/controller/bill_provider.dart';

class SpentScreen extends ConsumerStatefulWidget {
  const SpentScreen({super.key});

  static const routeNameFromHome = '${HomeScreen.routePath}/spent';
  static const routePathFromHome = '/spent';

  static const routeNameFromBillManagement = '${BillManagementScreen.routePath}/spent';
  static const routePathFromBillManagement = '/spent';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SpentScreenState();
}

class _SpentScreenState extends ConsumerState<SpentScreen> {
  late TextEditingController amountController;
  int currentAmount = 0;
  final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'Đ', decimalDigits: 0);

  late TextEditingController descriptionController;
  late TextEditingController dateController;

  @override
  void initState() {
    amountController = TextEditingController(text: "");
    descriptionController = TextEditingController(text: "");
    dateController = TextEditingController(text: "");

    amountController.addListener(_updateText);

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void _updateText() {
    String text = amountController.text;
    if (text.isEmpty) {
      currentAmount = 0;
      return;
    }

    // Remove all non-digit characters
    text = text.replaceAll(RegExp(r'[^\d]'), '');

    // Convert to int directly (no need to divide by 100 for cents)
    currentAmount = int.parse(text);

    // Update the text with proper formatting
    final newText = currencyFormatter.format(currentAmount);

    // Avoid infinite loop by checking if the text is already formatted
    if (amountController.text != newText) {
      amountController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(billNotifierProvider);
    final group = ref.read(billNotifierProvider.notifier).currentSpentGroup;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: ColorName.spentBackGround,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(),
              Container(
                margin: EdgeInsets.only(left: 16, top: 24, bottom: 16),
                child: Text(
                  "Select Group",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ColorName.iconGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              selectGroup(ref.read(groupNotifierProvider.notifier).allGroup),
              (ref.read(billNotifierProvider.notifier).currentSpentGroup.uid != "")
                  ? Container(
                      margin: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                      child: Text(
                        "Who paid?",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: ColorName.iconGray,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : Container(),
              (ref.read(billNotifierProvider.notifier).currentSpentGroup.uid != "")
                  ? selectPerson(ref.read(billNotifierProvider.notifier).currentSpentGroup)
                  : Container(),
              Container(
                margin: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                child: Text(
                  "Amount",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ColorName.iconGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              amount(),
              Container(
                margin: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                child: Text(
                  "Desciption",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ColorName.iconGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              description(),
              Container(
                margin: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                child: Text(
                  "Desciption",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ColorName.iconGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              dateTime(),
              // Expanded(child: Center(child: amout())),
              // keyboard(),
              spentButton(),
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
          InkWell(
            onTap: () {
              context.pop();
            },
            child: Icon(
              Icons.arrow_back,
              size: 25,
              color: ColorName.iconGray,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 4.0,
                  color: ColorName.homeGrayBalance,
                ),
              ],
            ),
          ),
          Spacer(),
          Text(
            "New payment",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          InkWell(
            onTap: () {
              context.pop();
            },
            child: Icon(
              Icons.close,
              size: 25,
              color: ColorName.iconGray,
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

  Widget selectGroup(List<Group> allGroup) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Row(
            children: [
              Expanded(
                child: (ref.read(billNotifierProvider.notifier).currentSpentGroup.uid == "")
                    ? Text(
                        'Select a group',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: ColorName.textGray,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AvatarGroup(
                            group: ref.read(billNotifierProvider.notifier).currentSpentGroup,
                            size: 40,
                            isEditable: true,
                          ),
                          Text(
                            ref.read(billNotifierProvider.notifier).currentSpentGroup.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ColorName.textGray,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
              ),
            ],
          ),
          items: allGroup
              .map((Group group) => DropdownMenuItem<String>(
                    value: group.name,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AvatarGroup(
                          group: group,
                          size: 40,
                          isEditable: true,
                        ),
                        Text(
                          group.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: ColorName.textGray,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              final selectedGroup = ref.read(groupNotifierProvider.notifier).findGroupWithName(value);
              if (selectedGroup != null) {
                ref.read(billNotifierProvider.notifier).chooseGroup(selectedGroup);
              }
            }
          },
          buttonStyleData: ButtonStyleData(
            height: 50,
            padding: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ColorName.borderBlack, width: 1),
              color: ColorName.white,
            ),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down_outlined,
            ),
            iconSize: 25,
            iconEnabledColor: ColorName.borderBlack,
            iconDisabledColor: Colors.grey,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: ColorName.white,
            ),
            offset: const Offset(-0, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }

  Widget selectPerson(Group currentSpentGroup) {
    return Container(
      height: 88,
      padding: EdgeInsets.only(left: 16, right: 16),
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
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: (ref.read(billNotifierProvider.notifier).currentSpentPerson.uid == memberInGroup.uid)
                                ? const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(100)),
                                    boxShadow: [
                                      BoxShadow(color: ColorName.greenColor, blurRadius: 4, offset: Offset(4, 4)),
                                    ],
                                    color: ColorName.greenColor,
                                  )
                                : null,
                            child: AvatarPerson(
                              person: memberInGroup,
                              size: 60,
                              isEditable: false,
                            ),
                          ),
                        ),
                        Container(
                          width: 86,
                          margin: EdgeInsets.only(top: 72),
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
                  ],
                ),
              );
            } else {
              return null;
            }
          }),
    );
  }

  Widget amount() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: TextField(
        controller: amountController,
        keyboardType: const TextInputType.numberWithOptions(decimal: false),
        inputFormatters: [
          // FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorName.borderBlack,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorName.borderBlack,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorName.borderBlack,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          hintText: '0.00',
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: ColorName.textGray,
          ),
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: ColorName.textGray,
          ),
        ),
      ),
    );
  }

  Widget description() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: TextField(
        controller: descriptionController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorName.borderBlack,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorName.borderBlack,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorName.borderBlack,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          hintText: 'What was this payment for',
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: ColorName.textGray,
          ),
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: ColorName.textGray,
          ),
        ),
      ),
    );
  }

  Widget dateTime() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: DateTimeInputField(
        controller: dateController,
        onDateTimeSelected: (date) {
          print('Selected date: $date');
        },
      ),
    );
  }

  // amount
  Widget amout() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 16),
      child: TextField(
        controller: amountController,
        textAlign: TextAlign.center,
        cursorColor: ColorName.homeBlackText,
        style: const TextStyle(
          color: ColorName.homeBlackText,
          fontSize: 54,
          fontWeight: FontWeight.w500,
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
          enabled: false,
          hintText: 'Nhập số tiền',
          hintStyle: TextStyle(
            color: ColorName.loginIconColorGray,
            fontSize: 54,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
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

  // keyboard
  Widget keyboard() {
    final numpadData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "000", "0", "x"];

    return Container(
      height: 308,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 16),
      decoration: const BoxDecoration(
        color: ColorName.homeWhiteButtonBg,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
        ],
      ),
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
      child: Column(
        children: [
          for (int item1 in [0, 1, 2, 3])
            Row(
              children: [
                for (int item2 in [1, 2, 3])
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        print(numpadData[item2 + item1 * 3 - 1]);
                        final number = numpadData[item2 + item1 * 3 - 1];
                        if (number == "000") {
                          currentAmount = currentAmount * 1000;
                        } else if (isNumeric(number)) {
                          currentAmount = currentAmount * 10 + int.parse(number);
                        } else {
                          currentAmount = currentAmount ~/ 10;
                        }
                        amountController.text = NumberFormat.currency(locale: "vi_VN", symbol: "Đ").format(currentAmount);
                      },
                      child: Container(
                        height: 60,
                        margin: const EdgeInsets.all(4),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: ColorName.spentBackGroundButton,
                          borderRadius: const BorderRadius.all(Radius.circular(100)),
                          boxShadow: [
                            BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
                          ],
                        ),
                        child: Text(
                          numpadData[item2 + item1 * 3 - 1],
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
                    ),
                  )
              ],
            )
        ],
      ),
    );
  }

  // spent button
  Widget spentButton() {
    return InkWell(
      onTap: () async {
        ref.read(billNotifierProvider.notifier).changeAmount(currentAmount);

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
                    description: descriptionController.text,
                    createdAt: formatDateStringMillisecondsSinceEpoch(dateController.text)),
              );
          toastification.show(
            title: Text('Thành công thêm khoản chi tiêu'),
            style: ToastificationStyle.fillColored,
            autoCloseDuration: const Duration(seconds: 3),
          );
          context.pop();
        }
      },
      child: Container(
        height: 60,
        // width: 120,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
        decoration: BoxDecoration(
          color: ColorName.groupManagementBackGroundButton,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          boxShadow: [
            BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
          ],
        ),
        child: Text(
          "Spent money",
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
