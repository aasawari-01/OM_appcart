import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../../utils/responsive_helper.dart';

class InputStyles {
  static const double borderRadius = 10.0;
  static const double borderWidth = 1.0;
  static const EdgeInsets contentPadding = EdgeInsets.symmetric(
    horizontal: 12.0,
    vertical: 12.0,
  );

  static OutlineInputBorder outlineInputBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(ResponsiveHelper.spacing(context, borderRadius)),
      borderSide: const BorderSide(
        color: AppColors.textFieldColor,
        width: borderWidth,
      ),
    );
  }

  static InputDecoration baseDecoration(BuildContext context) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      counterText: "",
      isDense: true,
      contentPadding: contentPadding,
      border: outlineInputBorder(context),
      enabledBorder: outlineInputBorder(context),
      disabledBorder: outlineInputBorder(context),
      focusedBorder: outlineInputBorder(context),
    );
  }

  static TextStyle textStyle(BuildContext context) {
    return GoogleFonts.outfit(
      color: AppColors.textColor,
      fontSize: ResponsiveHelper.fontSize(context, 14),
    );
  }

  static TextStyle hintStyle(BuildContext context) {
    return GoogleFonts.outfit(
      color: AppColors.textColor4,
      fontSize: ResponsiveHelper.fontSize(context, 14),
    );
  }
}
