import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_data.dart';
import '../../constants/colors.dart';
import '../widgets/accordion_card.dart';
import '../widgets/cust_button.dart';
import '../widgets/cust_date_time_picker.dart';
import '../widgets/cust_dropdown.dart';
import '../widgets/cust_text.dart';
import '../widgets/cust_textfield.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_dialog.dart';

class AxleCounterResetForm extends StatefulWidget {
  const AxleCounterResetForm({Key? key}) : super(key: key);

  @override
  State<AxleCounterResetForm> createState() => _AxleCounterResetFormState();
}

class _AxleCounterResetFormState extends State<AxleCounterResetForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedStation;
  DateTime? _selectedDateTime;
  final TextEditingController _sddNoController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _counterAfterResetController = TextEditingController();
  final TextEditingController _counterBeforeResetController = TextEditingController();
  String? _selectedSCName = 'SC Name 1';
  final TextEditingController _occPvtNoController = TextEditingController();
  final TextEditingController _stationPvtNoController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();

  final List<String> scNameList = [
    'SC Name 1', 'SC Name 2', 'SC Name 3'
  ];

  @override
  void dispose() {
    _sddNoController.dispose();
    _locationController.dispose();
    _counterAfterResetController.dispose();
    _counterBeforeResetController.dispose();
    _occPvtNoController.dispose();
    _stationPvtNoController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "Axle Counter Reset Form"),
      backgroundColor: AppColors.bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: AccordionCard(
                  expanded: true,
                  onTap: () {},
                  isExpanded: false,
                  title: "Axle Counter Reset Details",
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
                        pickerType: CustDateTimePickerType.dateTime,
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
                        name: 'SDD No. (Single Section Digital Axle Counter) * (Max 5 Characters)',
                        size: 1.8,
                        fontWeightName: FontWeight.w500,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _sddNoController,
                        hintText: 'Enter SDD No.',
                        maxLength: 5,
                        validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter SDD No.' : null,
                      ),
                      const SizedBox(height: 16),
                      CustText(
                        name: 'Location *',
                        size: 1.8,
                        fontWeightName: FontWeight.w500,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _locationController,
                        hintText: 'Enter Location',
                        validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Location' : null,
                      ),
                      const SizedBox(height: 16),
                      CustText(
                        name: 'Counter No. After Reset *',
                        size: 1.8,
                        fontWeightName: FontWeight.w500,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _counterAfterResetController,
                        hintText: 'Enter Counter No. After Reset',
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Counter No. After Reset' : null,
                      ),
                      const SizedBox(height: 16),
                      CustText(
                        name: 'Counter No. Before Reset *',
                        size: 1.8,
                        fontWeightName: FontWeight.w500,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _counterBeforeResetController,
                        hintText: 'Enter Counter No. Before Reset',
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Counter No. Before Reset' : null,
                      ),
                      const SizedBox(height: 16),
                      CustDropdown(
                        label: 'SC Name *',
                        hint: 'Select SC Name',
                        items: scNameList,
                        selectedValue: _selectedSCName,
                        onChanged: (_) {}, // Disabled
                      ),
                      const SizedBox(height: 16),
                      CustText(
                        name: 'OCC PVT No. * (Max 2 Characters)',
                        size: 1.8,
                        fontWeightName: FontWeight.w500,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _occPvtNoController,
                        hintText: 'Enter OCC PVT No.',
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter OCC PVT No.' : null,
                      ),
                      const SizedBox(height: 16),
                      CustText(
                        name: 'Station PVT No. * (Max 10 Digits)',
                        size: 1.8,
                        fontWeightName: FontWeight.w500,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _stationPvtNoController,
                        hintText: 'Enter Station PVT No.',
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Station PVT No.' : null,
                      ),
                      const SizedBox(height: 16),
                      CustText(
                        name: 'Purpose * (Max 500 Characters)',
                        size: 1.8,
                        fontWeightName: FontWeight.w500,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _purposeController,
                        hintText: 'Enter Purpose',
                        maxLines: 3,
                        maxLength: 500,
                        validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Purpose' : null,
                      ),
                    ],
                  ),
                ),
              ),
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
} 