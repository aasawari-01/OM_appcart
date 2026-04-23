import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../../constants/app_constants.dart';
import '../../utils/responsive_helper.dart';

class CustText extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;
  final FontWeight? fontWeightName;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const CustText({
    super.key,
    required this.name,
    required this.size,
    this.color,
    this.fontWeightName,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  /// Standard Section Header (e.g. "Personal Details")
  static CustText sectionHeader(String name, {Color? color, TextAlign? textAlign}) {
    return CustText(
      name: name,
      size: AppConstants.sectionHeaderSize,
      fontWeightName: FontWeight.w600,
      color: color ?? AppColors.gradientEnd,
      textAlign: textAlign,
    );
  }

  /// Standard Form/Input Label (e.g. "First Name")
  static CustText formLabel(String name, {Color? color, TextAlign? textAlign}) {
    return CustText(
      name: name,
      size: AppConstants.formLabelSize,
      fontWeightName: FontWeight.w500,
      color: color ?? AppColors.textColor,
      textAlign: textAlign,
    );
  }

  /// Standard Detail View Label (e.g. "Station:")
  static CustText detailLabel(String name, {Color? color, TextAlign? textAlign}) {
    return CustText(
      name: name,
      size: AppConstants.detailLabelSize,
      fontWeightName: FontWeight.w400,
      color: color ?? AppColors.textColor4,
      textAlign: textAlign,
    );
  }

  /// Standard Detail View Value (e.g. "Mumbai")
  static CustText detailValue(String name, {Color? color, TextAlign? textAlign, TextOverflow? overflow}) {
    return CustText(
      name: name,
      size: AppConstants.detailValueSize,
      fontWeightName: FontWeight.bold,
      color: color ?? AppColors.black,
      textAlign: textAlign,
      overflow: overflow,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Text(
        name,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: GoogleFonts.outfit(
          color: color ?? AppColors.textColor,
          fontWeight: fontWeightName ?? FontWeight.w400,
          fontSize: ResponsiveHelper.fontSize(context, size * 10.0),
        ),
      ),
    );
  }
}










// import 'package:google_fonts/google_fonts.dart';
//
// import '../utils/SizeConfig.dart';
//
// class CustText extends StatelessWidget {
//
//   final String name;
//   final double size;
//   final Color colors;
//   final TextAlign textAlign;
//   final FontWeight fontWeightName;
//   final int maxLine;
//
//   const CustText({
//     super.key,
//     required this.name,
//     required this.size,
//     required this.colors,
//     required this.textAlign,
//     required this.fontWeightName,
//     required this.maxLine,
//   });
//   @override
//   Widget build(BuildContext context) {
//     final mediaQueryData = MediaQuery.of(context);
//     final scale = mediaQueryData.textScaler.clamp(
//       minScaleFactor: 1.0, // Minimum scale factor allowed.
//       maxScaleFactor: 1.3, // Maximum scale factor allowed.
//     );
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return MediaQuery(
//           data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
//           child: Text(
//               name,
//               textAlign: textAlign,
//               maxLines: maxLine,
//               style: GoogleFonts.cabin(
//                 textStyle: TextStyle(
//                   color: colors,
//                   fontWeight: fontWeightName,
//                   fontSize: size * SizeConfig.textMultiplier,
//                 )
//               ),
//             ),
//         );
//       },
//     );
//   }
// }
//
// class HeadingText extends StatelessWidget{
//
//   final String name;
//   final double size;
//   final Color colors;
//   final TextAlign textAlign;
//   final FontWeight fontWeightName;
//   final int maxLine;
//
//   const HeadingText({
//     super.key,
//     required this.name,
//     required this.size,
//     required this.colors,
//     required this.textAlign,
//     required this.fontWeightName,
//     required this.maxLine,
//   });
//   @override
//   Widget build(BuildContext context) {
//     final mediaQueryData = MediaQuery.of(context);
//     final scale = mediaQueryData.textScaler.clamp(
//       minScaleFactor: 1.0, // Minimum scale factor allowed.
//       maxScaleFactor: 1.3, // Maximum scale factor allowed.
//     );
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return MediaQuery(
//           data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
//           child: Text(
//               name,
//               textAlign: textAlign,
//               maxLines: maxLine,
//               style: GoogleFonts.inter(
//                 textStyle: TextStyle(
//                   color: colors,
//                   fontWeight: fontWeightName,
//                   fontSize: size * SizeConfig.textMultiplier,
//                 )
//               ),
//             ),
//         );
//       },
//     );
//   }
// }
//
// class SubHeadingText extends StatelessWidget{
//
//   final String name;
//   final double size;
//   final Color colors;
//   final TextAlign textAlign;
//   final FontWeight fontWeightName;
//   final int maxLine;
//
//   const SubHeadingText({
//     super.key,
//     required this.name,
//     required this.size,
//     required this.colors,
//     required this.textAlign,
//     required this.fontWeightName,
//     required this.maxLine,
//   });
//   @override
//   Widget build(BuildContext context) {
//     final mediaQueryData = MediaQuery.of(context);
//     final scale = mediaQueryData.textScaler.clamp(
//       minScaleFactor: 1.0, // Minimum scale factor allowed.
//       maxScaleFactor: 1.3, // Maximum scale factor allowed.
//     );
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return MediaQuery(
//           data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
//           child: Text(
//               name,
//               textAlign: textAlign,
//               maxLines: maxLine,
//               style: GoogleFonts.inter(
//                 textStyle: TextStyle(
//                   color: colors,
//                   fontWeight: fontWeightName,
//                   fontSize: size * SizeConfig.textMultiplier,
//                 )
//               ),
//             ),
//         );
//       },
//     );
//   }
// }
