import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import '../../utils/responsive_helper.dart';
import 'cust_button.dart';
import 'cust_text.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final IconData? icon;

  const CustomConfirmationDialog({
    Key? key,
    required this.title,
    required this.message,
    this.confirmText = 'Yes',
    this.cancelText = 'No',
    required this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (confirmColor ?? AppColors.blue).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: confirmColor ?? AppColors.blue,
                ),
              ),
              const SizedBox(height: 8),
            ],
            CustText(
              name: title,
              size: 2.0,
              fontWeightName: FontWeight.bold,
              color: AppColors.textColor,
            ),
            // const SizedBox(height: 4),
            CustText(
              name: message,
              size: 1.6,
              color: AppColors.textColor.withOpacity(0.7),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                      if (onCancel != null) onCancel!();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.grey.withOpacity(0.3)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: CustText(
                      name: cancelText,
                      size: 1.6,
                      color: AppColors.textColor.withOpacity(0.7),
                      fontWeightName: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustButton(
                    name: confirmText,
                    onSelected: (_) {
                      Get.back();
                      onConfirm();
                    },
                    color1: confirmColor ?? AppColors.blue,
                    color2: confirmColor ?? AppColors.blue,
                    sHeight: 45,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> show({
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'No',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
    IconData? icon,
  }) async {
    await Get.dialog(
      CustomConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmColor: confirmColor,
        icon: icon,
      ),
      barrierDismissible: false,
    );
  }
}
