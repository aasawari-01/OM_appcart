import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../service/auth_manager.dart';
import '../../../view/widgets/custom_snackbar.dart';
import '../service/setting_service.dart';

class SettingController extends GetxController {

  SettingController({SettingService? authService})
      : _settingService = authService ?? SettingService();

  final SettingService _settingService;
  // ── Form ──────────────────────────────────────────────────────────────────
  final formKey = GlobalKey<FormState>();

  // ── Controllers ───────────────────────────────────────────────────────────
  final currentPasswordController  = TextEditingController();
  final newPasswordController      = TextEditingController();
  final confirmPasswordController  = TextEditingController();

  // ── Visibility toggles ────────────────────────────────────────────────────
  final showCurrent = false.obs;
  final showNew     = false.obs;
  final showConfirm = false.obs;

  void toggleCurrent() => showCurrent.value = !showCurrent.value;
  void toggleNew()     => showNew.value     = !showNew.value;
  void toggleConfirm() => showConfirm.value = !showConfirm.value;

  // ── Loading state ─────────────────────────────────────────────────────────
  final isLoading = false.obs;

  // ── Validators ────────────────────────────────────────────────────────────
  String? validateCurrentPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your current password';
    }
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a new password';
    }
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Must contain at least one uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Must contain at least one number';
    }
    if (value == currentPasswordController.text) {
      return 'New password must differ from current password';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your new password';
    }
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // ── Save ──────────────────────────────────────────────────────────────────
  Future<void> onSave() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      await changePassword(
        currentPassword: currentPasswordController.text.trim(),
        newPassword:     newPasswordController.text.trim(),
      );

      Get.back();
      Get.snackbar(
        'Success',
        'Password changed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0E7D1F),
        colorText: const Color(0xFFFFFFFF),
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFDD3737),
        colorText: const Color(0xFFFFFFFF),
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final String? userIdStr = await AuthManager().getUserId();

      if (userIdStr == null) {
        return;
      }
      int userId = int.parse(userIdStr);

      await _settingService.changePassword(
        userId: userId,
        oldPassword: currentPassword,
        newPassword: newPassword,
      );

      // Clear fields after success
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      Get.back();

      CustomSnackBar.show(
        title: 'Success',
        message: 'Password changed successfully',
      );
    } catch (e) {
      print("Change password error: $e");
      String errorMessage = e.toString();
      if (errorMessage.contains("TimeoutException")) {
        errorMessage = "Time out error";
      }

      CustomSnackBar.show(
        title: 'Failed',
        message: errorMessage,
      );
    } finally {
      isLoading.value = false;
    }
  }
  // ── Cleanup ───────────────────────────────────────────────────────────────
  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}