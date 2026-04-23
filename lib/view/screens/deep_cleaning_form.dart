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



class DeepCleaningForm extends StatefulWidget {
  const DeepCleaningForm({Key? key}) : super(key: key);

  @override
  State<DeepCleaningForm> createState() => _DeepCleaningFormState();
}

class _DeepCleaningFormState extends State<DeepCleaningForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedStation;
  DateTime? _selectedDateTime;
  String? _selectedShift;
  final TextEditingController _noOfStaffController = TextEditingController();
  String? _selectedStatus;
  final TextEditingController _natureOfWorkController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  int _currentStep = 0;
  final List<String> _stepTitles = [
    "Deep Cleaning Details",
  ];

  final List<String> shiftList = ["Morning", "Evening", "Night"];
  final List<String> statusList = ["Cleaned", "Uncleaned"];

  List<Widget> get _steps => [
    _buildDeepCleaningDetailsStep(),
  ];

  @override
  void dispose() {
    _noOfStaffController.dispose();
    _natureOfWorkController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "Deep Cleaning Form"),
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

  Widget _buildDeepCleaningDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: AccordionCard(
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
            CustDateTimePicker(
              label: 'Date & Time *',
              hint: 'DD/MM/YYYY hh:mm',
              selectedDateTime: _selectedDateTime,
              validator: (value) => _selectedDateTime == null ? 'Please Select Date & Time' : null,
              onDateTimeSelected: (dateTime) {
                setState(() {
                  _selectedDateTime = dateTime;
                });
              },
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Shift *',
              hint: 'Select Shift',
              items: shiftList,
              selectedValue: _selectedShift,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Shift' : null,
              onChanged: (value) {
                setState(() {
                  _selectedShift = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'No of Staff *',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _noOfStaffController,
              hintText: 'Enter No of Staff',
              keyboardType: TextInputType.number,
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter No of Staff' : null,
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Status *',
              hint: 'Select Status',
              items: statusList,
              selectedValue: _selectedStatus,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Status' : null,
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Work description * (Max 500 Characters)',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _natureOfWorkController,
              hintText: 'Enter Nature of Work',
              maxLines: 4,
              maxLength: 500,
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Nature of Work' : null,
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Remark * (Max 500 Characters)',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _remarkController,
              hintText: 'Enter Remark',
              maxLines: 3,
              maxLength: 500,
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Remark' : null,
            ),
          ],
        ),
      ),
    );
  }
} 