import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/constants/app_data.dart';
import '../widgets/accordion_card.dart';
import '../widgets/cust_button.dart';
import '../widgets/cust_date_time_picker.dart';
import '../widgets/cust_dropdown.dart';
import '../widgets/cust_text.dart';
import '../widgets/cust_textfield.dart';
import '../widgets/cust_toggle.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/file_upload_section.dart';


class PenaltyRegisterForm extends StatefulWidget {
  const PenaltyRegisterForm({Key? key}) : super(key: key);

  @override
  State<PenaltyRegisterForm> createState() => _PenaltyRegisterFormState();
}

class _PenaltyRegisterFormState extends State<PenaltyRegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedStation;
  DateTime? _selectedDateTime;
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _passengerNameController = TextEditingController();
  final TextEditingController _passengerAddressController = TextEditingController();
  bool _amountDepositedToBank = false;
  DateTime? _amountDepositionDate;
  final TextEditingController _receiptNoController = TextEditingController();
  List<dynamic> _uploadedFiles = [];
  final TextEditingController _penaltyDescriptionController = TextEditingController();

  int _currentStep = 0;
  final List<String> _stepTitles = [
    "Penalty Register Details",
  ];

  List<Widget> get _steps => [
    _buildPenaltyRegisterDetailsStep(),
  ];

  @override
  void dispose() {
    _sectionController.dispose();
    _amountController.dispose();
    _passengerNameController.dispose();
    _passengerAddressController.dispose();
    _receiptNoController.dispose();
    _penaltyDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "Penalty Register Form"),
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

  Widget _buildPenaltyRegisterDetailsStep() {
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
            CustText(
              name: 'Section of Penalty',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _sectionController,
              hintText: 'Enter Section of Penalty',
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Amount *',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _amountController,
              hintText: 'Enter Amount',
              keyboardType: TextInputType.number,
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Amount' : null,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Name of Passenger *',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _passengerNameController,
              hintText: 'Enter Name of Passenger',
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Name of Passenger' : null,
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Address of Passenger *',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _passengerAddressController,
              hintText: 'Enter Address of Passenger',
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Address of Passenger' : null,
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Amount Deposited To Bank *',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            YesNoToggle(
              value: _amountDepositedToBank,
              onChanged: (val) {
                setState(() {
                  _amountDepositedToBank = val;
                  if (!val) _amountDepositionDate = null;
                });
              },
            ),
            if (_amountDepositedToBank) ...[
              const SizedBox(height: 16),
              CustDateTimePicker(
                label: 'Amount deposition date *',
                hint: 'Select Date',
                pickerType: CustDateTimePickerType.date,
                selectedDateTime: _amountDepositionDate,
                validator: (value) => _amountDepositionDate == null ? 'Please Select Deposition Date' : null,
                onDateTimeSelected: (date) {
                  setState(() {
                    _amountDepositionDate = date;
                  });
                },
              ),
            ],
            const SizedBox(height: 16),
            CustText(
              name: 'Receipt No',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _receiptNoController,
              hintText: 'Enter Receipt No',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Upload Attachment',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            FileUploadSection(
              files: _uploadedFiles,
              onFilesChanged: (files) {
                setState(() {
                  _uploadedFiles = files;
                });
              },
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Penalty Description *',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _penaltyDescriptionController,
              hintText: 'Enter Penalty Description',
              maxLines: 3,
              maxLength: 500,
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Penalty Description' : null,
            ),
          ],
        ),
      ),
    );
  }
} 