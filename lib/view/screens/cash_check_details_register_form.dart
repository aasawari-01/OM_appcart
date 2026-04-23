import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import '../../constants/app_data.dart';
import '../../constants/colors.dart';
import '../widgets/accordion_card.dart';
import '../widgets/cust_button.dart';
import '../widgets/cust_date_time_picker.dart';
import '../widgets/cust_dropdown.dart';
import '../widgets/cust_text.dart';
import '../widgets/cust_textfield.dart';
import 'package:get/get.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/custom_app_bar.dart';

class CashCheckDetailsRegisterForm extends StatefulWidget {
  const CashCheckDetailsRegisterForm({Key? key}) : super(key: key);

  @override
  State<CashCheckDetailsRegisterForm> createState() => _CashCheckDetailsRegisterFormState();
}

class _CashCheckDetailsRegisterFormState extends State<CashCheckDetailsRegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedStation;
  DateTime? _selectedDateTime;
  final TextEditingController _inspectingAuthorityController = TextEditingController();
  String? _selectedShift;
  final List<String> operatorNames = ["John Doe", "Jane Smith", "Alex Brown"];
  String? _selectedOperator;
  final List<String> actionTaken = ["Hold", "Cancel", "Completed"];
  String? _selectedActionTaken;
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _eosNoController = TextEditingController();
  final TextEditingController _amountEOSController = TextEditingController();
  final TextEditingController _amountCheckController = TextEditingController();
  double? _difference;
  final TextEditingController _upiAmountController = TextEditingController();
  final TextEditingController _outstandingAmountController = TextEditingController();
  final TextEditingController _actionTakenController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  int _currentStep = 0;
  final List<String> _stepTitles = [
    "Cash Check Details",
  ];

  final List<String> shiftList = ["Morning", "Evening", "Night", "General"];

  List<Widget> get _steps => [
    _buildCashCheckDetailsStep(),
  ];

  @override
  void dispose() {
    _inspectingAuthorityController.dispose();
    _employeeIdController.dispose();
    _eosNoController.dispose();
    _amountEOSController.dispose();
    _amountCheckController.dispose();
    _upiAmountController.dispose();
    _outstandingAmountController.dispose();
    _actionTakenController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _updateDifference() {
    final eos = double.tryParse(_amountEOSController.text) ?? 0.0;
    final check = double.tryParse(_amountCheckController.text) ?? 0.0;
    setState(() {
      _difference = eos - check;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "Cash Check Details Register Form"),
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
                      // TODO: Implement submit logic
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

  Widget _buildCashCheckDetailsStep() {
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
            CustomTextField(
              label: 'Name of Inspecting Authority *',
              controller: _inspectingAuthorityController,
              hintText: 'Enter Name of Inspecting Authority',
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Name of Inspecting Authority' : null,
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
            CustDropdown(
              label: 'Name Of Operator *',
              hint: 'Select Operator',
              items: operatorNames,
              selectedValue: _selectedOperator,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Operator' : null,
              onChanged: (value) {
                setState(() {
                  _selectedOperator = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Employee Id *',
              controller: _employeeIdController,
              hintText: 'Enter Employee Id',
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Employee Id' : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'EOS No. *',
              controller: _eosNoController,
              hintText: 'Enter EOS No.',
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter EOS No.' : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Amount as per EOS *',
              controller: _amountEOSController,
              hintText: 'Enter Amount as per EOS',
              keyboardType: TextInputType.number,
              onChanged: (_) => _updateDifference(),
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Amount as per EOS' : null,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Amount as per Check *',
              controller: _amountCheckController,
              hintText: 'Enter Amount as per Check',
              keyboardType: TextInputType.number,
              onChanged: (_) => _updateDifference(),
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Amount as per Check' : null,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Difference',
              readOnly: true,
              fillColor: AppColors.textFieldFillColor,
              controller: TextEditingController(text: _difference == null ? '' : _difference!.toStringAsFixed(2)),
              hintText: 'Difference',
              enabled: false,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'UPI Amount',
              controller: _upiAmountController,
              hintText: 'Enter UPI Amount',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'OutStanding Amount',
              controller: _outstandingAmountController,
              hintText: 'Enter OutStanding Amount',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Action Taken *',
              hint: 'Select Action Taken',
              items: actionTaken,
              selectedValue: _selectedActionTaken,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Action Taken' : null,
              onChanged: (value) {
                setState(() {
                  _selectedActionTaken = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Remarks * (Max 500 Characters)',
              controller: _remarksController,
              hintText: 'Enter Remarks',
              maxLines: 3,
              maxLength: 500,
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Remarks' : null,
            ),
          ],
        ),
      ),
    );
  }
} 