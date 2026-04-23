import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:om_appcart/feature/failure/controller/station_controller.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/utils/responsive_helper.dart';
import '../../constants/app_data.dart';
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



class CreateFailureScreen extends StatefulWidget {
  const CreateFailureScreen({Key? key}) : super(key: key);

  @override
  _CreateFailureScreenState createState() => _CreateFailureScreenState();
}

class _CreateFailureScreenState extends State<CreateFailureScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
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
  String? _selectedEquipmentNumber;
  String? _selectedActualFailureOccurrence;
  String? _selectedPersonResponsible;

  // Add this field for the date time picker
  DateTime? _selectedDateTime;

  // TextEditingController for the failure description
  final TextEditingController _failureDescriptionController = TextEditingController();

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

  DateTime? _selectedFailureCompletedDate;

  // Add state variables for Train Cancel and Train Replace dropdowns
  String? _trainCancelYesNo;
  String? _trainReplaceYesNo;

  int _currentStep = 0;

  List<Widget> get _steps => [
    _buildFailureDetailsStep(),
    _buildPassengersAffectedStep(),
    _buildBeforeAttachmentsStep(),
  ];

  // Add this list for step titles
  final List<String> _stepTitles = [
    "Failure Details",
    "Passengers Affected",
    "Attachments",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
    _tabController.dispose();
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
      if (_tabController.index != 2) {
        _tabController.animateTo(2);
      }
    } else if (scrollOffset >= serviceAffectedLocalPosition - threshold) {
      if (_tabController.index != 1) {
        _tabController.animateTo(1);
      }
    } else if (_tabController.index != 0) {
        _tabController.animateTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: 'Create Failure',
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
                    onSelected: (_) => _submitForm(),
                  ),
              ],
            ),
          ),
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
                            Column(
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
                          SizedBox(height: 16),
                                  CustDropdown(
                                    label: 'Equipment Number',
                                    hint: 'Select equipment number',
                                    items: equipmentNumberListValue,
                                    selectedValue: _selectedEquipmentNumber,
                                    validator: (value) => value == null || value.isEmpty ? 'Please Select Equipment Number' : null,
                                    onChanged: (value) { setState(() { _selectedEquipmentNumber = value; }); },
                                  ),
                          SizedBox(height: 16),
                                  CustDateTimePicker(
                                    label: 'Actual Failure Completed On',
                                    hint: 'Select date and time',
                                    selectedDateTime: _selectedDateTime,
                                    validator: (value) => _selectedDateTime == null ? 'Please Select Date & Time' : null,
                                    onDateTimeSelected: (dateTime) {
                                      setState(() {
                                        _selectedDateTime = dateTime;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 16),
                                  CustDropdown(label: 'Person Responsible', hint: 'Select person', items: personList, selectedValue: _selectedPersonResponsible, validator: (value) => value == null || value.isEmpty ? 'Please Select Person Responsible' : null, onChanged: (value) { setState(() { _selectedPersonResponsible = value; }); }),
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
                          ],
                        ),
                ),
    );
  }

  Widget _buildPassengersAffectedStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: AccordionCard(
                        title: _stepTitles[_currentStep],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustText(
                                        name: "Is passengers affected?",
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
                                              CustomTextField(
                                                label: 'Train Delay In Min',
                                                controller: TextEditingController(),
                                                keyboardType: TextInputType.number, 
                                                hintText: '0'
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
                                                label: 'Train Delay',
                                                controller: TextEditingController(), 
                                                keyboardType: TextInputType.number,
                                                hintText: '0'
                                              ),
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
                                                hintText: 'Train Withdrawal'
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
                                                hintText: 'Train Deboarded'
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
                                              hintText: 'Train Withdrawal'
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
                                    hintText: 'Train Deboarded'
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

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      Get.dialog(CustomDialog("Saved Successfully."));
    }
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




class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final dashPath = Path();
    final dashCount = (size.width / (dashWidth + dashSpace)).floor();
    final dashCountVertical = (size.height / (dashWidth + dashSpace)).floor();

    // Draw horizontal dashes
    for (int i = 0; i < dashCount; i++) {
      final startX = i * (dashWidth + dashSpace);
      dashPath.moveTo(startX, 0);
      dashPath.lineTo(startX + dashWidth, 0);
    }

    // Draw vertical dashes
    for (int i = 0; i < dashCountVertical; i++) {
      final startY = i * (dashWidth + dashSpace);
      dashPath.moveTo(size.width, startY);
      dashPath.lineTo(size.width, startY + dashWidth);
    }

    // Draw bottom horizontal dashes
    for (int i = 0; i < dashCount; i++) {
      final startX = i * (dashWidth + dashSpace);
      dashPath.moveTo(startX, size.height);
      dashPath.lineTo(startX + dashWidth, size.height);
    }

    // Draw left vertical dashes
    for (int i = 0; i < dashCountVertical; i++) {
      final startY = i * (dashWidth + dashSpace);
      dashPath.moveTo(0, startY);
      dashPath.lineTo(0, startY + dashWidth);
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
