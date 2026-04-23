import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/utils/responsive_helper.dart';

import '../../constants/app_data.dart';
import '../widgets/accordion_card.dart';
import '../widgets/cust_button.dart';
import '../widgets/cust_date_time_picker.dart';
import '../widgets/cust_dropdown.dart';
import '../widgets/cust_text.dart';
import '../widgets/cust_textfield.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/file_upload_section.dart';

enum InspectionPlan { scheduled, unscheduled }

class InspectionScreen extends StatefulWidget {
  const InspectionScreen({Key? key}) : super(key: key);

  @override
  _InspectionScreenState createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  InspectionPlan _selectedPlan = InspectionPlan.unscheduled;
  String? _selectedDepartment;
  String? _selectedInspectionType;
  String? _selectedFrequency;
  DateTime? _selectedInspectionScheduledDate;
  String? _selectedInspectionBy;

  String? _selectedFromStation;
  String? _selectedToStation;
  String? _selectedTrain;
  String? _selectedDepot;
  String? _selectedLocationOfTrain;
  String? _selectedDccName;

  final List<String> trainList = ['Train 1', 'Train 2', 'Train 3'];
  final List<String> depotList = ['Depot 1', 'Depot 2', 'Depot 3'];
  final List<String> locationOfTrainList = [
    'Location 1',
    'Location 2',
    'Location 3'
  ];
  final List<String> dccNameList = ['DCC 1', 'DCC 2', 'DCC 3'];

  // Map of department to inspection types
  final Map<String, List<String>> departmentInspectionTypes = {
    'Signalling': [
      'Foot plate',
      'On-board',
      'Stations-SE',
      'Wayside',
      'OCC/BOCC',
      'General Inspection',
      'Stations-JE',
    ],
    'Rolling Stock': [
      'General Inspection',
    ],
    'Track': [
      'Curve Inspection',
      'General Inspection',
      'Creep Measurement',
      'Temperature Monitoring',
      'OMS',
      'Pilot Train Inspection',
      'Cab Inspection',
      'Foot Ins',
      'Toe Load',
      'Turn Out',
      'Buffer Stop',
      'Ultrasonic Flaw Detection USFD',
      'Inspection of floating track - slab with spring',
      'scissor crossover inspection',
      'atweld inspection',
    ],
    'Information Technology': [
      'General Inspection',
    ],
    'Civil': [
      'General Inspection',
      'Detailed station inspection',
      'Inspection of Gaddigodaam OWG Bridge',
      'Routine Station Inspection',
      'Routine Inspection of Viaduct',
      'Detailed Inspection of Structural Steelworks of Station',
      'Detailed Inspection of Structural Steel Bridge',
      'Routine Inspection of Structural Steelworks of Station',
      'Routine Inspection of Structural Steel Bridge',
      'Detailed Depot Inspection Report',
      'Routine Depot Inspection Report',
      'Routine Premonsoon Test',
      'Inspection of Structural Steel View Cutter',
      'Inspection of Structural Signal Post Platform',
      'Inspection Details of POT PTFE/ Spherical Bearing',
      'Special Inspection of Viaduct',
      'Inspection Details of Elastomeric Bearing',
      'Detailed Inspection of Viaduct',
    ],
    'Human Resource': [
      'General Inspection',
    ],
    'Operation Chief Controller': [
      'General Inspection',
    ],
    'Crew Management System': [
      'General Inspection',
    ],
  };

