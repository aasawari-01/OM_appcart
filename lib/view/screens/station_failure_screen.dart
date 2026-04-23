import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:om_appcart/feature/failure/controller/station_controller.dart';
import 'package:om_appcart/constants/colors.dart';

import '../../constants/app_data.dart';
import '../../utils/responsive_helper.dart';
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


class StationFailureScreen extends StatefulWidget {
  const StationFailureScreen({Key? key}) : super(key: key);

  @override
  _StationFailureScreenState createState() => _StationFailureScreenState();
}

class _StationFailureScreenState extends State<StationFailureScreen> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  bool _isPassengerDeboarding = false;
  bool _isServiceAffected = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey _scrollViewKey = GlobalKey();

  // State variables for dropdowns
  String? _selectedPriority;
  String? _selectedDepartment;
  String? _selectedLocation;
  String? _selectedFunctionalLocation;
  String? _selectedActualFailureOccurrence;
  String? _selectedFailureReportedBy;

  // New state variables for dates
  DateTime? _selectedFailureOccurrenceDate;
  DateTime? _selectedFailureCompletedDate;

  // TextEditingController for the failure description
  final TextEditingController _failureDescriptionController = TextEditingController();

  // New TextEditingControllers for Sub Location and System
  String? _selectedSubLocation;
  final TextEditingController _systemController = TextEditingController();

  // Keys for each section to measure their positions
  final GlobalKey _failureDetailsKey = GlobalKey();
  final GlobalKey _serviceAffectedKey = GlobalKey();
  final GlobalKey _beforeAttachmentsKey = GlobalKey();

  // Store section heights
  double _failureDetailsHeight = 0;
  double _serviceAffectedHeight = 0;
  double _beforeAttachmentsHeight = 0;

  // Add this new state variable
  List<dynamic> _attachedFiles = [];

  bool failureDetailsExpanded = true;
  bool serviceAffectedExpanded = false;
  bool beforeAttachmentsExpanded = false;

  // Add state variables for Train Cancel and Train Replace dropdowns
  String? _trainCancelYesNo;
  String? _trainReplaceYesNo;

  int _currentStep = 0;
  final List<String> _stepTitles = [
    "Failure Details",
    "Passengers Affected",
    "Attachments",
  ];

  List<Widget> get _steps => [
    _buildFailureDetailsStep(),
    _buildPassengersAffectedStep(),
    _buildBeforeAttachmentsStep(),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    // Schedule a post-frame callback to measure section heights
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureSectionHeights();
    });
  }

  void _measureSectionHeights() {
    final failureDetailsContext = _failureDetailsKey.currentContext;
    final serviceAffectedContext = _serviceAffectedKey.currentContext;
    final beforeAttachmentsContext = _beforeAttachmentsKey.currentContext;

    if (failureDetailsContext != null) {
      final box = failureDetailsContext.findRenderObject() as RenderBox?;
      if (box != null) {
        _failureDetailsHeight = box.size.height;
      }
    }

    if (serviceAffectedContext != null) {
      final box = serviceAffectedContext.findRenderObject() as RenderBox?;
      if (box != null) {
        _serviceAffectedHeight = box.size.height;
      }
    }

    if (beforeAttachmentsContext != null) {
      final box = beforeAttachmentsContext.findRenderObject() as RenderBox?;
      if (box != null) {
        _beforeAttachmentsHeight = box.size.height;
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;

    final scrollOffset = _scrollController.offset;

    final RenderBox? scrollViewRenderBox = _scrollViewKey.currentContext?.findRenderObject() as RenderBox?;

    if (scrollViewRenderBox == null) return;

    double getLocalOffset(GlobalKey key) {
      final RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        // Convert global offset of the section to local offset within the scroll view
        final Offset localOffset = scrollViewRenderBox.globalToLocal(box.localToGlobal(Offset.zero));
        return localOffset.dy;
      }
      return double.infinity;
    }

    final failureDetailsLocalPosition = getLocalOffset(_failureDetailsKey);
    final serviceAffectedLocalPosition = getLocalOffset(_serviceAffectedKey);
    final beforeAttachmentsLocalPosition = getLocalOffset(_beforeAttachmentsKey);

    const double threshold = 50.0;

    if (scrollOffset >= beforeAttachmentsLocalPosition - threshold) {
      if (!beforeAttachmentsExpanded) {
        setState(() {
          beforeAttachmentsExpanded = true;
        });
      }
    } else if (scrollOffset >= serviceAffectedLocalPosition - threshold) {
      if (!serviceAffectedExpanded) {
        setState(() {
          serviceAffectedExpanded = true;
        });
      }
    } else if (!failureDetailsExpanded) {
      setState(() {
        failureDetailsExpanded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: 'Create Station Failure',
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
                    // size: 30,
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
          SizedBox(height: ResponsiveHelper.spacing(context, 8))
        ],
      ),
    );
  }

  Widget _buildFailureDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            child: AccordionCard(
                              title: _stepTitles[_currentStep],
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
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedPriority = value;
                                            });
                                          },
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
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedDepartment = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Obx(() => CustDropdown(
                                        label: 'Location',
                                        hint: 'Select location',
                                        items: stationListValue,
                                        selectedValue: _selectedLocation,
                                        validator: (value) => value == null || value.isEmpty ? 'Please Select Location' : null,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedLocation = value;
                                          });
                                        },
                                      )),
                                  const SizedBox(height: 16),
                                  Obx(() => CustDropdown(
                                        label: 'Functional Location',
                                        hint: 'Select functional location',
                                        items: stationListValue,
                                        selectedValue: _selectedFunctionalLocation,
                                        validator: (value) => value == null || value.isEmpty ? 'Please Select Functional Location' : null,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedFunctionalLocation = value;
                                          });
                                        },
                                      )),
                                  const SizedBox(height: 16),
                                  Obx(() => CustDropdown(
                                        label: 'Sub Location',
                                        hint: 'Sub Location',
                                        items: stationListValue,
                                        selectedValue: _selectedSubLocation,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedSubLocation = value;
                                          });
                                        },
                                      )),
                                                      SizedBox(height: 16),
                                  CustomTextField(
                                    label: 'System',
                                    controller: _systemController,
                                    hintText: 'Enter system',
                                    validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter System' : null,
                                  ),
                                                      SizedBox(height: 16),
                                        CustDateTimePicker(
                                    label: 'Actual Failure Occurrence Date',
                                          hint: 'Select date and time',
                                          selectedDateTime: _selectedFailureOccurrenceDate,
                                          validator: (value) => _selectedFailureOccurrenceDate == null ? 'Please Select Date & Time' : null,
                                          onDateTimeSelected: (dateTime) {
                                      setState(() {
                                              _selectedFailureOccurrenceDate = dateTime;
                                      });
                                    },
                                  ),
                                                      SizedBox(height: 16),
                                  CustDropdown(
                                    label: 'Failure Reported By',
                                    hint: 'Select person',
                                    items:personList,
                                    selectedValue: _selectedFailureReportedBy,
                                    validator: (value) => value == null || value.isEmpty ? 'Please Select Person' : null,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedFailureReportedBy = value;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 16),
                                  CustomTextField(
                                    label: 'Failure Description',
                                    controller: _failureDescriptionController,
                                    hintText: 'Description',
                                    maxLines: 4,
                                    validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Failure Description' : null,
                                  ),
                                ],
                              ),
                            ),
    );
  }

  Widget _buildPassengersAffectedStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child:AccordionCard(
                        title: _stepTitles[_currentStep],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustText(
                                        name: "Is passengers affected",
                                    size: 1.8,
                                    fontWeightName: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  YesNoToggle(
                                    value: _isServiceAffected,
                                    onChanged: (val) {
                                      setState(() {
                                        _isServiceAffected = val;
                                      });
                                    },
                                  ),
                                ],
                              ),
                          SizedBox(height: 8),
                            if (_isServiceAffected)
                            Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustText(
                                                name: "Train Delay In Min",
                                                size: 1.8,
                                                fontWeightName: FontWeight.w500,
                                              ),
                                          SizedBox(height: 8),
                                              CustomTextField(controller: TextEditingController(), hintText: '0'),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustText(
                                                name: "Train Delay",
                                                size: 1.8,
                                                fontWeightName: FontWeight.w500,
                                              ),
                                          SizedBox(height: 8),
                                              CustomTextField(controller: TextEditingController(), hintText: '0'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustDropdown(
                                            label: "Train Cancel",
                                            hint: "Train Cancel",
                                            items: ["Yes", "No"],
                                            selectedValue: _trainCancelYesNo,
                                            onChanged: (value) {
                                              setState(() {
                                                _trainCancelYesNo = value;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: CustDropdown(
                                            label: "Train Replace",
                                            hint: "Train Replace",
                                            items: ["Yes", "No"],
                                            selectedValue: _trainReplaceYesNo,
                                            onChanged: (value) {
                                              setState(() {
                                                _trainReplaceYesNo = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustomTextField(
                                                label: 'Train Withdrawal',
                                                controller: TextEditingController(),
                                                hintText: 'Train Withdrawal',
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustomTextField(
                                                label: 'Train Deboarded',
                                                controller: TextEditingController(),
                                                hintText: 'Train Deboarded',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                SizedBox(height: 16),
                                    CustText(
                                          name: "Passengers Deboarding",
                                      size: 1.8,
                                      fontWeightName: FontWeight.w500,
                                    ),
                                SizedBox(height: 8),
                                    YesNoToggle(
                                      value: _isPassengerDeboarding,
                                      onChanged: (val) {
                                        setState(() {
                                          _isPassengerDeboarding = val;
                                        });
                                      },
                                    ),
                                if(_isPassengerDeboarding)...[
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustDropdown(
                                          label: "Train Replace",
                                          hint: "Train Replace",
                                          items: ["Yes", "No"],
                                          selectedValue: _trainReplaceYesNo,
                                          onChanged: (value) {
                                            setState(() {
                                              _trainReplaceYesNo = value;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomTextField(
                                              label: 'Train Withdrawal',
                                              controller: TextEditingController(),
                                              hintText: 'Train Withdrawal',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  CustomTextField(
                                    label: 'Train Deboarded',
                                    controller: TextEditingController(),
                                    hintText: 'Train Deboarded',
                                  ),
                                ]
                              ],
                            ),
                        ],
                                            ),
                      ),
    );
  }

  Widget _buildBeforeAttachmentsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: AccordionCard(
        title: _stepTitles[_currentStep],
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

  // Helper method to build file list item
  Widget _buildFileListItem(String fileName, String fileSize) {
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
            decoration: BoxDecoration(color: AppColors.containerColor,borderRadius: BorderRadius.circular(5)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustText(name: fileName, size: 1.7,color: AppColors.black,),
                CustText(name: fileSize, size: 1.4,color: Colors.black,),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20, color: Colors.grey), // Remove icon
            onPressed: () {
              // TODO: Implement remove file logic
            },
          ),
        ],
      ),
    );
  }
}



