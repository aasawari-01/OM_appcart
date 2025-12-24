import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/utils/size_config.dart';

import 'view/screens/login_view.dart';
import 'view/screens/onboarding_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'O & M Dashboard',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white1
      ),
      home: LayoutBuilder(
        builder: (context, constraints) {
          return OrientationBuilder(
            builder: (context, orientation) {
              SizeConfig().init(constraints, orientation);
              return  OnboardingScreen();
            },
          );
        }
      ),
    );
  }
}