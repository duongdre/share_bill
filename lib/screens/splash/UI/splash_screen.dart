import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../gen/assets.gen.dart';
import '../../home/UI/home_screen.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  static const routeName = '/';
  static const routePath = routeName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    Timer(const Duration(seconds: 1), () {
      context.goNamed(HomeScreen.routeName);
    });

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black,
        child: Image(
          image: Assets.images.splashAcb.provider(),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}