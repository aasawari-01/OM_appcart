import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:om_appcart/constants/colors.dart';

import '../../constants/app_data.dart';
import '../widgets/accordion_card.dart';
import '../widgets/cust_button.dart';
import '../widgets/cust_date_time_picker.dart';
import '../widgets/cust_dropdown.dart';
import '../widgets/cust_text.dart';
import '../widgets/cust_textfield.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_dialog.dart';

class ManualTicketDetailsForm extends StatefulWidget {
  const ManualTicketDetailsForm({Key? key}) : super(key: key);

  @override
  State<ManualTicketDetailsForm> createState() => _ManualTicketDetailsFormState();
}

class _ManualTicketDetailsFormState extends State<ManualTicketDetailsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedStation;
  DateTime? _selectedDateTime;
  final TextEditingController _operatorNameController = TextEditingController();
  String? _selectedSourceStation;
  String? _selectedDestinationStation;
  final TextEditingController _fareAmountController = TextEditingController();
  final TextEditingController _serialNoController = TextEditingController();

  int _currentStep = 0;
  final List<String> _stepTitles = [
    "Manual Ticket Details",
  ];

  List<Widget> get _steps => [
    _buildManualTicketDetailsStep(),
  ];

  @override
  void dispose() {
    _operatorNameController.dispose();
    _fareAmountController.dispose();
    _serialNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "Manual Ticket Details Form"),
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

  Widget _buildManualTicketDetailsStep() {
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
              label: 'Name of TOM/EFO Operator',
              controller: _operatorNameController,
              hintText: 'Enter Name of TOM/EFO Operator',
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Source Station *',
              hint: 'Select Source Station',
              items: stationListValue,
              selectedValue: _selectedSourceStation,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Source Station' : null,
              onChanged: (value) {
                setState(() {
                  _selectedSourceStation = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Destination Station *',
              hint: 'Select Destination Station',
              items: stationListValue,
              selectedValue: _selectedDestinationStation,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Destination Station' : null,
              onChanged: (value) {
                setState(() {
                  _selectedDestinationStation = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Amount of Fare *',
              controller: _fareAmountController,
              hintText: 'Enter Amount of Fare',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Fare Amount' : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Serial No *',
              controller: _serialNoController,
              hintText: 'Enter Serial No',
              keyboardType: TextInputType.number,
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Serial No' : null,
            ),
          ],
        ),
      ),
    );
  }
} 