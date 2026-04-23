import 'package:flutter/material.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import '../../utils/app_date_utils.dart';
import '../../constants/colors.dart';
import '../../utils/responsive_helper.dart';
import 'cust_text.dart';
import 'cust_textfield.dart';

enum CustDateTimePickerType { date, dateTime, time }

class CustDateTimePicker extends StatelessWidget {
  final String label;
  final String hint;
  final DateTime? selectedDateTime;
  final ValueChanged<DateTime?> onDateTimeSelected;
  final CustDateTimePickerType pickerType;
  final String? Function(String?)? validator;

  const CustDateTimePicker({
    Key? key,
    required this.label,
    required this.hint,
    this.selectedDateTime,
    required this.onDateTimeSelected,
    this.pickerType = CustDateTimePickerType.dateTime,
    this.validator,
  }) : super(key: key);

  Future<void> _pickDateTime(BuildContext context) async {
    final DateTime initial = selectedDateTime ?? DateTime.now();

    OmniDateTimePickerType omniType;
    switch (pickerType) {
      case CustDateTimePickerType.date:
        omniType = OmniDateTimePickerType.date;
        break;
      case CustDateTimePickerType.time:
        omniType = OmniDateTimePickerType.time;
        break;
      case CustDateTimePickerType.dateTime:
      default:
        omniType = OmniDateTimePickerType.dateAndTime;
        break;
    }

    /// 🔥 PERFECT HEIGHTS (NO EXTRA SPACE)
    double targetHeight;
    switch (pickerType) {
      case CustDateTimePickerType.date:
        targetHeight = 370;
        break;
      case CustDateTimePickerType.time:
        targetHeight = 260;
        break;
      case CustDateTimePickerType.dateTime:
      default:
        targetHeight = 600;
        break;
    }

    final DateTime? picked = await showOmniDateTimePicker(
      context: context,
      initialDate: initial,
      type: omniType,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime(2100, 12, 31),

      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,

      /// 🔥 REMOVE EXTRA SPACE
      padding: EdgeInsets.all(10),
      borderRadius: const BorderRadius.all(Radius.circular(16)),

      /// 🔥 PERFECT SIZE (NO EMPTY GAP)
      constraints: BoxConstraints(
        maxWidth: 300,
        maxHeight: targetHeight,
        minHeight: targetHeight,
      ),

      /// 🔥 SMOOTH ANIMATION
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(
              physics: const NeverScrollableScrollPhysics(), // 🔥 disables scroll
            ),
            child: child!,
          ),
        );
      },

      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,

      /// 🔥 CLEAN THEME
      theme: ThemeData(
        useMaterial3: true,

        dialogTheme: DialogThemeData(
          insetPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          constraints: BoxConstraints.tightFor(height: targetHeight)
        ),

        colorScheme: const ColorScheme.light(
          primary: AppColors.blue,
          onPrimary: Colors.white,
          surface: AppColors.white1,
          onSurface: AppColors.textColor,
        ),

        textTheme: GoogleFonts.outfitTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          titleLarge: GoogleFonts.outfit(
            color: AppColors.blue,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          bodyLarge: GoogleFonts.outfit(
            color: AppColors.textColor,
          ),
          bodyMedium: GoogleFonts.outfit(
            color: AppColors.textColor,
          ),
        ),
      ),
    );

    if (picked != null) {
      onDateTimeSelected(picked);
    }
  }
  /* 
  // Old implementation using date_picker_plus and showTimePicker
  // Commented out to switch to omni_datetime_picker as requested
  
  Future<void> _pickDateTime_old(BuildContext context) async {
    final DateTime initial = selectedDateTime ?? DateTime.now();

    if (pickerType == CustDateTimePickerType.time) {
      final pickedTime = await _showCustomTimePicker(
        context,
      );
      if (pickedTime != null) {
        onDateTimeSelected(DateTime(initial.year, initial.month, initial.day, pickedTime.hour, pickedTime.minute));
      }
      return;
    }

    // Show modern Date Picker dialog with fixed size to match Time Picker
    final DateTime? pickedDate = await showDialog<DateTime?>(
      context: context,
      builder: (dialogContext) {
        DateTime internalTempDate = initial;
        const targetWidth = 380.0;
        const targetHeight = 380.0;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: AppColors.white1,
              surfaceTintColor: AppColors.white1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              child: SizedBox(
                width: targetWidth,
                height: targetHeight,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustText(
                          name: "Select Date",
                          color: AppColors.blue.withOpacity(0.8),
                          fontWeightName: FontWeight.w600,
                          size: 1.8,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: DatePicker(
                          minDate: DateTime(1900, 1, 1),
                          maxDate: DateTime(2100, 12, 31),
                          initialDate: internalTempDate,
                          onDateSelected: (value) {
                            setStateDialog(() {
                              internalTempDate = value;
                            });
                          },
                          // Set professional padding for the calendar
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          leadingDateTextStyle: GoogleFonts.outfit(color: AppColors.blue, fontWeight: FontWeight.w600),
                          selectedCellDecoration: const BoxDecoration(
                            color: AppColors.white1,
                            shape: BoxShape.rectangle,
                            border: Border.fromBorderSide(BorderSide(color: AppColors.blue)),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          selectedCellTextStyle: GoogleFonts.outfit(color: AppColors.textColor, fontWeight: FontWeight.w500, fontSize: 16),
                          currentDateDecoration: const BoxDecoration(color: Colors.transparent),
                          currentDateTextStyle: GoogleFonts.outfit(color: AppColors.textColor, fontWeight: FontWeight.w500, fontSize: 16),
                          disabledCellsDecoration: const BoxDecoration(
                            color: AppColors.white1,
                            shape: BoxShape.rectangle,
                            border: Border.fromBorderSide(BorderSide(color: AppColors.blue)),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          disabledCellsTextStyle: GoogleFonts.outfit(color: AppColors.textColor, fontWeight: FontWeight.w500, fontSize: 16),
                          enabledCellsTextStyle: GoogleFonts.outfit(color: AppColors.textColor, fontWeight: FontWeight.w500, fontSize: 16),
                          selectedDate: DateTime.now(),
                          daysOfTheWeekTextStyle: GoogleFonts.outfit(fontSize: 13, color: AppColors.hintColor, fontWeight: FontWeight.w500),
                          slidersColor: AppColors.blue,
                          highlightColor: AppColors.blue.withOpacity(0.1),
                          splashColor: AppColors.blue.withOpacity(0.08),
                          centerLeadingDate: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext, null),
                            child: CustText(name: "Cancel", color: AppColors.blue, fontWeightName: FontWeight.bold, size: 1.6),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext, internalTempDate),
                            child: CustText(name: "OK", color: AppColors.blue, fontWeightName: FontWeight.bold, size: 1.6),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (pickedDate == null) return;

    if (pickerType == CustDateTimePickerType.date) {
      onDateTimeSelected(pickedDate);
      return;
    }

    // pickerType == CustDateTimePickerType.dateTime
    // Proceed to show Time Picker
    final TimeOfDay? pickedTime = await _showCustomTimePicker(
      context,
    );

    if (pickedTime != null) {
      onDateTimeSelected(DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      ));
    }
  }

  Future<TimeOfDay?> _showCustomTimePicker(BuildContext context) async {
    final DateTime initial = selectedDateTime ?? DateTime.now();

    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
      builder: (context, child) {
        return Dialog(
          backgroundColor: AppColors.white1,
          surfaceTintColor: AppColors.white1,
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: SizedBox(
          width: 280,
          height: 360,
          child: ClipRRect( // ✅ FIX OVERFLOW / CUT UI
            borderRadius: BorderRadius.circular(28),
            child: Center(
              child: FittedBox( // ✅ AUTO FIT CONTENT PROPERLY
                child: Transform.scale(
                  scale: 0.95, // 🔥 BEST VALUE (not too small)
                  child: Theme(
                    data: ThemeData(
                      useMaterial3: true,
                      colorScheme: const ColorScheme.light(
                        primary: AppColors.blue,
                        onPrimary: Colors.white,
                        primaryContainer: AppColors.white1,
                        onPrimaryContainer: AppColors.blue,
                        surface: AppColors.white1,
                        onSurface: AppColors.textColor,
                      ),
                      textTheme: GoogleFonts.outfitTextTheme(
                        Theme.of(context).textTheme,
                      ),
                      timePickerTheme: TimePickerThemeData(
                        backgroundColor: AppColors.white1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        padding: EdgeInsets.zero,
                        entryModeIconColor: Colors.transparent,
                        helpTextStyle: GoogleFonts.outfit(
                              color: AppColors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                        ),
                        hourMinuteTextStyle: GoogleFonts.outfit(
                          fontSize: 22, // 🔥 bigger
                          fontWeight: FontWeight.w700,
                          color: AppColors.blue,
                        ),
                        cancelButtonStyle: ButtonStyle(textStyle: WidgetStatePropertyAll(GoogleFonts.outfit(fontSize: 18,fontWeight: FontWeight.bold))),
                         confirmButtonStyle:  ButtonStyle(textStyle: WidgetStatePropertyAll(GoogleFonts.outfit(fontSize: 18,fontWeight: FontWeight.bold))),
                        hourMinuteShape: RoundedRectangleBorder(
                          side: BorderSide(color: AppColors.blue, width: 1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        dialTextStyle: GoogleFonts.outfit(
                          fontSize: 18,
                        ),
                        dayPeriodTextStyle: GoogleFonts.outfit(
                          fontSize: 16,
                        ),
                        dialHandColor: AppColors.blue,
                        dialBackgroundColor: AppColors.white1,
                        hourMinuteTextColor: AppColors.blue,
                      ),
                    ),
                    child: child!,
                  ),
                ),
              ),
            ),
          ),
        ),
        );
      },
    );
  }


  // Future<TimeOfDay?> _showCustomTimePicker(BuildContext context) async {
  //   const targetWidth = 300.0;
  //   const targetHeight = 400.0;
  //   final DateTime initial = selectedDateTime ?? DateTime.now();
  //
  //   return showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.fromDateTime(initial),
  //     builder: (context, child) {
  //       return Dialog(
  //         backgroundColor: AppColors.white1,
  //         surfaceTintColor: AppColors.white1,
  //         insetPadding: EdgeInsets.zero,
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
  //         child: SizedBox(
  //           width: targetWidth,
  //           height: targetHeight,
  //           child: Center(
  //             child: Theme(
  //               data: ThemeData(
  //                 useMaterial3: true,
  //                 colorScheme: const ColorScheme.light(
  //                   primary: AppColors.blue,
  //                   onPrimary: Colors.white,
  //                   primaryContainer: AppColors.white1,
  //                   onPrimaryContainer: AppColors.blue,
  //                   surface: AppColors.white1,
  //                   onSurface: AppColors.textColor,
  //                   surfaceContainerHighest: AppColors.white1,
  //                 ),
  //                 textTheme: GoogleFonts.outfitTextTheme(Theme.of(context).textTheme).copyWith(
  //                   labelSmall: GoogleFonts.outfit(color: AppColors.textColor),
  //                   bodyLarge: GoogleFonts.outfit(color: AppColors.textColor),
  //                 ),
  //                 timePickerTheme: TimePickerThemeData(
  //                   backgroundColor: AppColors.white1,
  //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
  //                   hourMinuteShape: RoundedRectangleBorder(
  //                     side: const BorderSide(color: AppColors.blue, width: 1),
  //                     borderRadius: BorderRadius.circular(5),
  //                   ),
  //                   dayPeriodShape: RoundedRectangleBorder(
  //                     side: const BorderSide(color: AppColors.blue, width: 1),
  //                     borderRadius: BorderRadius.circular(5),
  //                   ),
  //                   hourMinuteColor: AppColors.white1,
  //                   hourMinuteTextColor: AppColors.blue,
  //                   dialHandColor: AppColors.blue,
  //                   dialBackgroundColor: AppColors.white1,
  //                   dialTextColor: AppColors.textColor,
  //                   entryModeIconColor: AppColors.blue,
  //                   helpTextStyle: GoogleFonts.outfit(
  //                     color: AppColors.blue,
  //                     fontWeight: FontWeight.w600,
  //                     fontSize: 14,
  //                   ),
  //                   padding: EdgeInsets.all(10),
  //                   hourMinuteTextStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
  //                   dayPeriodTextStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold),
  //                   dialTextStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500),
  //                   cancelButtonStyle: ButtonStyle(
  //                     textStyle: WidgetStatePropertyAll(GoogleFonts.outfit(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 16))
  //                   ),
  //                   confirmButtonStyle: ButtonStyle(
  //                     textStyle: WidgetStatePropertyAll(GoogleFonts.outfit(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 16))
  //                   ),
  //                 ),
  //               ),
  //               child: child!,
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  */

  @override
  Widget build(BuildContext context) {
    String displayText = '';
    if (selectedDateTime != null) {
      switch (pickerType) {
        case CustDateTimePickerType.date:
          displayText = AppDateUtils.formatDate(selectedDateTime!);
          break;
        case CustDateTimePickerType.time:
          displayText = AppDateUtils.formatTime(selectedDateTime!);
          break;
        case CustDateTimePickerType.dateTime:
          displayText = AppDateUtils.formatDateTime(selectedDateTime!);
          break;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustText(
          name: label,
          size: 1.6,
          fontWeightName: FontWeight.w500,
        ),
        SizedBox(height: ResponsiveHelper.spacing(context, 4)),
        InkWell(
          onTap: () => _pickDateTime(context),
          child: AbsorbPointer(
            child: CustomTextField(
              controller: TextEditingController(text: displayText),
              hintText: hint,
              validator: validator,
              suffixIcon: Icon(
                pickerType == CustDateTimePickerType.time ? Icons.access_time : Icons.calendar_today,
                size: 24,
                color: AppColors.iconColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}