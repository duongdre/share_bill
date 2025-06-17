import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/utilities/utils/widget_list_bill.dart';
import 'package:toastification/toastification.dart';
import '../../../gen/colors.gen.dart';
import '../../../models/data_models/bill.dart';
import '../../../models/data_models/group.dart';
import '../../../models/data_models/person.dart';
import '../../../utilities/utils/avatar_person.dart';
import '../../../utilities/utils/widget_list_group.dart';
import '../../bill/controller/bill_provider.dart';
import '../../group/UI/group_detail_screen.dart';
import '../../group/controller/group_provider.dart';
import '../controller/person_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonDetailScreen extends ConsumerStatefulWidget {
  static const routeName = 'person_detail';
  static const routePath = '/$routeName';

  const PersonDetailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends ConsumerState<PersonDetailScreen> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController describeController;
  late List<Bill> allBillOfPerson;
  late List<Group> allGroupOfPerson;
  bool isNewPerson = true;

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
    ageController = TextEditingController(text: "");
    describeController = TextEditingController(text: currentPersonDetail.describe.toString() ?? "");
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    describeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
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
              header(localizations),
              info(currentPersonDetail, localizations),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 16, top: 24, bottom: 16),
                        child: Text(
                          localizations.groups,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: ColorName.homeBlackText,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      groups(),
                      Container(
                        margin: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                        child: Text(
                          localizations.recentGroups,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: ColorName.homeBlackText,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      recentExpenses(),
                    ],
                  ),
                ),
              ),
            ],
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
            ),
          ),
          const Spacer(),
          Text(
            localizations.personDetails,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              toastification.show(
                title: Text(localizations.featureComingSoon),
                style: ToastificationStyle.fillColored,
                autoCloseDuration: const Duration(seconds: 3),
              );
            },
            child: const Icon(
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

  Widget info(Person currentPersonDetail, AppLocalizations localizations) {
    return Container(
      height: 136,
      margin: const EdgeInsets.only(top: 1),
      padding: const EdgeInsets.all(16),
      color: ColorName.white,
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              boxShadow: [
                BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
              ],
            ),
            child: Stack(
              children: [
                AvatarPerson(
                  person: currentPersonDetail,
                  size: 80,
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                SizedBox(
                  height: 28,
                  child: TextField(
                    controller: nameController,
                    textAlign: TextAlign.start,
                    cursorColor: ColorName.homeBlackText,
                    style: const TextStyle(
                      color: ColorName.homeBlackText,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 4.0,
                          color: ColorName.homeGrayBalance,
                        ),
                      ],
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: localizations.enterPersonName,
                        hintStyle: const TextStyle(
                          color: ColorName.loginIconColorGray,
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 4.0,
                              color: ColorName.homeGrayBalance,
                            ),
                          ],
                        )),
                  ),
                ),
                SizedBox(
                  height: 23,
                  child: TextField(
                    controller: ageController,
                    textAlign: TextAlign.start,
                    cursorColor: ColorName.textGray,
                    style: const TextStyle(
                      color: ColorName.textGray,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: localizations.enterPersonName,
                        hintStyle: const TextStyle(
                          color: ColorName.loginIconColorGray,
                          fontSize: 16,
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
                ),
                SizedBox(
                  height: 24,
                  child: TextField(
                    controller: describeController,
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.start,
                    cursorColor: ColorName.homeBlackText,
                    style: const TextStyle(
                      color: ColorName.homeBlackText,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: -26.0),
                      border: InputBorder.none,
                      hintText: localizations.descriptionOptional,
                      hintStyle: const TextStyle(
                        color: ColorName.loginIconColorGray,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      hintMaxLines: 2,
                    ),
                    minLines: 1,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget groups() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListGroup(
          groups: allGroupOfPerson,
          scrollable: true,
          onGroupTap: (group) {
            ref.read(groupNotifierProvider.notifier).currentGroupDetail = group.copyWith();
            context.goNamed(GroupDetailScreen.routeName);
          },
        ),
      ],
    );
  }

  Widget recentExpenses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListBill(
          bills: allBillOfPerson,
          scrollable: true,
          onBillTap: (bill) {
            ///TODO: Bill click
          },
        ),
      ],
    );
  }
}
