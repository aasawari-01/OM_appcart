import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/utils/responsive_helper.dart';

import 'dart:io';
import 'package:om_appcart/view/widgets/cust_text.dart';

import '../../constants/app_data.dart';
import '../widgets/accordion_card.dart';
import '../widgets/cust_button.dart';
import '../widgets/cust_date_time_picker.dart';
import '../widgets/cust_dropdown.dart';
import '../widgets/cust_textfield.dart';
import '../widgets/cust_toggle.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/file_upload_section.dart';


class OCCFailureScreen extends StatefulWidget {
  const OCCFailureScreen({Key? key}) : super(key: key);

  @override
  State<OCCFailureScreen> createState() => _OCCFailureScreenState();
}

class _OCCFailureScreenState extends State<OCCFailureScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // OCC Failure Details
  String? _selectedPriority;
  String? _selectedDepartment;
  String? _selectedLocation;
  String? _selectedSystem;
  String? _selectedReportedBy;
  DateTime? _selectedFailureDate;
  DateTime? _selectedRestoredDate;
  String? _selectedReportedTo;
  String? _selectedLine;
  String? _selectedSubLocation;
  final TextEditingController _failureDescriptionController = TextEditingController();
  final TextEditingController _systemController = TextEditingController();
  final TextEditingController _trainIdController = TextEditingController();
  String? _selectedTrainSet;
  DateTime? _selectedFailureCompletedDate;
  String? _selectedFailureReportedBy;

  // Operation Impacted
  bool _isOperationImpacted = false;
  String? _selectedImpactType;
  final TextEditingController _impactDurationController = TextEditingController();

  // Trip Affected
  bool _isTripAffected = false;
  final TextEditingController _tripDelayUplineController = TextEditingController();
  final TextEditingController _tripDelayDownlineController = TextEditingController();
  final TextEditingController _tripDelayInMinController = TextEditingController();
  String? _tripCancel;
  final TextEditingController _tripWithdrawalController = TextEditingController();
  String? _tripOperatorName;

  // Train Replace
  bool _isTrainReplace = false;
  String? _trainReplace;
  String? _selectedReplaceWith;
  TimeOfDay? _replacedTime;

  // Passenger Deboarding
  bool _isPassengerDeboarding = false;
  final TextEditingController _trainDeboardedController = TextEditingController();

  // Passenger Affected
  bool _isPassengerAffected = false;
  final TextEditingController _numPassengerAffectedController = TextEditingController();
  final TextEditingController _trappedDurationController = TextEditingController();
  final TextEditingController _rescuedDurationController = TextEditingController();
  final TextEditingController _wayOfRescueController = TextEditingController();

  // Attachments
  List<File> _attachedFiles = [];

  // Accordion states
  bool failureDetailsExpanded = true;
  bool operationImpactedExpanded = false;
  bool passengerAffectedExpanded = false;
  bool attachmentsExpanded = false;

  int _currentStep = 0;
  final List<String> _stepTitles = [
    "OCC Failure Details",
    "Trip Affected",
    "Passengers Affected",
    "Attachments",
  ];

  final ScrollController _tripAffectedScrollController = ScrollController();
  final GlobalKey _passengerDeboardingKey = GlobalKey();

  List<Widget> get _steps => [
    _buildFailureDetailsStep(),
    _buildTripAffectedStep(),
    _buildPassengersAffectedStep(),
    _buildAttachmentsStep(),
  ];

  @override
  void dispose() {
    _failureDescriptionController.dispose();
    _systemController.dispose();
    _impactDurationController.dispose();
    _tripDelayUplineController.dispose();
    _tripDelayDownlineController.dispose();
    _tripDelayInMinController.dispose();
    _tripWithdrawalController.dispose();
    _trainDeboardedController.dispose();
    _numPassengerAffectedController.dispose();
    _trappedDurationController.dispose();
    _rescuedDurationController.dispose();
    _wayOfRescueController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: 'OCC Failure',
        showDrawer: false,
        isForm: true,
        currentStep: _currentStep,
        totalSteps: _steps.length,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ResponsiveHelper.spacing(context, 8)),
           SizedBox(height: ResponsiveHelper.spacing(context, 8)),
          Expanded(
            child: Form(
              key: _formKey,
              child: _steps[_currentStep],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.spacing(context, 8), horizontal: ResponsiveHelper.spacing(context, 16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  CustOutlineButton(
                    name: 'Back',
                    onSelected: (_) => setState(() => _currentStep--),
                  ),
                if (_currentStep < _steps.length - 1)
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CustButton(
                        name: 'Next',
                        onSelected: (_) {
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() => _currentStep++);
                          }
                        },
                      ),
                    ),
                  ),
                if (_currentStep == _steps.length - 1)
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
          SizedBox(height: ResponsiveHelper.spacing(context, 8)),
        ],
      ),
    );
  }

  Widget _buildFailureDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: AccordionCard(
        isExpanded: false,
        expanded: true,
        title: _stepTitles[_currentStep],
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustDropdown(
                    label: 'Priority',
                    hint: 'Priority',
                    items: priorityListValue,
                    selectedValue: _selectedPriority,
                    validator: (value) => value == null || value.isEmpty ? 'Please Select Priority' : null,
                    onChanged: (value) => setState(() => _selectedPriority = value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustDropdown(
                    label: 'Department',
                    hint: 'Department',
                    items: departmentListValue,
                    selectedValue: _selectedDepartment,
                    validator: (value) => value == null || value.isEmpty ? 'Please Select Department' : null,
                    onChanged: (value) => setState(() => _selectedDepartment = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Reported To',
              hint: 'Select Person',
              items: personList,
              selectedValue: _selectedReportedTo,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Person' : null,
              onChanged: (value) => setState(() => _selectedReportedTo = value),
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Line',
              hint: 'Select Line',
              items: const ['Line 1', 'Line 2'],
              selectedValue: _selectedLine,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Line' : null,
              onChanged: (value) => setState(() => _selectedLine = value),
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Location',
              hint: 'Select Location',
              items: stationListValue,
              selectedValue: _selectedLocation,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Location' : null,
              onChanged: (value) => setState(() => _selectedLocation = value),
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Sub Location',
              hint: 'Select Sub Location',
              items: stationListValue,
              selectedValue: _selectedSubLocation,
              onChanged: (value) => setState(() => _selectedSubLocation = value),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'System',
              controller: _systemController,
              hintText: 'Enter System',
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter System' : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Train Id',
              controller: _trainIdController,
              hintText: 'Enter Train Id',
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Train Set',
              hint: 'Select Train Set',
              items: const ['Set 1', 'Set 2'],
              selectedValue: _selectedTrainSet,
              onChanged: (value) => setState(() => _selectedTrainSet = value),
            ),
            const SizedBox(height: 16),
            CustDateTimePicker(
              label: 'Actual Failure Occurrence',
              hint: 'DD/MM/YYYY HH:mm',
              selectedDateTime: _selectedFailureDate,
              validator: (value) => _selectedFailureDate == null ? 'Please Select Date & Time' : null,
              onDateTimeSelected: (dateTime) => setState(() => _selectedFailureDate = dateTime),
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Failure Reported By',
              hint: 'Select Person',
              items: personList,
              selectedValue: _selectedFailureReportedBy,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Person' : null,
              onChanged: (value) => setState(() => _selectedFailureReportedBy = value),
            ),
            const SizedBox(height: 16),
            CustDateTimePicker(
              label: 'Actual Failure Completed On',
              hint: 'DD/MM/YYYY HH:mm',
              selectedDateTime: _selectedFailureCompletedDate,
              onDateTimeSelected: (dateTime) => setState(() => _selectedFailureCompletedDate = dateTime),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Failure Description',
              controller: _failureDescriptionController,
              hintText: 'Failure Description',
              maxLines: 2,
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Failure Description' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripAffectedStep() {
    return SingleChildScrollView(
      controller: _tripAffectedScrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: AccordionCard(
        isExpanded: false,
        expanded: true,
        title: _stepTitles[_currentStep],
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustText(
                  name: "Trip Affected?",
                  size: 1.8,
                  fontWeightName: FontWeight.w500,
                  color: Colors.black,
                ),
                YesNoToggle(
                  value: _isTripAffected,
                  onChanged: (val) {
                    setState(() {
                      _isTripAffected = val;
                    });
                  },
                ),
              ],
            ),
            if (_isTripAffected) ...[
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Trip Delay Upline',
                controller: _tripDelayUplineController,
                keyboardType: TextInputType.number,
                hintText: 'Enter Trip Delay Upline',
              ),
              const SizedBox(height: 16),
              CustDropdown(
                label: 'Trip Cancel',
                hint: 'Select Trip Cancel',
                items: const ['Yes', 'No'],
                selectedValue: _tripCancel,
                onChanged: (value) {
                  setState(() {
                    _tripCancel = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Trip Delay Downline',
                controller: _tripDelayDownlineController,
                keyboardType: TextInputType.number,
                hintText: 'Enter Trip Delay Downline',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Trip Delay In Min',
                controller: _tripDelayInMinController,
                keyboardType: TextInputType.number,
                hintText: 'Enter Trip Delay In Min',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Trip Withdrawal',
                controller: _tripWithdrawalController,
                hintText: 'Enter Trip Withdrawal',
              ),
              const SizedBox(height: 16),
              CustDropdown(
                label: 'Trip Operator Name',
                hint: 'Enter Trip Operator Name',
                items: const ['Operator1', 'Operator2'],
                selectedValue: _tripOperatorName,
                onChanged: (value) {
                  setState(() {
                    _tripOperatorName = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CustText(
                    name: "Train Replace",
                    size: 1.8,
                    fontWeightName: FontWeight.w500,
                  ),
                  const SizedBox(width: 8),
                  YesNoToggle(
                    value: _isTrainReplace,
                    onChanged: (val) {
                      setState(() {
                        _isTrainReplace = val;
                      });
                      if (val) {
                        Future.delayed(const Duration(milliseconds: 300), () {
                          _tripAffectedScrollController.animateTo(
                            _tripAffectedScrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                          );
                        });
                      }
                    },
                  ),
                ],
              ),
              if (_isTrainReplace) ...[
                const SizedBox(height: 8),
                CustDropdown(
                  label: 'Train Replace',
                  hint: 'Train Replace',
                  items: const ['Yes', 'No'],
                  selectedValue: _trainReplace,
                  onChanged: (value) {
                    setState(() {
                      _trainReplace = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustDropdown(
                  label: 'Replace With',
                  hint: 'Select Train',
                  items: const ['Train 1', 'Train 2'],
                  selectedValue: _selectedReplaceWith,
                  onChanged: (value) {
                    setState(() {
                      _selectedReplaceWith = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustDateTimePicker(
                  label: 'Replaced Time',
                  hint: 'HH:mm',
                  pickerType: CustDateTimePickerType.time,
                  selectedDateTime: _replacedTime != null
                      ? DateTime(2024, 1, 1, _replacedTime!.hour, _replacedTime!.minute)
                      : null,
                  onDateTimeSelected: (dateTime) {
                    if (dateTime != null) {
                      setState(() {
                        _replacedTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CustText(
                      name: "Passengers Deboarding",
                      size: 1.8,
                      fontWeightName: FontWeight.w500,
                    ),
                    const SizedBox(width: 8),
                    YesNoToggle(
                      value: _isPassengerDeboarding,
                      onChanged: (val) {
                        setState(() {
                          _isPassengerDeboarding = val;
                        });
                        if (val) {
                          Future.delayed(const Duration(milliseconds: 300), () {
                            final context = _passengerDeboardingKey.currentContext;
                            if (context != null) {
                              Scrollable.ensureVisible(
                                context,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeOut,
                                alignment: 0.1,
                              );
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
                if (_isPassengerDeboarding) ...[
                  const SizedBox(height: 8),
                  CustomTextField(
                    label: 'Train Deboarded',
                    controller: _trainDeboardedController,
                    hintText: 'Enter Train Deboarded',
                  ),
                ],
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPassengersAffectedStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: AccordionCard(
        isExpanded: false,
        expanded: true,
        title: _stepTitles[_currentStep],
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustText(
                  name: "Passengers Affected?",
                  size: 1.8,
                  fontWeightName: FontWeight.w500,
                  color: Colors.black,
                ),
                YesNoToggle(
                  value: _isPassengerAffected,
                  onChanged: (val) {
                    setState(() {
                      _isPassengerAffected = val;
                      print("_isPassengerAffected==$_isPassengerAffected");
                    });
                  },
                ),
              ],
            ),
            if (_isPassengerAffected) ...[
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Number Of Passengers Affected',
                controller: _numPassengerAffectedController,
                hintText: 'Enter Number Of Passengers Affected',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Trapped Duration',
                keyboardType: TextInputType.number,
                controller: _trappedDurationController,
                hintText: 'Enter Trapped Duration',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Rescued Duration',
                controller: _rescuedDurationController,
                hintText: 'Enter Rescued Duration',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Way Of Rescue',
                controller: _wayOfRescueController,
                hintText: 'Way Of Rescue',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: AccordionCard(
        isExpanded: false,
        expanded: true,
        title: _stepTitles[_currentStep],
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FileUploadSection(
              files: _attachedFiles,
              onFilesChanged: (files) {
                setState(() {
                  _attachedFiles = files;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
} 