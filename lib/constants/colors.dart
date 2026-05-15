import 'package:flutter/material.dart';

// class AppColors {
//   static const Color black = Color(0xFF1B1818);
//   static const Color textColor = Color(0xFF4A4A4A);
//   static const Color textColor2 = Color(0xFF081173);
//   static const Color textColor3= Color(0xFF0089BA);
//   static const Color textColor4= Color(0xFF272424);
//   static const Color textColor5= Color(0xFF1C1C1C);
//   static const Color textFieldColor = Color(0xFFECECEC);
//   static const Color textFieldFillColor = Color(0x90D2D2D2);
//   static const Color tabImageColor = Color(0xFFD2D2D2);
//   static const Color hintColor= Color(0xFFA6A1A0);
//   static const Color iconColor= Color(0xFF888888);
//
//
//   // Gradient colors
//   static const Color gradientStart = Color(0xFF226076);
//   static const Color gradientEnd = Color(0xFF0089BA);
//
//   // Border colors
//   static const Color hintTextColor = Color(0xFF777777);
//   static const Color dividerColor = Color(0xFFF7F7F7);
//   static const Color dividerColor2 = Color(0xFFE9E9E9);
//   static const Color dividerColor3 = Color(0xFFC9F0FF);
//
//   // Background colors
//   static const Color bgColor = Color(0xFFFAFAF9);
//   static const Color appBarColor = Color(0xff020523);
//   static const Color containerColor = Color(0xffDEE0F6);
//   static const Color containerColor1 = Color(0xffF9F7F7);
//
//   // Button colors
//   static const Color white1 = Color(0xFFFFFFFF);
//   static const Color white2 = Color(0xFFFDFDFD);
//
//   static const Color red = Color(0xFFDD3737);
//   static const Color darkRed = Color(0xFFB71C1C );
//   static const Color yellow = Color(0xFFFBB914);
//   static const Color green = Color(0xFF0E7D1F);
//   static const Color darkBlue = Color(0xFF0C4C84);
//   static const Color orange = Color(0xFFEC952B);
//
//   static const Color barColor1 = Color(0xAFFB3714);
//   static const Color barColor2 = Color(0xAF0CBA40);
//   static const Color barColor3 = Color(0xFFFF8C1A);
//   static const Color barColor4 = Color(0xFF4CAC39);
//   static const Color barColor5 = Color(0xFF5D7FF5);
//
//   static const Color stepColor = Color(0xFFF0AA55);
//   static const Color stepCompleteColor = Color(0xFF3E974B);
//
//   static const Color menuBackgroundColor = Color(0xFFEEFAFF);
//   static const Color blue = Color(0xFF007EAB);
//   static const Color blueShade = Color(0xFF0C5671);
//   static const Color darkBlue2 = Color(0xFF083C73);
//   static const Color blue2 = Color(0xFF1D4ED8);
//
//
//   // Indicator / neutral colors
//   static const Color grey = Color(0xFF9E9E9E);
//   static const Color subMenuColor = Color(0xfff6f6f6);
//   static const Color maroon = Color(0xFFC2410C);
//   static const Color unschedule = Color(0xFFFFF4E5);
//   static const Color schedule=Color(0xffE6F0FF);
//   static const Color cardBg= Color(0xffEDFAFF);
//   static const Color analyticText= Color(0xffFEB019);
//   static const Color cardBg2= Color(0xffFBF2DD);
//   static const Color analyticText2= Color(0xff24A831);
//   static const Color cardBg3= Color(0xffDFFDE4);
//   static const Color piechart1= Color(0xff008FFB);
//   static const Color percentBgColor= Color(0xffFBE7E7);
//   // static const Color piechart3= Color(0xffDFFDE4);
//
//
//
//
// }


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Primary Color Options ────────────────────────────────────────────────────
// Five brand-ready primary colors the user can choose from.
const List<AppPrimaryColor> kPrimaryColors = [
  AppPrimaryColor(
    name: 'Ocean Blue',
    color: AppColors.primaryBlue, // original blue
    lightTint: Color(0xFFE0F7FA),
    assetFolder: 'cyan_blue',
  ),
  AppPrimaryColor(
    name: 'Blue',
    color: AppColors.softBlue,
    lightTint: Color(0xFFE6F4ED),
    assetFolder: 'blue',
  ),
  AppPrimaryColor(
    name: 'Sagar graan',
    color: AppColors.sageGreen,
    lightTint: Color(0xFFF0E9FA),
    assetFolder: 'green',
  ),
  AppPrimaryColor(
    name: 'MustardGold',
    color: AppColors.mustardGold,
    lightTint: Color(0xFFFFF0E8),
    assetFolder: 'brown',
  ),

  AppPrimaryColor(
    name: 'Orange',
    color: AppColors.orange2,
    lightTint: Color(0xFFFCE8F1),
    assetFolder: 'orange',
  ),
  AppPrimaryColor(
    name: 'Black',
    color: AppColors.black,
    lightTint: Color(0xFFFCE8F1),
    assetFolder: 'black',
  ),
];

// ─── AppPrimaryColor model ────────────────────────────────────────────────────
class AppPrimaryColor {
  final String name;
  final Color color;
  final Color lightTint;
  final String assetFolder; // ← add this

