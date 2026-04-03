import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import '../../constants/colors.dart';
import '../../utils/responsive_helper.dart';
import 'cust_text.dart';
import 'cust_textfield.dart';

class CustDatePicker extends StatelessWidget {
  final String label;
  final String hint;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateSelected;
  final String? Function(String?)? validator;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustDatePicker({
    Key? key,
    required this.label,
    required this.hint,
    this.selectedDate,
    required this.onDateSelected,
    this.validator,
    this.firstDate,
    this.lastDate,
  }) : super(key: key);

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) {
        final ThemeData baseTheme = Theme.of(context);
        return Theme(
          data: baseTheme.copyWith(
            colorScheme: baseTheme.colorScheme.copyWith(
              primary: AppColors.blue,
              onPrimary: Colors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;
    onDateSelected(DateTime(picked.year, picked.month, picked.day));
  }

  @override
  Widget build(BuildContext context) {
    String displayText = '';
    if (selectedDate != null) {
      displayText = DateFormat('dd MM yyyy').format(selectedDate!);
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
          onTap: () => _pickDate(context),
          child: AbsorbPointer(
            child: CustomTextField(
              controller: TextEditingController(
                text: displayText,
              ),
              hintText: hint,
              validator: validator,
              suffixIcon: const Icon(
                TablerIcons.calendar,
                size: 24,
                color: AppColors.textColor4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
