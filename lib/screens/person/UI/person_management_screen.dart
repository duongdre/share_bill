import 'package:go_router/go_router.dart';
import 'package:share_bill/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/models/data_models/person.dart';
import 'package:share_bill/screens/home/UI/home_screen.dart';
import 'package:share_bill/screens/person/UI/person_detail_screen.dart';
import 'package:share_bill/screens/spent/UI/spent_screen.dart';
import 'package:share_bill/utilities/utils/enum.dart';

import '../../../gen/colors.gen.dart';
import '../../../utilities/utils/person_avatar.dart';
import '../controller/person_provider.dart';

class PersonManagementScreen extends ConsumerStatefulWidget {
  static const routeName = 'person_management';
  static const routePath = '/$routeName';

  const PersonManagementScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PersonManagementScreenState();
}

class _PersonManagementScreenState extends ConsumerState<PersonManagementScreen> {
  bool isShowingGroup = true;

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(personNotifierProvider);
    final persons = ref.read(personNotifierProvider.notifier).allPerson;
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
                    itemCount: persons.length,
                    itemBuilder: (context, index) {
                      final person = persons[index];
                      return Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: friend(person),
                          ),
                        ],
                      );
                    }),
              ),
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
              context.goNamed(PersonDetailScreen.routeName);
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

  Widget friend(Person person) {
    return InkWell(
      onTap: () {
        ref.read(personNotifierProvider.notifier).currentPersonDetail = person.copyWith();
        context.goNamed(PersonDetailScreen.routeName);
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
        child: Container(
          padding: EdgeInsets.only(bottom: 0),
          child: Row(
            children: [
              Container(
                height: 80,
                width: 80,
                margin: EdgeInsets.only(top: 4, bottom: 8, left: 8, right: 8),
                child: PersonAvatar(
                  person: person,
                  size: 80,
                  isEditable: false,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person.name,
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
                    Text(
                      person.getPersonDescribe(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ColorName.homeGrayBalance,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  ref.read(personNotifierProvider.notifier).deletePerson(person.uid);
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                    color: ColorName.groupManagementBackground,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: ColorName.blackColor,
                    ),
                    boxShadow: [
                      BoxShadow(color: ColorName.homeBlackText, blurRadius: 1, offset: Offset(2, 2)),
                    ],
                  ),
                  child: Text(
                    "Xóa",
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
        ),
      ),
    );
  }
}