  // Map of department and inspection type to required fields
  final Map<String, Map<String, List<String>>> inspectionFields = {
    'Signalling': {
      'Foot plate': ['From Station', 'To Station'],
      'On-board': ['Train', 'Depot', 'Location of Train', 'DCC Name'],
      'Stations-SE': ['Station'],
      'Wayside': ['From Station', 'To Station'],
      'OCC/BOCC': ['Default'],
      'General Inspection': ['Default'],
      'Stations-JE': ['Station'],
    },
    'Rolling Stock': {
      'General Inspection': ['Default'],
    },
    'Track': {
      'Curve Inspection': ['Track Functional Location *'],
      'General Inspection': ['Default'],
      'Creep Measurement': [
        'Start Kilometer',
        'End Kilometer',
        'From Station',
        'To Station'
      ],
      'Temperature Monitoring': ['Station'],
      'OMS': ['Line', 'Line (Up/Down)'],
      'Pilot Train Inspection': ['From Station', 'To Station'],
      'Cab Inspection': ['From Station', 'To Station'],
      'Foot Ins': ['Station'],
      'Toe Load': [
        'Station',
        'Start Kilometer',
        'End Kilometer',
        'From Station',
        'To Station'
      ],
      'Turn Out': ['Default'],
      'Buffer Stop': ['Station', 'Functional Location'],
      'Ultrasonic Flaw Detection USFD': [
        'Name of Operator',
        'InspectionUFDI Plan',
        'Station',
        'Start Kilometer',
        'End Kilometer',
        'From Station',
        'To Station'
      ],
      'Inspection of floating track - slab with spring': [
        'Station',
        'Line (Up/Down)'
      ],
      'scissor crossover inspection': ['Default'],
      'atweld inspection': [
        'Depot',
        'Line',
        'Track Structure',
        'From Station',
        'To Station',
        'Other Lines(depot)'
      ],
    },
    'Information Technology': {
      'General Inspection': ['Default'],
    },
    'Civil': {
      'General Inspection': ['Default'],
      'Detailed station inspection': [
        'Station',
        'Reach',
        'Month',
        'Start Date',
        'End Date'
      ],
      'Inspection of Gaddigodaam OWG Bridge': [
        'Reach',
        'Last Inspection Date',
        'start date',
        'end date',
        'span between pier no',
        'type of girder',
        'effective length',
        'CRN No'
      ],
      'Routine Station Inspection': [
        'Station',
        'Month',
        'Start Date',
        'End Date'
      ],
      'Routine Inspection of Viaduct': [
        'section (7-07 chainage)',
        'span no',
        'pier no',
        'viaduct structure type'
      ],
      'Detailed Inspection of Structural Steelworks of Station': [
        'station',
        'Reach',
        'Last Inspection Date',
        'start date',
        'end date'
      ],
      'Detailed Inspection of Structural Steel Bridge': [
        'Name of Section',
        'Last Inspection Date',
        'Start Date',
        'End Date',
        'No of Girders',
        'Span Between Pier No',
        'From Station',
        'To Station',
        'Type of Girder',
        'Effective Length',
        'CRN No.'
      ],
      'Routine Inspection of Structural Steelworks of Station': [
        'station',
        'Reach',
        'Last Inspection Date',
        'start date',
        'end date'
      ],
      'Routine Inspection of Structural Steel Bridge': [
        'Reach',
        'Last Inspection Date',
        'Start Date',
        'End Date',
        'No of Girders',
        'Span Between Pier No',
        'From Station',
        'To Station',
        'Type of Girder',
        'Effective Length'
      ],
      'Detailed Depot Inspection Report': [
        'Station',
        'Building Structure',
        'Month',
        'Start Date',
        'End Date'
      ],
      'Routine Depot Inspection Report': [
        'Station',
        'Building Structure',
        'Month',
        'Start Date',
        'End Date'
      ],
      'Routine Premonsoon Test': ['Station'],
      'Inspection of Structural Steel View Cutter': [
        'Name of Section',
        'From Station',
        'To Station',
        'Span No',
        'Span Length',
        'Last Inspection Date',
        'Start Date',
        'End Date'
      ],
      'Inspection of Structural Signal Post Platform': [
        'Name of Section',
        'From Station',
        'To Station',
        'Span No',
        'No. of Signal Post Platforms',
        'Last Inspection Date',
        'Start Date',
        'End Date'
      ],
      'Inspection Details of POT PTFE/ Spherical Bearing': ['Default'],
      'Special Inspection of Viaduct': [
        'Reach',
        'From Station',
        'To Station',
        'Viaduct Category',
        'Location',
        'Span No',
        'Pier No',
        'Viaduct Structure Type',
        'Start Date',
        'End Date',
        'ORN No',
        'URN No.'
      ],
      'Inspection Details of Elastomeric Bearing': [
        'Reach',
        'From Station',
        'To Station',
        'Viaduct Category',
        'Location',
        'Span No.',
        'Pier No.',
        'Viaduct Structure Type',
        'Entry Date',
        'ORN No'
      ],
      'Detailed Inspection of Viaduct': [
        'Span No.',
        'Pier No.',
        'Viaduct Structure Type'
      ],
    },
    'Human Resource': {
      'General Inspection': ['Default'],
    },
    'Operation Chief Controller': {
      'General Inspection': ['Default'],
    },
    'Crew Management System': {
      'General Inspection': ['Default'],
    },
  };

  int _currentStep = 0;
  final List<String> _stepTitles = [
    "Inspection Details",
  ];

  List<Widget> get _steps => [
        _buildInspectionDetailsStep(),
      ];

