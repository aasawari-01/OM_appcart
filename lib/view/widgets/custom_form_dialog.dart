import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import 'cust_button.dart';
import 'cust_text.dart';

class CustomFormDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final String saveButtonText;
  final VoidCallback onSave;
  final VoidCallback? onCancel;

  const CustomFormDialog({
    Key? key,
    required this.title,
    required this.child,
    this.saveButtonText = 'Save',
    required this.onSave,
    this.onCancel,
  }) : super(key: key);

  static void show({
    required String title,
    required Widget child,
    String saveButtonText = 'Save',
    required VoidCallback onSave,
    VoidCallback? onCancel,
  }) {
    Get.bottomSheet(
      CustomFormDialog(
        title: title,
        child: child,
        saveButtonText: saveButtonText,
        onSave: onSave,
        onCancel: onCancel,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustText(
                  name: title,
                  size: 2.0,
                  fontWeightName: FontWeight.bold,
                  color: AppColors.black,
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            child,
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                      if (onCancel != null) onCancel!();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.black),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const CustText(
                      name: 'Cancel',
                      size: 1.6,
                      color: AppColors.black,
                      fontWeightName: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustButton(
                    name: saveButtonText,
                    onSelected: (_) => onSave(),
                    color1: AppColors.blue,
                    color2: AppColors.blue,
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
}
