import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import 'cust_button.dart';
import 'cust_text.dart';
import 'cust_textfield.dart';

class CustomUpdateDialog extends StatefulWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Function(String remark) onConfirm;
  final VoidCallback? onCancel;

  const CustomUpdateDialog({
    Key? key,
    this.title = 'Are You Sure?',
    this.message = 'Do you want to Update.',
    this.confirmText = 'Update',
    this.cancelText = 'No',
    required this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  static Future<void> show({
    String title = 'Are You Sure?',
    String message = 'Do you want to Update.',
    String confirmText = 'Update',
    String cancelText = 'No',
    required Function(String) onConfirm,
    VoidCallback? onCancel,
  }) async {
    await Get.dialog(
      CustomUpdateDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
      barrierDismissible: false,
    );
  }

  @override
  State<CustomUpdateDialog> createState() => _CustomUpdateDialogState();
}

class _CustomUpdateDialogState extends State<CustomUpdateDialog> {
  final TextEditingController _remarkController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustText(
                name: widget.title,
                size: 2.2,
                fontWeightName: FontWeight.bold,
                color: AppColors.black,
              ),
              const SizedBox(height: 4),
              CustText(
                name: widget.message,
                size: 1.6,
                color: AppColors.textColor4,
              ),
              const SizedBox(height: 16),
              const CustText(
                name: 'Update Remark * (0 - 1000)',
                size: 1.6,
                fontWeightName: FontWeight.bold,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _remarkController,
                hintText: 'Description',
                maxLines: 4,
                maxLength: 1000,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter an update remark';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                        if (widget.onCancel != null) widget.onCancel!();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.black),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: CustText(
                        name: widget.cancelText,
                        size: 1.6,
                        color: AppColors.black,
                        fontWeightName: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustButton(
                      name: widget.confirmText,
                      onSelected: (_) {
                        if (_formKey.currentState?.validate() ?? false) {
                          Get.back();
                          widget.onConfirm(_remarkController.text.trim());
                        }
                      },
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
      ),
    );
  }
}
