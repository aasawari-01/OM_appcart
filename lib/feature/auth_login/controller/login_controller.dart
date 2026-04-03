import 'package:get/get.dart';
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
    // Validation is now handled in the View via Form and validators.

    try {
      isLoading.value = true;

      // Get FCM token from NotificationService
      print("Fetching FCM token...");
      final String? fcmToken = await Get.find<NotificationService>().getFcmToken();
      print("fcmToken==+$fcmToken");
      
      print("Calling login API...");
      final LoginResponse result =
          await _authService.login(email: email, password: password, deviceToken: fcmToken);

      if (result.status && result.data != null) {
        // Persist tokens/user info using AuthManager
        await AuthManager().login(
          userId: result.data!.id?.toString() ?? '',
          token: result.data!.accessToken ?? '',
          roleId: result.data!.role?.id,
        );

        // Refresh profile data for the new user
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
}