  const AppPrimaryColor({
    required this.name,
    required this.color,
    required this.lightTint,
    required this.assetFolder, // ← add this
  });
}

// ─── ThemeManager – single source of truth ───────────────────────────────────
class ThemeManager {
  static const _prefKey = 'selected_primary_color_index';

  // Reactive notifier — widgets listen to this
  static final ValueNotifier<AppPrimaryColor> primaryColorNotifier =
  ValueNotifier(kPrimaryColors[0]);

  /// Call once in main() before runApp()
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_prefKey) ?? 0;
    primaryColorNotifier.value = kPrimaryColors[index.clamp(0, kPrimaryColors.length - 1)];
  }

  /// Call when user picks a new color
  static Future<void> setPrimaryColor(int index) async {
    primaryColorNotifier.value = kPrimaryColors[index.clamp(0, kPrimaryColors.length - 1)];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, index);
  }

  static AppPrimaryColor get current => primaryColorNotifier.value;
}

// ─── AppColors ────────────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  // ── Dynamic primary — use AppColors.primary everywhere ──────────────────
  /// The current primary color (replaces the old hard-coded `blue`).
  static Color get primary => ThemeManager.current.color;

  /// Light tint variant of the primary (e.g. button backgrounds, chips).
  static Color get primaryTint => ThemeManager.current.lightTint;

  // ── All other colors remain constant ────────────────────────────────────

  static const Color textColor    = Color(0xFF4A4A4A);
  static const Color textColor2   = Color(0xFF081173);
  static const Color textColor3   = Color(0xFF0089BA);
  static const Color textColor4   = Color(0xFF272424);
  static const Color textColor5   = Color(0xFF1C1C1C);


  // icon colors
  static const Color primaryBlue   = Color(0xFF007EAB);
  static const Color softBlue      = Color(0xFF537CB1);
  static const Color sageGreen     = Color(0xFF83AC7F);
  static const Color mustardGold   = Color(0xFFBD8005);
  static const Color black        = Color(0xFF1B1818);
  static const Color orange2 = Color(0xFFED8544);


  static const Color textFieldColor     = Color(0xFFECECEC);
  static const Color textFieldFillColor = Color(0x90D2D2D2);
  static const Color tabImageColor      = Color(0xFFD2D2D2);
  static const Color hintColor          = Color(0xFFA6A1A0);
  static const Color iconColor          = Color(0xFF888888);

  // Gradient
  static const Color gradientStart = Color(0xFF226076);
  static const Color gradientEnd   = Color(0xFF0089BA);

  // Borders / dividers
  static const Color hintTextColor = Color(0xFF777777);
  static const Color dividerColor  = Color(0xFFF7F7F7);
  static const Color dividerColor2 = Color(0xFFE9E9E9);
  static const Color dividerColor3 = Color(0xFFC9F0FF);

  // Backgrounds
  static const Color bgColor         = Color(0xFFFAFAF9);
  static const Color appBarColor     = Color(0xff020523);
  static const Color containerColor  = Color(0xffDEE0F6);
  static const Color containerColor1 = Color(0xffF9F7F7);

  // Buttons / whites
  static const Color white1 = Color(0xFFFFFFFF);
  static const Color white2 = Color(0xFFFDFDFD);

  // Status colours
  static const Color red     = Color(0xFFDD3737);
  static const Color darkRed = Color(0xFFB71C1C);
  static const Color yellow  = Color(0xFFFBB914);
  static const Color green   = Color(0xFF0E7D1F);
  static const Color orange  = Color(0xFFEC952B);

  static const Color darkBlue  = Color(0xFF0C4C84);
  static const Color blueShade = Color(0xFF0C5671);
  static const Color darkBlue2 = Color(0xFF083C73);
  static const Color blue2     = Color(0xFF1D4ED8);

  // Bar / chart colours
  static const Color barColor1 = Color(0xAFFB3714);
  static const Color barColor2 = Color(0xAF0CBA40);
  static const Color barColor3 = Color(0xFFFF8C1A);
  static const Color barColor4 = Color(0xFF4CAC39);
  static const Color barColor5 = Color(0xFF5D7FF5);

  // Step indicators
  static const Color stepColor         = Color(0xFFF0AA55);
  static const Color stepCompleteColor = Color(0xFF3E974B);

  // Misc
  static const Color menuBackgroundColor = Color(0xFFEEFAFF);
  static const Color grey          = Color(0xFF9E9E9E);
  static const Color subMenuColor  = Color(0xfff6f6f6);
  static const Color maroon        = Color(0xFFC2410C);
  static const Color unschedule    = Color(0xFFFFF4E5);
  static const Color schedule      = Color(0xffE6F0FF);
  static const Color cardBg        = Color(0xffEDFAFF);
  static const Color analyticText  = Color(0xffFEB019);
  static const Color cardBg2       = Color(0xffFBF2DD);
  static const Color analyticText2 = Color(0xff24A831);
  static const Color cardBg3       = Color(0xffDFFDE4);
  static const Color piechart1     = Color(0xff008FFB);
  static const Color percentBgColor= Color(0xffFBE7E7);
}



