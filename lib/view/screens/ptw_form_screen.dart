import 'package:flutter/material.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/constants/app_data.dart';

import '../../utils/responsive_helper.dart';
import '../widgets/accordion_card.dart';
import '../widgets/cust_button.dart';
import '../widgets/cust_date_time_picker.dart';
import '../widgets/cust_dropdown.dart';
import '../widgets/cust_radio.dart';
import '../widgets/cust_text.dart';
import '../widgets/cust_textfield.dart';
import '../widgets/custom_app_bar.dart';

class PTWFormScreen extends StatefulWidget {
  const PTWFormScreen({Key? key}) : super(key: key);

  @override
  State<PTWFormScreen> createState() => _PTWFormScreenState();
}

class _PTWFormScreenState extends State<PTWFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // PTW Request Details
  String _selectedRequestType ="Scheduled"; // Scheduled/Emergency
  String? _selectedPTWType;
  String? _selectedVehicleMovement;
  String? _selectedNatureOfWork;
  final TextEditingController _workDescriptionController = TextEditingController();

  // Line and Depot Details
  String? _selectedLocationType = "Line";// Line/Depot
  String? _selectedLine;
  String? _selectedDepot;
  String? _selectedLocationFrom;
  String? _selectedLocationTo;
  String? _selectedDepotLocationFrom;
  String? _selectedDepotLocationTo;
  String? _selectedImpactOnRevenue;

  // Staff Details
  String? _selectedUploadType; // Single/Bulk Upload

  // PTW Staff Date Details
  DateTime? _selectedFromDateTime;
  DateTime? _selectedToDateTime;
  String? _selectedArea;
  String? _selectedSubLocation;
  String? _selectedEntryPoint;
  String? _selectedPriority;
  String? _selectedExitPoint;

  int _currentStep = 0;
  final List<String> _stepTitles = [
    "PTW Request Details",
    "Line and Depot Details",
    "Staff Details",
    "PTW Staff Date Details",
  ];

  final List<String> requestTypeList = ["Scheduled", "Emergency"];
  final List<String> ptwTypeList = ["With Shadow Power Block", "Without Shadow Power Block", "Without Power Block"];
  final List<String> vehicleMovementList = ["Yes", "No"];
  final List natureOfWorkList = [{ "id": 1, "value": 'Train Testing' },
      { "id": 2, "value": 'To Handlling' },
      { "id": 3, "value": 'Inspection' },
      { "id": 4, "value": 'CMV Movement' },
      { "id": 5, "value": 'Trolly Movement' },
      { "id": 6, "value":  'MockDrill' },
      { "id": 7, "value":  'CyclicCheck' },
      { "id": 8, "value":  'Modification'},
      { "id": 9, "value":  'Cleaning' },
      { "id": 10, "value":  'Main Line Fault' },
      { "id": 11, "value":  'DepotFault' },
      { "id": 12, "value":  'Overhaul'},
      { "id": 13, "value":  'Other' }
      ];
  final List<String> locationTypeList = ["Line", "Depot"];
  final List<String> lineList = ["Line 1", "Line 2"];
  final List<String> depotList = ["Depot 1", "Depot 2"];
  final List<String> impactOnRevenueList = ["Yes", "No"];
  final List<Map<String, dynamic>> areaList = [
    {'id': 1, 'value': 'Mainline'},
    {'id': 2, 'value': 'Depot'},
    {'id': 3, 'value': 'Station'},
    {'id': 4, 'value': 'Workshop'},
    {'id': 5, 'value': 'Technical Room'}
  ];
  final List<String> subLocationList = ['Up Line',
    'Down line',
    'Both Up Line & Down line',
    'Up Line Plateform',
    'Down Line Plateform'
    'Both Up Line Plateform & Down Line Plateform'];
  final List<String> priorityList = ['Low', 'Medium', 'High', 'Very High'];

  List<Widget> get _steps => [
    _buildPTWRequestDetailsStep(),
    _buildLineAndDepotDetailsStep(),
    _buildStaffDetailsStep(_selectedLocationType),
    _buildPTWStaffDateDetailsStep(),
  ];

  @override
  void dispose() {
    _workDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          title: 'PTW Request Form',
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          _submitForm();
                        }
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPTWRequestDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: AccordionCard(
        title: _stepTitles[_currentStep],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustText(
              name: 'Type of Request *',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            Row(
              children: requestTypeList.map((option) => Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CustRadio<String>(
                  value: option,
                  groupValue: _selectedRequestType ?? '',
                  label: option,
                  onChanged: (value) {
                    setState(() {
                      _selectedRequestType = value!;
                    });
                  },
                ),
              )).toList(),
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Type Of PTW *',
              hint: 'Select Type Of PTW',
              items: ptwTypeList,
              selectedValue: _selectedPTWType,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Type Of PTW' : null,
              onChanged: (value) {
                setState(() {
                  _selectedPTWType = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustText(
              name: "Vehicle Movement Required *",
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 8)),
            Row(
              children: vehicleMovementList.map((option) => Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CustRadio<String>(
                  value: option,
                  groupValue: _selectedVehicleMovement ?? '',
                  label: option,
                  onChanged: (value) {
                    setState(() {
                      _selectedVehicleMovement = value;
                    });
                  },
                ),
              )).toList(),
            ),
            FormField<String>(
              validator: (value) => _selectedVehicleMovement == null ? 'Please Select Vehicle Movement Option' : null,
              builder: (state) => state.hasError 
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(state.errorText!, style: TextStyle(color: AppColors.red, fontSize: 12)),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Nature Of Work *',
              hint: 'Select Nature Of Work',
              items: natureOfWorkList.map((item) => item['value'] as String).toList(),
              selectedValue: _selectedNatureOfWork,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Nature Of Work' : null,
              onChanged: (value) {
                setState(() {
                  _selectedNatureOfWork = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Work Description *',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _workDescriptionController,
              hintText: 'Enter Work Description',
              maxLines: 4,
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Work Description' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineAndDepotDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: AccordionCard(
        title: _stepTitles[_currentStep],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustText(
              name: 'Location Type *',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            Row(
              children: locationTypeList.map((option) => Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CustRadio<String>(
                  value: option,
                  groupValue: _selectedLocationType ?? '',
                  label: option,
                  onChanged: (value) {
                    setState(() {
                      _selectedLocationType = value;
                    });
                  },
                ),
              )).toList(),
            ),
            const SizedBox(height: 16),
            if (_selectedLocationType == "Line") ...[
              CustDropdown(
                label: 'Line *',
                hint: 'Select Line',
                items: lineList,
                selectedValue: _selectedLine,
                validator: (value) => _selectedLocationType == "Line" && (value == null || value.isEmpty) ? 'Please Select Line' : null,
                onChanged: (value) {
                  setState(() {
                    _selectedLine = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustDropdown(
                label: 'Location/Station From *',
                hint: 'Select Depot Location/Station From',
                items: stationListValue,
                selectedValue: _selectedLocationFrom,
                validator: (value) => _selectedLocationType == "Line" && (value == null || value.isEmpty) ? 'Please Select Location From' : null,
                onChanged: (value) {
                  setState(() {
                    _selectedLocationFrom = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustDropdown(
                label: 'Location/Station To *',
                hint: 'Select Depot Location/Station To',
                items: stationListValue,
                selectedValue: _selectedLocationTo,
                validator: (value) => _selectedLocationType == "Line" && (value == null || value.isEmpty) ? 'Please Select Location To' : null,
                onChanged: (value) {
                  setState(() {
                    _selectedLocationTo = value;
                  });
                },
              ),
              const SizedBox(height: 16),
            ],
            if (_selectedLocationType == "Depot") ...[
              CustDropdown(
                label: 'Depot *',
                hint: 'Select Depot',
                items: depotList,
                selectedValue: _selectedDepot,
                validator: (value) => _selectedLocationType == "Depot" && (value == null || value.isEmpty) ? 'Please Select Depot' : null,
                onChanged: (value) {
                  setState(() {
                    _selectedDepot = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustDropdown(
                label: 'Depot Location/Station From *',
                hint: 'Select Depot Location/Station From',
                items: stationListValue,
                selectedValue: _selectedDepotLocationFrom,
                validator: (value) => _selectedLocationType == "Depot" && (value == null || value.isEmpty) ? 'Please Select Depot Location From' : null,
                onChanged: (value) {
                  setState(() {
                    _selectedDepotLocationFrom = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustDropdown(
                label: 'Depot Location/Station To *',
                hint: 'Select Depot Location/Station To',
                items: stationListValue,
                selectedValue: _selectedDepotLocationTo,
                validator: (value) => _selectedLocationType == "Depot" && (value == null || value.isEmpty) ? 'Please Select Depot Location To' : null,
                onChanged: (value) {
                  setState(() {
                    _selectedDepotLocationTo = value;
                  });
                },
              ),
              const SizedBox(height: 16),
            ],
            CustText(
              name: 'Impact On Revenue/Operation *',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            Row(
              children: impactOnRevenueList.map((option) => Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CustRadio<String>(
                  value: option,
                  groupValue: _selectedImpactOnRevenue ?? '',
                  label: option,
                  onChanged: (value) {
                    setState(() {
                      _selectedImpactOnRevenue = value!;
                    });
                  },
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffDetailsStep(_selectedLocationType) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: AccordionCard(
        title: _stepTitles[_currentStep],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs for Single Upload and Bulk Upload
            // Container(
            //   decoration: BoxDecoration(
            //     border: Border.all(color: AppColors.textFieldColor),
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: Row(
            //     children: uploadTypeList.map((type) {
            //       final isSelected = _selectedUploadType == type;
            //       return Expanded(
            //         child: GestureDetector(
            //           onTap: () {
            //             setState(() {
            //               _selectedUploadType = type;
            //             });
            //           },
            //           child: Container(
            //             padding: const EdgeInsets.symmetric(vertical: 12),
            //             decoration: BoxDecoration(
            //               color: isSelected ? AppColors.textColor3 : Colors.transparent,
            //               borderRadius: BorderRadius.circular(8),
            //             ),
            //             child: Center(
            //               child: CustText(
            //                 name: type,
            //                 size: 1.6,
            //                 color: isSelected ? Colors.white : AppColors.textColor,
            //                 fontWeightName: FontWeight.w500,
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     }).toList(),
            //   ),
            // ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: CustButton(
                name: 'Add Staff Details',
                size: 50,
                onSelected: (bool _) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddStaffDetailsDialog(selectedLocationType: _selectedLocationType);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPTWStaffDateDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: AccordionCard(
        title: _stepTitles[_currentStep],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustDateTimePicker(
              label: 'From Date & Time *',
              hint: 'DD/MM/YYYY HH:mm',
              pickerType: CustDateTimePickerType.dateTime,
              selectedDateTime: _selectedFromDateTime,
              validator: (value) => _selectedFromDateTime == null ? 'Please Select From Date & Time' : null,
              onDateTimeSelected: (dateTime) {
                setState(() {
                  _selectedFromDateTime = dateTime;
                  if (_selectedToDateTime != null && dateTime != null && _selectedToDateTime!.isBefore(dateTime)) {
                    _selectedToDateTime = null;
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            AbsorbPointer(
              absorbing: _selectedFromDateTime == null,
              child: Opacity(
                opacity: _selectedFromDateTime == null ? 0.5 : 1.0,
                child: CustDateTimePicker(
                  label: 'To Date & Time *',
                  hint: _selectedFromDateTime == null ? 'Select From Date & Time first' : 'DD/MM/YYYY HH:mm',
                  pickerType: CustDateTimePickerType.dateTime,
                  selectedDateTime: _selectedToDateTime,
                  validator: (value) => _selectedToDateTime == null ? 'Please Select To Date & Time' : null,
                  onDateTimeSelected: (dateTime) {
                    if (dateTime == null) return;

                    if (_selectedFromDateTime != null && dateTime.isAfter(_selectedFromDateTime!)) {
                      setState(() {
                        _selectedToDateTime = dateTime;
                      });
                    } else {
                      // Show error message if selected date is before or equal to from date
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('To Date & Time must be after From Date & Time'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Area *',
              hint: 'Select Area',
              items: areaList.map((item) => item['value'] as String).toList(),
              selectedValue: _selectedArea,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Area' : null,
              onChanged: (value) {
                setState(() {
                  _selectedArea = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Sub Location *',
              hint: 'Select Sub Location',
              items: subLocationList,
              selectedValue: _selectedSubLocation,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Sub Location' : null,
              onChanged: (value) {
                setState(() {
                  _selectedSubLocation = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Entry Point *',
              hint: 'Select Entry Point',
              items: stationListValue,
              selectedValue: _selectedEntryPoint,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Entry Point' : null,
              onChanged: (value) {
                setState(() {
                  _selectedEntryPoint = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Priority *',
              hint: 'Select Priority',
              items: priorityList,
              selectedValue: _selectedPriority,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Priority' : null,
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Exit Point *',
              hint: 'Select Exit Point',
              items: stationListValue,
              selectedValue: _selectedExitPoint,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Exit Point' : null,
              onChanged: (value) {
                setState(() {
                  _selectedExitPoint = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    // TODO: Implement submit logic
    print('PTW Form submitted');
  }
}

class AddStaffDetailsDialog extends StatefulWidget {
  final String? selectedLocationType;
  
  const AddStaffDetailsDialog({
    Key? key,
    this.selectedLocationType,
  }) : super(key: key);

  @override
  State<AddStaffDetailsDialog> createState() => _AddStaffDetailsDialogState();
}

class _AddStaffDetailsDialogState extends State<AddStaffDetailsDialog> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedOrganization;
  final TextEditingController _designationController = TextEditingController();
  String? _selectedRole;
  String? _selectedStaffEntryPoint;

  final List<String> organizationList = [
    'Maha Metro',
    'Other'
  ];
  final List<String> roleList = ['EPIC','PTW Coordinator','Shift Supervisor'];
  final List<String> staffEntryPointList = [
    'Entry Point 1',
    'Entry Point 2',
    'Entry Point 3',
    'Entry Point 4'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _designationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15, bottom: 10, right: 15),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: CustText(
              name: "Add Staff Details",
              size: 1.8,
              color: AppColors.textColor3,
              fontWeightName: FontWeight.w500,
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 32,
                    runSpacing: 24,
                    children: [
                      SizedBox(
                        width: 320,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustText(
                              name: 'Name',
                              size: 1.8,
                              fontWeightName: FontWeight.w500,
                            ),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: _nameController,
                              hintText: 'Enter name',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 320,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustDropdown(
                              label: 'Organization',
                              hint: 'Select Organization',
                              items: organizationList,
                              selectedValue: _selectedOrganization,
                              onChanged: (value) {
                                setState(() {
                                  _selectedOrganization = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 320,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustText(
                              name: 'Designation',
                              size: 1.8,
                              fontWeightName: FontWeight.w500,
                            ),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: _designationController,
                              hintText: 'Enter Designation',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 320,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustDropdown(
                              label: 'Role',
                              hint: 'Select Role',
                              items: roleList,
                              selectedValue: _selectedRole,
                              onChanged: (value) {
                                setState(() {
                                  _selectedRole = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      if(widget.selectedLocationType == "Line")...[
                        SizedBox(
                          width: 320,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustDropdown(
                                label: 'Staff Entry Point',
                                hint: 'Select Staff Entry Point',
                                items: stationListValue,
                                selectedValue: _selectedStaffEntryPoint,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedStaffEntryPoint = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GreyButton(name: "Cancel",size: 100, onSelected: (p0) => Navigator.pop(context),),
                      SizedBox(width: ResponsiveHelper.spacing(context, 8)),
                      CustButton(
                        name: "Save",
                        size: 100,
                        onSelected: (p0) {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 