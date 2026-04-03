import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:om_appcart/utils/responsive_helper.dart';
import 'package:om_appcart/feature/auth_login/controller/login_controller.dart';
import 'package:om_appcart/utils/validator.dart';

import '../../../constants/colors.dart';
import '../../../view/screens/tab_screen.dart';
import '../../../view/widgets/cust_button.dart';
import '../../../view/widgets/cust_text.dart';
import '../../../view/widgets/cust_textfield.dart';
import '../../../view/screens/forgot_password_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _hasValidationError = false;
  bool _isPasswordVisible = false;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    userNameController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    final bool isEnabled = userNameController.text.isNotEmpty && passwordController.text.isNotEmpty;
    if (isEnabled != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = isEnabled;
      });
    }
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: (isKeyboardVisible || _hasValidationError)
            ? const ClampingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            // Top Image
            SizedBox(
              height: screenHeight * 0.45,
              width: double.infinity,
              child: Image.asset(
                "assets/images/metro.png",
                fit: BoxFit.cover,
              ),
            ),

            // Login Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white1,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustText(
                        name: "Welcome to O&M",
                        size: 2.4,
                        fontWeightName: FontWeight.bold,
                      ),
                      const SizedBox(height: 10),
                      CustText(
                        name: "Enter username & password to log into MetroOps account",
                        size: 1.8,
                      ),
                      const SizedBox(height: 20),
                      CustText(name: "Email", size: 1.6),
                      CustomTextField(
                        controller: userNameController,
                        hintText: "Enter Email",
                        validator: Validator.validateEmail,
                        onChanged: (_) {
                          if (_hasValidationError) {
                            setState(() => _hasValidationError = false);
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      CustText(name: "Password", size: 1.6),
                      CustomTextField(
                        controller: passwordController,
                        hintText: "Enter Password",
                        obscureText: !_isPasswordVisible,
                        validator: Validator.validatePassword,
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          child: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: AppColors.grey,
                          ),
                        ),
                        onChanged: (_) {
                          if (_hasValidationError) {
                            setState(() => _hasValidationError = false);
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () => Get.to(() => ForgotPasswordView()),
                          child: CustText(
                            name: "Forgot password?",
                            size: 1.6,
                            color: AppColors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Obx(
                        () => CustButton(
                          name: "Log In",
                          size: double.infinity,
                          isEnabled: _isButtonEnabled && !loginController.isLoading.value,
                          isLoading: loginController.isLoading.value,
                          onSelected: (_) {
                            if (loginController.isLoading.value) return;
                            if (_formKey.currentState!.validate()) {
                              setState(() => _hasValidationError = false);
                              loginController.login(
                                email: userNameController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: CustText(
                          name: "© ${DateTime.now().year}, All rights reserved",
                          size: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}