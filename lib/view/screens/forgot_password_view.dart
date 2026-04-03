import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:om_appcart/constants/colors.dart';

import '../widgets/cust_button.dart';
import '../widgets/cust_text.dart';
import '../widgets/cust_textfield.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          physics: isKeyboardVisible 
              ? const ClampingScrollPhysics() 
              : const NeverScrollableScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            height: screenHeight,
            child: Stack(
        children: [
          SizedBox(height: screenHeight, width: screenWidth),
          SizedBox(
            height: screenHeight * 0.6,
            width: double.infinity,
            child: Image.asset(
              "assets/images/metro.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: screenHeight * 0.57 - 40,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: AppColors.white1,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustText(
                        name: "Forgot Password",
                        size: 2.2,
                        color: AppColors.textColor5,
                        fontWeightName: FontWeight.bold,
                      ),
                      const SizedBox(height: 6),
                      CustText(
                        name: "We'll send a reset link to your email",
                        size: 1.4,
                        color: AppColors.textColor,
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        label: "Email",
                        controller: emailController,
                        hintText: "Enter your email",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please Enter Email";
                          }
                          if (!GetUtils.isEmail(value.trim())) {
                            return "Please Enter Valid Email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      CustButton(
                        name: "Send Reset Link",
                        size: double.infinity,
                        onSelected: (bool val) {
                          if (_formKey.currentState?.validate() ?? false) {

                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: CustText(
                            name: "← Back to Login",
                            size: 1.4,
                            color: AppColors.textColor,
                          ),
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
    ),
    );
  }
}
 