import 'package:get/get.dart';
import '../model/forgot_password_response.dart';
import '../service/auth_service.dart';
import '../model/login_response.dart';
import '../../../view/screens/tab_screen.dart';
import '../../../service/auth_manager.dart';
import '../../../service/notification_service.dart';
import '../../user_profile/controller/user_profile_controller.dart';
import '../../../view/widgets/custom_snackbar.dart';

class LoginController extends GetxController {
  LoginController({AuthService? authService})
      : _authService = authService ?? AuthService();

  final AuthService _authService;

  final RxBool isLoading = false.obs;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      print("Fetching FCM token...");
      final String? fcmToken = await Get.find<NotificationService>().getFcmToken();
      print("fcmToken==+$fcmToken");
      final LoginResponse result =
          await _authService.login(email: email, password: password, deviceToken: fcmToken);

      if (result.status && result.data != null) {
        await AuthManager().login(
          userId: result.data!.id?.toString() ?? '',
          token: result.data!.accessToken ?? '',
          roleId: result.data!.role?.id,
        );
        if (Get.isRegistered<UserProfileController>()) {
          final userProfileController = Get.find<UserProfileController>();
          userProfileController.fetchProfileData();
          userProfileController.fetchMasterData();
        }
        Get.offAll(() => TabScreen(index: 0));
      } else {
        CustomSnackBar.show(
          title: 'Login failed',
          message: result.message ?? 'Invalid credentials',
        );
      }
    } catch (e) {
      print("Login error: $e");
      String errorMessage = e.toString();
      if (errorMessage.contains("TimeoutException")) {
        errorMessage = "Time out error";
      }
      
      CustomSnackBar.show(
        title: 'Login failed',
        message: errorMessage,
      );
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> forgotPassword({
    required String email,
  }) async {
    try {
      isLoading.value = true;

      final ForgotPasswordResponse result =
      await _authService.forgotPassword(email: email);

      if (result.status == true) {

        Get.back();

        Future.delayed(const Duration(milliseconds: 100), () {
          CustomSnackBar.show(
            title: 'Success',
            message: result.message ?? 'Reset password email sent',
            isError: false
          );
        });
      } else {
        Get.back();

        Future.delayed(const Duration(milliseconds: 100), () {
          CustomSnackBar.show(
            title: 'Success',
            message: result.message ?? 'Reset password email sent',
          );
        });
      }
    } catch (e) {
      print("Forgot password error: $e");

      String errorMessage = e.toString();

      if (errorMessage.contains("TimeoutException")) {
        errorMessage = "Time out error";
      }

      CustomSnackBar.show(
        title: 'Forgot Password Failed',
        message: errorMessage,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

