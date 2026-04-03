import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/constants/app_data.dart';

import '../widgets/accordion_card.dart';
import '../widgets/cust_button.dart';
import '../widgets/cust_date_time_picker.dart';
import '../widgets/cust_dropdown.dart';
import '../widgets/cust_text.dart';
import '../widgets/cust_textfield.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_dialog.dart';


class TomShiftLoginForm extends StatefulWidget {
  const TomShiftLoginForm({Key? key}) : super(key: key);

  @override
  State<TomShiftLoginForm> createState() => _TomShiftLoginFormState();
}

class _TomShiftLoginFormState extends State<TomShiftLoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedStation;
  String? _selectedCreatedFor;
  String? _selectedDutyShift;
  DateTime? _selectedDate;
  TimeOfDay? _reportingTime;
  final TextEditingController _shiftNoController = TextEditingController();
  final TextEditingController _privateCashController = TextEditingController();
  final TextEditingController _earningsEOSController = TextEditingController();
  final TextEditingController _totalCashDepositedController = TextEditingController();
  final TextEditingController _imprestReturnedController = TextEditingController();

  int _currentStep = 0;
  final List<String> _stepTitles = [
    "TOM Shift Details",
    "Cash Details",
  ];

  final List<String> createdForList = ["TOM", "EFO"];
  final List<String> dutyShiftList = ["Morning", "Evening", "Night"];

  List<Widget> get _steps => [
    _buildShiftDetailsStep(),
  ];

  @override
  void dispose() {
    _shiftNoController.dispose();
    _privateCashController.dispose();
    _earningsEOSController.dispose();
    _totalCashDepositedController.dispose();
    _imprestReturnedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "TOM Shift Login Form"),
      backgroundColor: AppColors.bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: _steps[_currentStep],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                  CustButton(
                    name: 'Submit',
                    onSelected: (_) {
                      if (_formKey.currentState?.validate() ?? false) {
                        Get.dialog(CustomDialog("Saved Successfully."));
                      }
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: AccordionCard(
        expanded: true,
        onTap: () {},
        isExpanded: false,
        title: _stepTitles[_currentStep],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustDropdown(
              label: 'Station *',
              hint: 'Select Station',
              items: stationListValue,
              selectedValue: _selectedStation,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Station' : null,
              onChanged: (value) {
                setState(() {
                  _selectedStation = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Created for *',
              hint: 'Select Created for',
              items: createdForList,
              selectedValue: _selectedCreatedFor,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Created For' : null,
              onChanged: (value) {
                setState(() {
                  _selectedCreatedFor = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Duty Shift *',
              hint: 'Select Duty Shift',
              items: dutyShiftList,
              selectedValue: _selectedDutyShift,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Duty Shift' : null,
              onChanged: (value) {
                setState(() {
                  _selectedDutyShift = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustDateTimePicker(
              label: 'Date *',
              hint: 'DD MM YYYY',
              pickerType: CustDateTimePickerType.date,
              selectedDateTime: _selectedDate,
              validator: (value) => _selectedDate == null ? 'Please Select Date' : null,
              onDateTimeSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
            const SizedBox(height: 16),
            CustDateTimePicker(
              label: 'Reporting Time *',
              hint: 'HH:mm',
              pickerType: CustDateTimePickerType.time,
              selectedDateTime: _reportingTime != null
                  ? DateTime(2024, 1, 1, _reportingTime!.hour, _reportingTime!.minute)
                  : null,
              validator: (value) => _reportingTime == null ? 'Please Select Reporting Time' : null,
              onDateTimeSelected: (dateTime) {
                if (dateTime != null) {
                  setState(() {
                    _reportingTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Shift No.',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _shiftNoController,
              hintText: 'Enter Shift No.',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Private Cash *',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _privateCashController,
              hintText: 'Enter Private Cash',
              keyboardType: TextInputType.number,
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Private Cash' : null,
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Earnings as Per EOS *',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _earningsEOSController,
              hintText: 'Enter Earnings as Per EOS',
              keyboardType: TextInputType.number,
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Earnings as Per EOS' : null,
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Total Cash Deposited (Excluding Imprest) *',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _totalCashDepositedController,
              hintText: 'Enter Total Cash Deposited',
              keyboardType: TextInputType.number,
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Total Cash Deposited' : null,
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Imprest Returned / Handed Over',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _imprestReturnedController,
              hintText: 'Enter Imprest Returned / Handed Over',
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

} 