import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
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

    final DateTime? picked = await showDialog<DateTime?>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _CustDateTimeDialog(
        pickerType: pickerType,
        initialDateTime: initial,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      ),
    );

    if (picked == null) return;
    onDateTimeSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    String displayText = '';
    if (selectedDateTime != null) {
      switch (pickerType) {
        case CustDateTimePickerType.date:
          displayText = DateFormat('dd MM yyyy').format(selectedDateTime!);

          break;
        case CustDateTimePickerType.time:
          displayText = DateFormat('hh:mm a').format(selectedDateTime!);
          break;
        case CustDateTimePickerType.dateTime:
          displayText = DateFormat('dd MM yyyy hh:mm a').format(selectedDateTime!);

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
              controller: TextEditingController(
                text: displayText,
              ),
              hintText: hint,
              validator: validator,
              suffixIcon: Icon(
                pickerType == CustDateTimePickerType.time ? TablerIcons.clock : TablerIcons.calendar,
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

class _CustDateTimeDialog extends StatefulWidget {
  final CustDateTimePickerType pickerType;
  final DateTime initialDateTime;
  final DateTime firstDate;
  final DateTime lastDate;

  const _CustDateTimeDialog({
    required this.pickerType,
    required this.initialDateTime,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<_CustDateTimeDialog> createState() => _CustDateTimeDialogState();
}

class _CustDateTimeDialogState extends State<_CustDateTimeDialog> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late DateTime _visibleMonth;
  _CalendarMode _mode = _CalendarMode.day;
  late int _yearPageStart;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(
      widget.initialDateTime.year,
      widget.initialDateTime.month,
      widget.initialDateTime.day,
    );
    _selectedTime = TimeOfDay.fromDateTime(widget.initialDateTime);
    _visibleMonth = DateTime(_selectedDate.year, _selectedDate.month);
    _yearPageStart = (_selectedDate.year ~/ 10) * 10;
  }

  DateTime _combine() {
    final DateTime date = _selectedDate;
    final TimeOfDay time = _selectedTime;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  bool _isSelectableDate(DateTime d) {
    final DateTime dateOnly = DateTime(d.year, d.month, d.day);
    return !dateOnly.isBefore(DateTime(widget.firstDate.year, widget.firstDate.month, widget.firstDate.day)) &&
        !dateOnly.isAfter(DateTime(widget.lastDate.year, widget.lastDate.month, widget.lastDate.day));
  }

  void _prev() {
    setState(() {
      if (_mode == _CalendarMode.day) {
        _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
      } else if (_mode == _CalendarMode.month) {
        _visibleMonth = DateTime(_visibleMonth.year - 1, _visibleMonth.month);
      } else {
        _yearPageStart -= 10;
      }
    });
  }

  void _next() {
    setState(() {
      if (_mode == _CalendarMode.day) {
        _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
      } else if (_mode == _CalendarMode.month) {
        _visibleMonth = DateTime(_visibleMonth.year + 1, _visibleMonth.month);
      } else {
        _yearPageStart += 10;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showDate = widget.pickerType == CustDateTimePickerType.date || widget.pickerType == CustDateTimePickerType.dateTime;
    final bool showTime = widget.pickerType == CustDateTimePickerType.time || widget.pickerType == CustDateTimePickerType.dateTime;
    final bool showTimeSection = showTime && _mode == _CalendarMode.day;

    final ThemeData baseTheme = Theme.of(context);
    final ThemeData themed = baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: AppColors.blue,
        onPrimary: Colors.white,
        onSurface: AppColors.black,
      ),
    );

    return Theme(
      data: themed,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustText(
                        name: widget.pickerType == CustDateTimePickerType.dateTime
                            ? 'Select date & time'
                            : (widget.pickerType == CustDateTimePickerType.date ? 'Select date' : 'Select time'),
                        size: 1.8,
                        fontWeightName: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(null),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                if (showDate) ...[
                  _CustomCalendar(
                    mode: _mode,
                    visibleMonth: _visibleMonth,
                    selectedDate: _selectedDate,
                    yearPageStart: _yearPageStart,
                    onPrev: _prev,
                    onNext: _next,
                    onBack: _mode == _CalendarMode.day
                        ? null
                        : () {
                            setState(() {
                              if (_mode == _CalendarMode.year) {
                                _mode = _CalendarMode.month;
                              } else {
                                _mode = _CalendarMode.day;
                              }
                            });
                          },
                    onHeaderTap: () {
                      setState(() {
                        // Toggle up/down so user can easily go back.
                        if (_mode == _CalendarMode.day) {
                          _mode = _CalendarMode.month;
                        } else if (_mode == _CalendarMode.month) {
                          _mode = _CalendarMode.year;
                        } else {
                          _mode = _CalendarMode.month;
                        }
                      });
                    },
                    onPickYear: (year) {
                      setState(() {
                        _visibleMonth = DateTime(year, _visibleMonth.month);
                        _mode = _CalendarMode.month;
                      });
                    },
                    onPickMonth: (month) {
                      setState(() {
                        _visibleMonth = DateTime(_visibleMonth.year, month);
                        _mode = _CalendarMode.day;
                      });
                    },
                    onPickDate: (date) {
                      if (!_isSelectableDate(date)) return;
                      setState(() {
                        _selectedDate = DateTime(date.year, date.month, date.day);
                        _visibleMonth = DateTime(_selectedDate.year, _selectedDate.month);
                      });
                    },
                    isSelectable: _isSelectableDate,
                    firstDate: widget.firstDate,
                    lastDate: widget.lastDate,
                  ),
                ],
                if (showTimeSection) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.white1,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.textColor4.withOpacity(0.25)),
                    ),
                    child: SizedBox(
                      height: 120,
                      child: CupertinoTheme(
                        data: CupertinoThemeData(
                          primaryColor: AppColors.blue,
                          textTheme: const CupertinoTextThemeData(
                            dateTimePickerTextStyle: TextStyle(
                              fontSize: 18,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.time,
                          use24hFormat: false,
                          initialDateTime: DateTime(2000, 1, 1, _selectedTime.hour, _selectedTime.minute),
                          onDateTimeChanged: (dt) => setState(() => _selectedTime = TimeOfDay(hour: dt.hour, minute: dt.minute)),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(null),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.pickerType == CustDateTimePickerType.date) {
                            Navigator.of(context).pop(_selectedDate);
                          } else if (widget.pickerType == CustDateTimePickerType.time) {
                            final now = DateTime.now();
                            Navigator.of(context).pop(DateTime(now.year, now.month, now.day, _selectedTime.hour, _selectedTime.minute));
                          } else {
                            Navigator.of(context).pop(_combine());
                          }
                        },
                        child: const Text('OK'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _CalendarMode { day, month, year }

class _CustomCalendar extends StatelessWidget {
  final _CalendarMode mode;
  final DateTime visibleMonth; // year+month (day ignored)
  final DateTime selectedDate;
  final int yearPageStart;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onHeaderTap;
  final ValueChanged<int> onPickYear;
  final ValueChanged<int> onPickMonth;
  final ValueChanged<DateTime> onPickDate;
  final bool Function(DateTime) isSelectable;
  final DateTime firstDate;
  final DateTime lastDate;
  final VoidCallback? onBack;

  const _CustomCalendar({
    required this.mode,
    required this.visibleMonth,
    required this.selectedDate,
    required this.yearPageStart,
    required this.onPrev,
    required this.onNext,
    required this.onHeaderTap,
    required this.onPickYear,
    required this.onPickMonth,
    required this.onPickDate,
    required this.isSelectable,
    required this.firstDate,
    required this.lastDate,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CalendarHeader(
          mode: mode,
          visibleMonth: visibleMonth,
          yearPageStart: yearPageStart,
          onPrev: onPrev,
          onNext: onNext,
          onTap: onHeaderTap,
          onBack: onBack,
        ),
        const SizedBox(height: 8),
        if (mode == _CalendarMode.year)
          _YearGrid(
            startYear: yearPageStart,
            selectedYear: selectedDate.year,
            onPickYear: onPickYear,
          )
        else if (mode == _CalendarMode.month)
          _MonthGrid(
            selectedMonth: selectedDate.month,
            onPickMonth: onPickMonth,
          )
        else
          _DayGrid(
            visibleMonth: visibleMonth,
            selectedDate: selectedDate,
            onPickDate: onPickDate,
            isSelectable: isSelectable,
          ),
      ],
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final _CalendarMode mode;
  final DateTime visibleMonth;
  final int yearPageStart;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onTap;
  final VoidCallback? onBack;

  const _CalendarHeader({
    required this.mode,
    required this.visibleMonth,
    required this.yearPageStart,
    required this.onPrev,
    required this.onNext,
    required this.onTap,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    String title;
    if (mode == _CalendarMode.day) {
      title = DateFormat('MMMM yyyy').format(visibleMonth);
    } else if (mode == _CalendarMode.month) {
      title = '${visibleMonth.year}';
    } else {
      title = '$yearPageStart - ${yearPageStart + 9}';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            )
          else
            const SizedBox(width: 40),
          IconButton(
            onPressed: onPrev,
            icon: const Icon(Icons.chevron_left),
          ),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

class _YearGrid extends StatelessWidget {
  final int startYear; // inclusive
  final int selectedYear;
  final ValueChanged<int> onPickYear;

  const _YearGrid({
    required this.startYear,
    required this.selectedYear,
    required this.onPickYear,
  });

  @override
  Widget build(BuildContext context) {
    final years = List<int>.generate(10, (i) => startYear + i);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 3.4,
      ),
      itemCount: years.length,
      itemBuilder: (context, idx) {
        final y = years[idx];
        final bool isSelected = y == selectedYear;
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onPickYear(y),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isSelected ? AppColors.blue.withOpacity(0.10) : Colors.transparent,
              border: Border.all(
                color: isSelected ? AppColors.blue : AppColors.textColor4.withOpacity(0.25),
              ),
            ),
            child: Text(
              '$y',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.blue : AppColors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MonthGrid extends StatelessWidget {
  final int selectedMonth;
  final ValueChanged<int> onPickMonth;

  const _MonthGrid({
    required this.selectedMonth,
    required this.onPickMonth,
  });

  @override
  Widget build(BuildContext context) {
    final months = List<int>.generate(12, (i) => i + 1);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.6,
      ),
      itemCount: months.length,
      itemBuilder: (context, idx) {
        final m = months[idx];
        final bool isSelected = m == selectedMonth;
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onPickMonth(m),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isSelected ? AppColors.blue.withOpacity(0.10) : Colors.transparent,
              border: Border.all(
                color: isSelected ? AppColors.blue : AppColors.textColor4.withOpacity(0.25),
              ),
            ),
            child: Text(
              DateFormat('MMM').format(DateTime(2000, m, 1)),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.blue : AppColors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DayGrid extends StatelessWidget {
  final DateTime visibleMonth;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onPickDate;
  final bool Function(DateTime) isSelectable;

  const _DayGrid({
    required this.visibleMonth,
    required this.selectedDate,
    required this.onPickDate,
    required this.isSelectable,
  });

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(visibleMonth.year, visibleMonth.month, 1);
    final daysInMonth = DateTime(visibleMonth.year, visibleMonth.month + 1, 0).day;
    // Make Sunday=0 ... Saturday=6
    final leadingBlanks = firstOfMonth.weekday % 7;

    final items = <DateTime?>[
      ...List<DateTime?>.filled(leadingBlanks, null),
      ...List<DateTime?>.generate(daysInMonth, (i) => DateTime(visibleMonth.year, visibleMonth.month, i + 1)),
    ];

    const weekDays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: weekDays
              .map(
                (d) => Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor4,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 1.2,
          ),
          itemCount: items.length,
          itemBuilder: (context, idx) {
            final date = items[idx];
            if (date == null) return const SizedBox.shrink();

            final bool isSelected = date.year == selectedDate.year && date.month == selectedDate.month && date.day == selectedDate.day;
            final bool enabled = isSelectable(date);

            return InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: enabled ? () => onPickDate(date) : null,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.blue.withOpacity(0.18) : Colors.transparent,
                ),
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: enabled ? AppColors.black : AppColors.textColor4.withOpacity(0.5),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}