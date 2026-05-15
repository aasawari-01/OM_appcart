import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../../view/widgets/cust_textfield.dart';
import '../../../view/widgets/custom_app_bar.dart';

import '../controller/setting_controller.dart';


class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingController());

    return ValueListenableBuilder(
      valueListenable: ThemeManager.primaryColorNotifier,
      builder: (context, primaryColor, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: 'Change Password',
            showDrawer: false,
            onLeadingPressed: () => Navigator.pop(context),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // ── Section heading ──────────────────────────────
                        const Text(
                          'Change Account Password',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Set a new account password to login in to application.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9E9E9E),
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Current Password ─────────────────────────────
                        const _FieldLabel(text: 'Current Password'),
                        const SizedBox(height: 8),
                        Obx(() => CustomTextField(
                          controller: controller.currentPasswordController,
                          hintText: 'Enter Current Password',
                          obscureText: !controller.showCurrent.value,
                          textInputAction: TextInputAction.next,
                          validator: controller.validateCurrentPassword,
                          suffixIcon: _EyeToggle(
                            visible: controller.showCurrent.value,
                            onTap: controller.toggleCurrent,
                          ),
                        )),

                        const SizedBox(height: 20),

                        // ── New Password ─────────────────────────────────
                        const _FieldLabel(text: 'New Password'),
                        const SizedBox(height: 8),
                        Obx(() => CustomTextField(
                          controller: controller.newPasswordController,
                          hintText: 'Enter New Password',
                          obscureText: !controller.showNew.value,
                          textInputAction: TextInputAction.next,
                          validator: controller.validateNewPassword,
                          suffixIcon: _EyeToggle(
                            visible: controller.showNew.value,
                            onTap: controller.toggleNew,
                          ),
                        )),

                        const SizedBox(height: 20),

                        // ── Confirm New Password ─────────────────────────
                        const _FieldLabel(text: 'Confirm New Password'),
                        const SizedBox(height: 8),
                        Obx(() => CustomTextField(
                          controller: controller.confirmPasswordController,
                          hintText: 'Confirm New Password',
                          obscureText: !controller.showConfirm.value,
                          textInputAction: TextInputAction.done,
                          validator: controller.validateConfirmPassword,
                          onSubmitted: (_) => controller.onSave(),
                          suffixIcon: _EyeToggle(
                            visible: controller.showConfirm.value,
                            onTap: controller.toggleConfirm,
                          ),
                        )),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Save button ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                child: Obx(() => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      'Save Password',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small reusable field label
// ─────────────────────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textColor,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Eye toggle icon for password fields
// ─────────────────────────────────────────────────────────────────────────────
class _EyeToggle extends StatelessWidget {
  final bool visible;
  final VoidCallback onTap;

  const _EyeToggle({required this.visible, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        visible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        size: 20,
        color: AppColors.iconColor,
      ),
    );
  }
}