import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../../utils/responsive_helper.dart';
import 'cust_loader.dart';

class CustButton extends StatelessWidget {
  final String name;
  final double? size;
  final Color? color1;
  final Color? color2;
  final double? sHeight;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontweight;
  final Color? borderColor;
  final double? borderRadius;
  final bool isEnabled;
  final bool isLoading;
  final Function(bool) onSelected;

  const CustButton({
    super.key,
    required this.name,
     this.size,
    required this.onSelected,
    this.color1,
    this.color2,
    this.sHeight,
    this.borderRadius,
    this.textColor,
    this.fontSize,
    this.fontweight,
    this.borderColor,
    this.isEnabled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return  MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: GestureDetector(
        onTap: isEnabled ? () => onSelected(true) : null,
        child: Container(
          width: size == null ? MediaQuery.of(context).size.width / 2 - 20 : ResponsiveHelper.width(context, size!),
          height: sHeight ?? ResponsiveHelper.height(context, 50),
          decoration: BoxDecoration(
            gradient: isEnabled 
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.darkBlue2,
                    AppColors.blue,
                  ],
                )
              : null,
            color: isEnabled ? null : AppColors.grey.withOpacity(0.5),
            boxShadow: [
              BoxShadow(
                color: borderColor?.withOpacity(0.5) ?? Colors.transparent,
                blurRadius: 1,
                spreadRadius: 1,
                offset: const Offset(0, 0),
              ),
            ],
            borderRadius: BorderRadius.circular(
              borderRadius ?? ResponsiveHelper.spacing(context, 8),
            ),
            border: Border.all(
              color: borderColor ?? Colors.transparent,
              width: 1.5,
            ),
            shape: BoxShape.rectangle,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const CustLoader(size: 20, color: Colors.white)
                else
                  MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: Text(
                      name,
                      style: GoogleFonts.outfit(
                        color: textColor ?? AppColors.white1,
                        fontWeight: fontweight ?? FontWeight.w400,
                        fontSize: ResponsiveHelper.fontSize(context, fontSize ?? 16),
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


class CustOutlineButton extends StatelessWidget {
  final String name;
  final double? size;
  final Color? borderColor;
  final Color? textColor;
  final double? sHeight;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontweight;
  final Function(bool) onSelected;

  const CustOutlineButton({
    super.key,
    required this.name,
    this.size,
    required this.onSelected,
    this.borderColor,
    this.textColor,
    this.sHeight,
    this.borderRadius,
    this.fontSize,
    this.fontweight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(true),
      child: Container(
        width: size == null ? MediaQuery.of(context).size.width / 2 - 20 : ResponsiveHelper.width(context, size!),
        height: sHeight ?? ResponsiveHelper.height(context, 50),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(
            borderRadius ?? ResponsiveHelper.spacing(context, 8),
          ),
          border: Border.all(
            color: borderColor ?? AppColors.textColor3,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Text(
                  name,
                  style: GoogleFonts.outfit(
                    color: textColor ?? AppColors.textColor3,
                    fontWeight: fontweight ?? FontWeight.w400,
                    fontSize: ResponsiveHelper.fontSize(context, fontSize ?? 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class GreyButton extends StatelessWidget {
  final String name;
  final double? size;
  final Color? borderColor;
  final Color? textColor;
  final double? sHeight;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontweight;
  final Function(bool) onSelected;

  const GreyButton({
    super.key,
    required this.name,
    this.size,
    required this.onSelected,
    this.borderColor,
    this.textColor,
    this.sHeight,
    this.borderRadius,
    this.fontSize,
    this.fontweight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(true),
      child: Container(
        width: size == null ? MediaQuery.of(context).size.width / 2 - 20 : ResponsiveHelper.width(context, size!),
        height: sHeight ?? ResponsiveHelper.height(context, 50),
        decoration: BoxDecoration(
          color: AppColors.textFieldFillColor,
          borderRadius: BorderRadius.circular(
            borderRadius ?? ResponsiveHelper.spacing(context, 8),
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Text(
                  name,
                  style: GoogleFonts.outfit(
                    color: textColor ?? AppColors.textColor,
                    fontWeight: fontweight ?? FontWeight.w400,
                    fontSize: ResponsiveHelper.fontSize(context, fontSize ?? 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}