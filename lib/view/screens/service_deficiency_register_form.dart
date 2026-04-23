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


class ServiceDeficiencyRegisterForm extends StatefulWidget {
  const ServiceDeficiencyRegisterForm({Key? key}) : super(key: key);

  @override
  State<ServiceDeficiencyRegisterForm> createState() => _ServiceDeficiencyRegisterFormState();
}

class _ServiceDeficiencyRegisterFormState extends State<ServiceDeficiencyRegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedStation;
  DateTime? _selectedDateTime;
  final TextEditingController _staffNameController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  String? _selectedDutyShift;
  String? _selectedStatus;
  String? _selectedPenaltyClause;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  int _currentStep = 0;
  final List<String> _stepTitles = [
    "Service Deficiency Details",
  ];

  final List<String> dutyShiftList = ["Morning", "Evening", "Night", "General"];
  final List<String> statusList = ["Open", "Closed"];
  final List<String> penaltyClauseList = ["Man", "Machine"];

  List<Widget> get _steps => [
    _buildServiceDeficiencyDetailsStep(),
  ];

  @override
  void dispose() {
    _staffNameController.dispose();
    _sectionController.dispose();
    _descriptionController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "Service Deficiency Register Form"),
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

  Widget _buildServiceDeficiencyDetailsStep() {
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
              name: 'Name of Staff *',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _staffNameController,
              hintText: 'Enter Name of Staff',
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Name of Staff' : null,
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Section *',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _sectionController,
              hintText: 'Enter Section',
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Section' : null,
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
            CustDropdown(
              label: 'Penalty Clause *',
              hint: 'Select Penalty Clause',
              items: penaltyClauseList,
              selectedValue: _selectedPenaltyClause,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Penalty Clause' : null,
              onChanged: (value) {
                setState(() {
                  _selectedPenaltyClause = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Description of Service Deficiencies * (Max 500 Characters)',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _descriptionController,
              hintText: 'Enter Description',
              maxLines: 3,
              maxLength: 500,
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Description' : null,
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