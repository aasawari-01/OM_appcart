import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/constants/app_data.dart';
import 'package:om_appcart/utils/responsive_helper.dart';
import 'package:om_appcart/view/widgets/cust_textfield.dart';

import '../widgets/accordion_card.dart';
import '../widgets/cust_button.dart';
import '../widgets/cust_date_time_picker.dart';
import '../widgets/cust_dropdown.dart';
import '../widgets/cust_radio.dart';
import '../widgets/cust_text.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/file_upload_section.dart';

class GatePassDetailsForm extends StatefulWidget {
  const GatePassDetailsForm({Key? key}) : super(key: key);

  @override
  State<GatePassDetailsForm> createState() => _GatePassDetailsFormState();
}

class _GatePassDetailsFormState extends State<GatePassDetailsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Dropdown Values
  String? _selectedStation;
  String? _selectedReturnableType;
  String? _selectedEmployee;
  String? _selectedDepartment;

  // Input Fields
  DateTime? _selectedDateTime;
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // File Upload
  List<dynamic> _attachedFiles = [];

  final List<String> returnableTypeList = ["Returnable", "Non-Returnable"];
  int _currentStep = 0;

  final List<String> _stepTitles = [
    "Gate Pass Details",
  ];

  List<Widget> get _steps => [_buildGatePassDetailsStep()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "Gate Pass Details Form"),
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: _steps[_currentStep],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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

  Widget _buildGatePassDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: AccordionCard(
        expanded: true,
        isExpanded: false,
        title: _stepTitles[_currentStep],
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustDropdown(
              label: 'Station *',
              hint: 'Select Station',
              items: stationListValue,
              selectedValue: _selectedStation,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Station' : null,
              onChanged: (value) => setState(() => _selectedStation = value),
            ),
            const SizedBox(height: 16),
            CustDateTimePicker(
              label: 'Date & Time *',
              hint: 'DD/MM/YYYY hh:mm',
              pickerType: CustDateTimePickerType.dateTime,
              selectedDateTime: _selectedDateTime,
              validator: (value) => _selectedDateTime == null ? 'Please Select Date & Time' : null,
              onDateTimeSelected: (dateTime) =>
                  setState(() => _selectedDateTime = dateTime),
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Returnable/Non-Returnable *',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            Row(
              children: returnableTypeList.map((option) => Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CustRadio<String>(
                  value: option,
                  groupValue: _selectedReturnableType ?? '',
                  label: option,
                  onChanged: (value) {
                    setState(() {
                      _selectedReturnableType = value;
                    });
                  },
                ),
              )).toList(),
            ),
            FormField<String>(
              validator: (value) => _selectedReturnableType == null ? 'Please Select Returnable Option' : null,
              builder: (state) => state.hasError 
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(state.errorText!, style: TextStyle(color: AppColors.red, fontSize: 12)),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Purpose of Issue * (Max 100)',
              controller: _purposeController,
              maxLength: 100,
              hintText: 'Enter Purpose of Issue',
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Purpose of Issue' : null,
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Employee Name of Receiver *',
              hint: 'Select',
              items: [],
              selectedValue: _selectedEmployee,
              validator: (value) => (value == null || value.isEmpty) && _selectedEmployee == null ? 'Please Select Employee' : null,
              onChanged: (value) => setState(() => _selectedEmployee = value),
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Department *',
              hint: 'Select',
              items: departmentListValue,
              selectedValue: _selectedDepartment,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Department' : null,
              onChanged: (value) => setState(() => _selectedDepartment = value),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Mobile No. * (Max 10)',
              controller: _phoneController,
              maxLength: 10,
              keyboardType: TextInputType.number,
              hintText: 'Enter Phone No.',
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Please Enter Phone No.';
                if (value.length < 10) return 'Please Enter Valid Phone No.';
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Description of Item * (Max 500)',
              controller: _descriptionController,
              maxLength: 500,
              maxLines: 4,
              hintText: 'Description of Item',
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Description of Item' : null,
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Attachments: * (Max File Size 1 MB)',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
             SizedBox(height: ResponsiveHelper.spacing(context, 8)),
            FileUploadSection(
              files: _attachedFiles,
              onFilesChanged: (files) {
                setState(() {
                  _attachedFiles = files;
                });
              },
            ),
            FormField<List>(
              validator: (value) => _attachedFiles.isEmpty ? 'Please Attach Atleast One File' : null,
              builder: (state) => state.hasError 
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(state.errorText!, style: TextStyle(color: AppColors.red, fontSize: 12)),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

