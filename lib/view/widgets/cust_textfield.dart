import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:flutter/services.dart';

import '../../constants/colors.dart';
import '../../utils/responsive_helper.dart';
import 'cust_text.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final String? label;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final int? maxLength;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;
  final int? maxLines;
  final TextCapitalization textCapitalization;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign? textAlign;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onSubmitted,
    this.suffixIcon,
    this.prefixIcon,
    this.readOnly = false,
    this.maxLength,
    this.maxLines,
    this.validator,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
    this.fillColor,
    this.inputFormatters,
    this.textAlign,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Set maxLines to 1 if obscureText is true, otherwise use provided maxLines or default to 1
    int effectiveMaxLines = obscureText ? 1 : maxLines ?? 1;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            CustText(
              name: label!,
              size: 1.6,
              fontWeightName: FontWeight.w500,
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 4)),
          ],
          TextFormField(
        enabled: enabled,
        style: GoogleFonts.outfit(color: AppColors.textColor4, fontSize: ResponsiveHelper.fontSize(context, 14)),
        cursorColor: AppColors.textColor,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        readOnly: readOnly,
        maxLength: maxLength,
        validator: validator,
        focusNode: focusNode,
        autofocus: autofocus,
        maxLines: effectiveMaxLines,
        textCapitalization: textCapitalization,
        onTap: onTap,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        inputFormatters: inputFormatters,
        textAlign: textAlign ?? TextAlign.start,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.outfit(color: AppColors.hintColor, fontSize: ResponsiveHelper.fontSize(context, 14)),
          filled: true,
          fillColor: fillColor ?? Colors.white,
          counterText: "",
          errorStyle: GoogleFonts.outfit(
            fontSize: ResponsiveHelper.fontSize(context, 10),
            height: 1.0,
          ),
          suffixIcon: suffixIcon != null ? Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child:suffixIcon,
          ) : null,
          suffixIconConstraints: const BoxConstraints(
            minHeight: 24,
            minWidth: 24,
          ),
          prefixIcon: prefixIcon,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.spacing(context, 10)),
            borderSide: BorderSide(color: AppColors.textFieldColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.spacing(context, 10)),
            borderSide: BorderSide(color: AppColors.textFieldColor),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.spacing(context, 10)),
            borderSide: BorderSide(color: AppColors.textFieldColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.spacing(context, 10)),
            borderSide: BorderSide(color: AppColors.blue),
          ),
          contentPadding: const EdgeInsets.fromLTRB(0, 10, 12, 10),
          prefix: const SizedBox(width: 10),
          ),
    ),
     ] ),
    );
  }
}