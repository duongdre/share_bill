import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/models/data_models/group.dart';
import 'package:share_bill/screens/group/controller/group_provider.dart';
import 'package:share_bill/screens/home/UI/home_screen.dart';
import 'package:share_bill/screens/person/controller/person_provider.dart';
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
import 'package:share_bill/gen/l10n/app_localizations.dart';

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
  final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);

  late TextEditingController descriptionController;
  late TextEditingController dateController;

  // Track keyboard visibility
  bool isKeyboardVisible = false;

  @override
  void initState() {
    amountController = TextEditingController(text: "");
    descriptionController = TextEditingController(text: "");
    dateController = TextEditingController(text: "");
    amountController.addListener(_updateText);
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
    final localizations = AppLocalizations.of(context);
    ref.watch(billNotifierProvider);

    // Listen for keyboard visibility changes
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    isKeyboardVisible = bottomInset > 0;

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent resizing when keyboard appears
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: const BoxDecoration(
            color: ColorName.spentBackGround,
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    header(localizations),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 16, top: 24, bottom: 16),
                              child: Text(
                                localizations.selectGroup,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: ColorName.iconGray,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            selectGroup(ref.read(groupNotifierProvider.notifier).allGroup, localizations),
                            (ref.read(billNotifierProvider.notifier).currentSpentGroup.uid != "")
                                ? Container(
                                    margin: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                                    child: Text(
                                      localizations.whoPaid,
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
                              margin: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                              child: Text(
                                localizations.amount,
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
                              margin: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                              child: Text(
                                localizations.description,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: ColorName.iconGray,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            description(localizations),
                            Container(
                              margin: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                              child: Text(
                                localizations.date,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: ColorName.iconGray,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            dateTime(),
                            // Add padding at bottom to ensure scrolling can reveal all content
                            // when the button is visible
                            SizedBox(height: isKeyboardVisible ? 20 : 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Position the button at the bottom
                if (!isKeyboardVisible) // Only show button when keyboard is not visible
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: spentButton(localizations),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget header(AppLocalizations localizations) {
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
          const Spacer(),
          Text(
            localizations.newExpense,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              context.pop();
            },
            child: const Icon(
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

  Widget selectGroup(List<Group> allGroup, AppLocalizations localizations) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Row(
            children: [
              Expanded(
                child: (ref.read(billNotifierProvider.notifier).currentSpentGroup.uid == "")
                    ? Text(
                        localizations.selectGroup,
                        style: const TextStyle(
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
      padding: const EdgeInsets.only(left: 16, right: 16),
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
                          padding: const EdgeInsets.only(left: 10, right: 10),
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
                          margin: const EdgeInsets.only(top: 72),
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
              return Container();
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
        inputFormatters: const [
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

  Widget description(AppLocalizations localizations) {
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
          hintText: localizations.description,
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
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: DateTimeInputField(
        controller: dateController,
        onDateTimeSelected: (date) {
          print('Selected date: $date');
        },
      ),
    );
  }

  // spent button
  Widget spentButton(AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        color: ColorName.spentBackGround,
        // Add a subtle shadow at top to separate it from content
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () async {
          ref.read(billNotifierProvider.notifier).changeAmount(currentAmount);

          final billGroup = ref.read(billNotifierProvider.notifier).currentSpentGroup.uid;
          final billPerson = ref.read(billNotifierProvider.notifier).currentSpentPerson.uid;
          final billAmount = ref.read(billNotifierProvider.notifier).currentAmount;
          if (billGroup.isEmpty || billPerson.isEmpty || billAmount == 0) {
            toastification.show(
              title: Text(localizations.pleaseFillInAllFields),
              style: ToastificationStyle.fillColored,
              autoCloseDuration: const Duration(seconds: 3),
            );
          } else {
            await ref.read(billNotifierProvider.notifier).addNewBill(
                  Bill(
                      uid: const Uuid().v4(),
                      groupId: billGroup,
                      personId: billPerson,
                      amount: billAmount,
                      description: descriptionController.text,
                      createdAt: formatDateStringMillisecondsSinceEpoch(dateController.text)),
                );
            toastification.show(
              title: Text(localizations.successfullyAddedExpense),
              style: ToastificationStyle.fillColored,
              autoCloseDuration: const Duration(seconds: 3),
            );
            context.pop();
          }
        },
        child: Container(
          height: 60,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 16),
          decoration: const BoxDecoration(
            color: ColorName.groupManagementBackGroundButton,
            borderRadius: BorderRadius.all(Radius.circular(100)),
            boxShadow: [
              BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
            ],
          ),
          child: Text(
            localizations.spentMoney,
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
    );
  }
}
