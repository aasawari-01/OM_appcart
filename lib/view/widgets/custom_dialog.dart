import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../constants/colors.dart';
import '../../utils/responsive_helper.dart';
import '../screens/tab_screen.dart';
import 'cust_button.dart';
import 'cust_text.dart';

class CustomDialog extends StatelessWidget {
  final String msg;
  final VoidCallback? onOk;

  const CustomDialog(this.msg, {Key? key, this.onOk}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.spacing(context, 16))),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return  Container(
    margin: EdgeInsets.only(top: ResponsiveHelper.spacing(context, 14), right: ResponsiveHelper.spacing(context, 8)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveHelper.spacing(context, 16)),
          color:AppColors.white1
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: ResponsiveHelper.spacing(context, 40)),
          Center(
              child: Padding(
                padding: EdgeInsets.all(ResponsiveHelper.spacing(context, 10)),
                child:  CustText(name: msg, size: 1.8, color: AppColors.textColor,
                    textAlign:TextAlign.center,fontWeightName:FontWeight.w500),
              )//
          ),
          SizedBox(height: ResponsiveHelper.spacing(context, 40)),
          Center(
            child: CustButton(
              name: "Ok",
              size:180,
              color1: AppColors.darkBlue,
              color2: AppColors.darkBlue,
              sHeight: ResponsiveHelper.height(context, 48),
              onSelected: (flag) async {
                if (onOk != null) {
                  onOk!();
                } else {
                  Get.offAll(() => const TabScreen(index: 0));
                }
              },
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(context, 48)),
        ],
      ),
    );
  }
}