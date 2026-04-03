import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:om_appcart/constants/colors.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'feature/auth_login/view/login_view.dart';
import 'view/screens/onboarding_view.dart';
import 'service/auth_manager.dart';
import 'view/screens/tab_screen.dart';
import 'service/quick_actions_overlay.dart';
import 'feature/lost&found/view/finalize_found_lost_items_screen.dart';
import 'controller/station_controller.dart';
import 'view/screens/notification_screen.dart';
import 'service/notification_service.dart';
import 'feature/user_profile/controller/user_profile_controller.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  await Firebase.initializeApp();
  
  await Get.putAsync(() => NotificationService().init());
  
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Get.put(StationController(), permanent: true);
  Get.put(UserProfileController(), permanent: true);
  final bool isLoggedIn = await AuthManager().isLoggedIn();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'O & M Dashboard',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bgColor,
      ),
      builder: (context, child) {
        return Stack(
          children: [
            child ?? const SizedBox.shrink(),
          ],
        );
      },
      getPages: [
        GetPage(name: '/notifications', page: () => const NotificationScreen()),
      ],
      home: isLoggedIn ? TabScreen(index: 0) : const OnboardingScreen(),
    );
  }
}