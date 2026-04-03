import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/constants/app_data.dart';
import 'package:flutter/services.dart';

import '../widgets/accordion_card.dart';
import '../widgets/cust_button.dart';
import '../widgets/cust_date_time_picker.dart';
import '../widgets/cust_dropdown.dart';
import '../widgets/cust_radio.dart';
import '../widgets/cust_text.dart';
import '../widgets/cust_textfield.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_dialog.dart';

class DivyangForm extends StatefulWidget {
  const DivyangForm({Key? key}) : super(key: key);

  @override
  State<DivyangForm> createState() => _DivyangFormState();
}

class _DivyangFormState extends State<DivyangForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedStation;
  DateTime? _selectedDate;
  final TextEditingController _trainNoController = TextEditingController();
  final TextEditingController _passengerNameController = TextEditingController();
  TimeOfDay? _reportingTime;
  final TextEditingController _contactNoController = TextEditingController();
  String? _selectedDisabilityType;
  String? _selectedWheelchairProvided;
  final TextEditingController _ageController = TextEditingController();
  String? _selectedGender;
  String? _selectedInformToStation;
  final TextEditingController _scInformedController = TextEditingController();
  String? _selectedJourneyStartStation;
  String? _selectedJourneyEndStation;
  final TextEditingController _remarkController = TextEditingController();

  int _currentStep = 0;
  final List<String> _stepTitles = [
    "Passenger Details",
    "Journey Details",
    "Other Details",
  ];

  final List<String> disabilityTypeList = [
    "Divyang", "Visually Impared", "Patients/Other"
  ];
  final List<String> wheelchairProvidedList = ["Yes", "No"];
  final List<String> genderList = ["Male", "Female", "others"];
  final List<String> stationLocationList = [
    "KHP -  Khapri ", "NAP - New Airport ", "SAT -  Airport South ", "NAO -  Airport ", "UJR -  Ujjwal Nagar ", "JIN -  Jaiprakash Nagar ", "CQE -  Charapati Square ", "AJS -  Ajni Square ", "RHC -  Rahate Colony ", "CSS -  Congress Nagar ", "SIT -  SitaBuldi ", "ZOM -  Zero Mile ", "KPR -  Kasturchand Park ", "GSE -  GaddiGodam Square ", "KVW -  Kadvi Chowk ", "IDK -  Indora Chowk ", "NAR -  Nari Road ", "AQS -  Automotive Square ", "PJG -  Prajapati Nagar ", "LON - LOKMANYA", "BAN - BANSI NAGAR", "VAN - VASUDEO NAGR", "RRR - RACHNA RING ROAD", "SBN - SUBHASH NAGAR", "DPC - DHARAMPETH COLLEGE", "LAD - LAD SQUARE", "SNS - SHANKAR NAGAR", "IOE - INSTITUTE OF ENGINEER", "JRS - JHANSI RANI SQUARE", "CMS - COTTON MARKET SQUARE", "NRS - NAGPUR RAILWAY STATION", "DVC - DOSAR VAISHYA CHOWK", "AGN - AGRASEN", "CHC - CHITAROLI CHOWK", "TEE - TELEPHONE EXCHANGE", "AMC - AMBEDKAR CHOWK", "VDC - VAISHNO DEVI CHOWK", "SIT - SitaBuldi"
  ];

  List<Widget> get _steps => [
    _buildPassengerDetailsStep(),
  ];

  @override
  void dispose() {
    _trainNoController.dispose();
    _passengerNameController.dispose();
    _contactNoController.dispose();
    _ageController.dispose();
    _scInformedController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "Divyang Form"),
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

  Widget _buildPassengerDetailsStep() {
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
            CustDateTimePicker(
              label: 'Date *',
              hint: 'DD/MM/YYYY',
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
            CustText(
              name: 'Train No.',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _trainNoController,
              hintText: 'Enter Train No.',
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
              name: 'Contact No',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _contactNoController,
              hintText: 'Enter Contact No',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Type of Disability',
              hint: 'Select Disability Type',
              items: disabilityTypeList,
              selectedValue: _selectedDisabilityType,
              onChanged: (value) {
                setState(() {
                  _selectedDisabilityType = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Wheelchair Provided? *',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            Row(
              children: wheelchairProvidedList.map((option) => Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CustRadio<String>(
                  value: option,
                  groupValue: _selectedWheelchairProvided ?? '',
                  label: option,
                  onChanged: (value) {
                    setState(() {
                      _selectedWheelchairProvided = value;
                    });
                  },
                ),
              )).toList(),
            ),
            FormField<String>(
              validator: (value) => _selectedWheelchairProvided == null ? 'Please Select Wheelchair Option' : null,
              builder: (state) => state.hasError 
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(state.errorText!, style: TextStyle(color: AppColors.red, fontSize: 12)),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Age',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _ageController,
              hintText: 'Enter Age',
              keyboardType: TextInputType.number,
              maxLength: 3,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  final intValue = int.tryParse(newValue.text);
                  if (intValue != null && intValue > 100) {
                    return oldValue;
                  }
                  return newValue;
                }),
              ],
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Gender *',
              hint: 'Select Gender',
              items: genderList,
              selectedValue: _selectedGender,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Gender' : null,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Inform To Station *',
              hint: 'Select Station',
              items: stationLocationList,
              selectedValue: _selectedInformToStation,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Inform To Station' : null,
              onChanged: (value) {
                setState(() {
                  _selectedInformToStation = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'SC to whom informed *',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _scInformedController,
              hintText: 'Enter SC to whom informed',
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter SC Name' : null,
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Journey Start Station *',
              hint: 'Select Start Station',
              items: stationLocationList,
              selectedValue: _selectedJourneyStartStation,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Start Station' : null,
              onChanged: (value) {
                setState(() {
                  _selectedJourneyStartStation = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Journey End Station *',
              hint: 'Select End Station',
              items: stationLocationList,
              selectedValue: _selectedJourneyEndStation,
              validator: (value) => value == null || value.isEmpty ? 'Please Select End Station' : null,
              onChanged: (value) {
                setState(() {
                  _selectedJourneyEndStation = value;
                });
              },
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
              maxLength: 200,
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Remark' : null,
            ),
          ],
        ),
      ),
    );
  }

} 