  // Controllers for dynamic fields
  final Map<String, TextEditingController> _fieldControllers = {};
  List<dynamic> _attachedFiles = [];

  List<String> getSelectedFields() {
    if (_selectedDepartment != null && _selectedInspectionType != null) {
      return inspectionFields[_selectedDepartment!]
              ?[_selectedInspectionType!] ??
          [];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: 'Create Inspection',
        showDrawer: false,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: ResponsiveHelper.spacing(context, 8),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: _steps[_currentStep],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: ResponsiveHelper.spacing(context, 8),
                horizontal: ResponsiveHelper.spacing(context, 16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustButton(
                  name: 'Submit',
                  onSelected: (p0) {
                    if (_formKey.currentState?.validate() ?? false) {
                      Get.dialog(CustomDialog("Saved Successfully."));
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: ResponsiveHelper.spacing(context, 8),
          )
        ],
      ),
    );
  }

  Widget _buildInspectionDetailsStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
          top: ResponsiveHelper.spacing(context, 16),
          left: 12,
          right: 12,
          bottom: 12),
      child: AccordionCard(
        title: _stepTitles[_currentStep],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustText(
              name: "Inspection Plan",
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            Row(
              children: [
                _buildCircularCheckbox(
                  label: 'Scheduled',
                  value: InspectionPlan.scheduled,
                  groupValue: _selectedPlan,
                  onChanged: (InspectionPlan? value) {
                    setState(() {
                      _selectedPlan = value!;
                    });
                  },
                ),
                _buildCircularCheckbox(
                  label: 'Unscheduled',
                  value: InspectionPlan.unscheduled,
                  groupValue: _selectedPlan,
                  onChanged: (InspectionPlan? value) {
                    setState(() {
                      _selectedPlan = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 16)),
            CustDropdown(
              label: 'Department',
              hint: 'Select',
              items: departmentInspectionTypes.keys.toList(),
              selectedValue: _selectedDepartment,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Department' : null,
              onChanged: (value) {
                setState(() {
                  _selectedDepartment = value;
                  _selectedInspectionType =
                      null; // Reset inspection type when department changes
                });
              },
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 16)),
            CustomTextField(
              label: "Designation",
              controller: TextEditingController(
                  text: 'Default Account Holder Designation'),
              hintText: 'Default Account Holder Designation',
              readOnly: true,
              fillColor: AppColors.textFieldFillColor,
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 16)),
            CustDropdown(
              label: 'Inspection Type',
              hint: 'Select inspection type',
              items: _selectedDepartment != null &&
                      departmentInspectionTypes[_selectedDepartment!] != null
                  ? departmentInspectionTypes[_selectedDepartment!]!
                  : departmentInspectionTypes["Signalling"]!,
              selectedValue: _selectedInspectionType,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Inspection Type' : null,
              onChanged: (value) {
                setState(() {
                  _selectedInspectionType = value;
                });
              },
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 16)),
            CustDropdown(
              label: 'Frequency',
              hint: 'Select frequency',
              items: const [
                'Daily',
                'Weekly',
                'Monthly',
                'Quarterly',
                'Half-Yearly',
                'Yearly'
              ],
              selectedValue: _selectedFrequency,
              onChanged: (value) {
                setState(() {
                  _selectedFrequency = value;
                });
              },
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 16)),
            if (_selectedPlan == InspectionPlan.scheduled) ...[
              CustDateTimePicker(
                label: 'Inspection Scheduled Date',
                hint: 'Select date',
                pickerType: CustDateTimePickerType.date,
                selectedDateTime: _selectedInspectionScheduledDate,
                validator: (value) => _selectedInspectionScheduledDate == null ? 'Please Select Date' : null,
                onDateTimeSelected: (date) {
                  setState(() {
                    _selectedInspectionScheduledDate = date;
                  });
                },
              ),
              SizedBox(height: ResponsiveHelper.spacing(context, 16)),
              CustDropdown(
                label: 'Inspection By',
                hint: 'Select inspection by',
                items: const ['User 1', 'User 2', 'User 3'],
                selectedValue: _selectedInspectionBy,
                validator: (value) => value == null || value.isEmpty ? 'Please Select Inspector' : null,
                onChanged: (value) {
                  setState(() {
                    _selectedInspectionBy = value;
                  });
                },
              ),
              ...getSelectedFields().map((field) {
                if (field == 'Default') {
                  return SizedBox.shrink();
                }
                if (field == 'From Station') {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ResponsiveHelper.spacing(context, 16)),
                      CustDropdown(
                        label: field,
                        hint: 'Select $field',
                        items: stationListValue,
                        selectedValue: _selectedFromStation,
                        validator: (value) => (value == null || value.isEmpty) ? 'Please Select $field' : null,
                        onChanged: (value) {
                          setState(() {
                            _selectedFromStation = value;
                          });
                        },
                      ),
                    ],
                  );
                }

                if (field == 'To Station') {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ResponsiveHelper.spacing(context, 16)),
                      CustDropdown(
                        label: field,
                        hint: 'Select $field',
                        items: stationListValue,
                        selectedValue: _selectedToStation,
                        validator: (value) => (value == null || value.isEmpty) ? 'Please Select $field' : null,
                        onChanged: (value) {
                          setState(() {
                            _selectedToStation = value;
                          });
                        },
                      ),
                    ],
                  );
                }
                if (field == 'Train') {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ResponsiveHelper.spacing(context, 16)),
                      CustDropdown(
                        label: field,
                        hint: 'Select $field',
                        items: trainList,
                        selectedValue: _selectedTrain,
                        validator: (value) => (value == null || value.isEmpty) ? 'Please Select $field' : null,
                        onChanged: (value) {
                          setState(() {
                            _selectedTrain = value;
                          });
                        },
                      ),
                    ],
                  );
                }
                if (field == 'Depot') {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ResponsiveHelper.spacing(context, 16)),
                      CustDropdown(
                        label: field,
                        hint: 'Select $field',
                        items: depotList,
                        selectedValue: _selectedDepot,
                        validator: (value) => (value == null || value.isEmpty) ? 'Please Select $field' : null,
                        onChanged: (value) {
                          setState(() {
                            _selectedDepot = value;
                          });
                        },
                      ),
                    ],
                  );
                }
                if (field == 'Location of Train') {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ResponsiveHelper.spacing(context, 16)),
                      CustDropdown(
                        label: field,
                        hint: 'Select $field',
                        items: locationOfTrainList,
                        selectedValue: _selectedLocationOfTrain,
                        validator: (value) => (value == null || value.isEmpty) ? 'Please Select $field' : null,
                        onChanged: (value) {
                          setState(() {
                            _selectedLocationOfTrain = value;
                          });
                        },
                      ),
                    ],
                  );
                }
                if (field == 'DCC Name') {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ResponsiveHelper.spacing(context, 16)),
                      CustDropdown(
                        label: field,
                        hint: 'Select $field',
                        items: dccNameList,
                        selectedValue: _selectedDccName,
                        validator: (value) => (value == null || value.isEmpty) ? 'Please Select $field' : null,
                        onChanged: (value) {
                          setState(() {
                            _selectedDccName = value;
                          });
                        },
                      ),
                    ],
                  );
                }
                _fieldControllers.putIfAbsent(
                    field, () => TextEditingController());
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ResponsiveHelper.spacing(context, 16)),
                    CustomTextField(
                      label: field,
                      controller: _fieldControllers[field]!,
                      hintText: 'Enter $field',
                      validator: (value) => (value == null || value.trim().isEmpty) ? 'Please Enter $field' : null,
                    ),
                  ],
                );
              }).toList(),
            ],
            SizedBox(height: ResponsiveHelper.spacing(context, 16)),
            CustText(
              name: "Attachment",
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
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

  Widget _fileRow(String filename, String size) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppColors.dividerColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Container(
            height: ResponsiveHelper.height(context, 40),
            width: ResponsiveHelper.height(context, 40),
            decoration: BoxDecoration(
                color: AppColors.containerColor,
                borderRadius: BorderRadius.circular(5)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustText(
                  name: filename,
                  size: 1.7,
                  color: AppColors.black,
                ),
                CustText(
                  name: size,
                  size: 1.4,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20, color: Colors.grey),
            // Remove icon
            onPressed: () {
              // TODO: Implement remove file logic
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCircularCheckbox({
    required String label,
    required InspectionPlan value,
    required InspectionPlan groupValue,
    required ValueChanged<InspectionPlan?> onChanged,
  }) {
    final bool isSelected = (value == groupValue);
    return Expanded(
      child: InkWell(
        onTap: () => onChanged(value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24, // Size of the circular checkbox
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.appBarColor : Colors.grey,
                    width: 2,
                  ),
                  color:
                      isSelected ? AppColors.appBarColor : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
              SizedBox(width: 8),
              CustText(name: label, size: 1.6),
            ],
          ),
        ),
      ),
    );
  }
}
