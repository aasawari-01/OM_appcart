import 'package:flutter/material.dart';
import 'package:om_appcart/utils/size_config.dart';
import 'package:om_appcart/view/screens/tab_screen.dart';
import '../../constants/colors.dart';
import '../widgets/cust_button.dart';
import '../widgets/cust_text.dart';
import '../widgets/cust_textfield.dart';
import 'forgot_password_view.dart';

class LoginView extends StatelessWidget {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          physics: isKeyboardOpen
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight,
            ),
            child: Stack(
              children: [
                SizedBox(height:screenHeight ,
                width: screenWidth,),
                SizedBox(
                  // height: screenHeight * 0.6,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/images/metro.png",
                     fit: BoxFit.cover,
                  ),
                ),
                // Bottom: Login form, overlapping the image
                Positioned(
                  top: screenHeight * 0.3,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white1,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        "assets/images/background3.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8 * SizeConfig.heightMultiplier),
                              CustText(
                                name: "Hello There!",
                                size: 2.4,
                                color: AppColors.textColor5,
                                fontWeightName: FontWeight.bold,
                              ),
                              SizedBox(height: 0.5 * SizeConfig.heightMultiplier),
                              CustText(
                                name: "Enter username & password to log into MetroOps account",
                                size: 1.8,
                                color: AppColors.textColor,
                              ),
                              SizedBox(height: 1.5 * SizeConfig.heightMultiplier),
                              CustText(
                                name: "Email",
                                size: 1.6,
                                color: AppColors.textColor,
                                fontWeightName: FontWeight.w500,
                              ),
                              SizedBox(height: 0.5 * SizeConfig.heightMultiplier),
                              CustomTextField(
                                controller: userNameController,
                                hintText: "Enter Email",
                              ),
                              SizedBox(height: 1.5 * SizeConfig.heightMultiplier),
                              CustText(
                                name: "Password",
                                size: 1.6,
                                color: AppColors.textColor,
                              ),
                              SizedBox(height: 0.5 * SizeConfig.heightMultiplier),
                              CustomTextField(
                                controller: passwordController,
                                hintText: "Enter Password",
                                obscureText: obscureText,
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.go,
                              ),
                              SizedBox(height: 2 * SizeConfig.heightMultiplier),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ForgotPasswordView()),
                                    );
                                  },
                                  child: CustText(
                                    name: "Forgot password?",
                                    size: 1.6,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ),
                              SizedBox(height: 3 * SizeConfig.heightMultiplier),
                              CustButton(
                                name: "Log In",
                                size: double.infinity,
                                onSelected: (bool) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => TabScreen(index: 0)),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10), // optional spacing
                          child: CustText(
                            name: "© Copyright ${DateTime.now().year}, All rights reserved",
                            size: 1.4,
                            color: AppColors.textColor4,
                          ),
                        ),
                      ],
                    )
      
                  ],
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