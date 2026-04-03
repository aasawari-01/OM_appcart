import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import '../../utils/responsive_helper.dart';
import 'cust_text.dart';

class CustomSnackBar {
  static void show({
    required String title,
    required String message,
    bool isError = true,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      '',
      '',
      titleText: CustText(
        name: title,
        size: 1.8,
        fontWeightName: FontWeight.bold,
        color: AppColors.white1,
      ),
      messageText: CustText(
        name: message,
        size: 1.6,
        color: AppColors.white1,
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? AppColors.red.withOpacity(0.9) : AppColors.green.withOpacity(0.9),
      colorText: AppColors.white1,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: AppColors.white1,
        size: 28,
      ),
      shouldIconPulse: true,
      duration: duration,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    );
  }
}
