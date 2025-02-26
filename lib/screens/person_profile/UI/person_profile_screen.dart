import 'package:go_router/go_router.dart';
import 'package:share_bill/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/screens/home/UI/home_screen.dart';
import 'package:share_bill/screens/spent/UI/spent_screen.dart';

import '../../../gen/colors.gen.dart';

class PersonProfileScreen extends ConsumerStatefulWidget {
  const PersonProfileScreen({super.key});

  static const routeName = 'person_profile';
  static const routePath = '/$routeName';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PersonProfileScreenState();
}

class _PersonProfileScreenState extends ConsumerState<PersonProfileScreen> {
  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      avatar(),
                    ],
                  ),
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
          Text(
            "Profile",
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
          const Spacer(),
          InkWell(
            onTap: () {},
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

  Widget avatar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: ColorName.homeRedText,
              image: DecorationImage(
                image: Assets.images.avtMale.provider(),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              boxShadow: [
                BoxShadow(color: ColorName.homeGrayBalance, blurRadius: 4, offset: Offset(4, 4)),
              ],
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Name",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: ColorName.homeBlackText,
              fontSize: 32,
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
            "Gợi nhớ hoặc mô tả về người dùng này",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: ColorName.loginIconColorGray,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 3,
          )
        ],
      ),
    );
  }
}
