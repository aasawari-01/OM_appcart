import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:om_appcart/utils/responsive_helper.dart';
import 'package:om_appcart/feature/auth_login/controller/login_controller.dart';
import 'package:om_appcart/utils/validator.dart';

import '../../../constants/colors.dart';
import '../../../constants/strings.dart';
import '../../../constants/app_constants.dart';
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: (isKeyboardVisible || _hasValidationError)
                ? const ClampingScrollPhysics()
                : const ClampingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.45,
                      width: double.infinity,
                      child: Image.asset(
                        "assets/images/metro.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Login Card
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.white1,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(ResponsiveHelper.spacing(context, 30)),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustText(
                                  name: AppStrings.welcomeToOM,
                                  size: 2.4,
                                  fontWeightName: FontWeight.bold,
                                ),
                                SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.cardInnerSpacing)),
                                CustText(
                                  name: AppStrings.loginSubtitle,
                                  size: 1.8,
                                ),
                                SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
                                CustomTextField(
                                  label: AppStrings.email,
                                  controller: userNameController,
                                  hintText: AppStrings.enterEmail,
                                  validator: Validator.validateEmail,
                                  onChanged: (_) {
                                    if (_hasValidationError) {
                                      setState(() => _hasValidationError = false);
                                    }
                                  },
                                ),
                                SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
                                CustomTextField(
                                  label: AppStrings.password,
                                  controller: passwordController,
                                  hintText: AppStrings.enterPassword,
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
                                SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () => Get.to(() => ForgotPasswordView()),
                                    child: CustText(
                                      name: AppStrings.forgotPassword,
                                      size: AppConstants.formLabelSize,
                                      color: AppColors.blue,
                                    ),
                                  ),
                                ),
                                SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.sectionSpacing)),
                                Obx(
                                  () => CustButton(
                                    name: AppStrings.login,
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
                                SizedBox(height: ResponsiveHelper.spacing(context, 40)),
                                Center(
                                  child: CustText(
                                    name: AppStrings.copyright,
                                    size: AppConstants.bodySize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}