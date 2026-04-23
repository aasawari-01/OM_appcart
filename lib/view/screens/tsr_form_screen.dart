import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:om_appcart/constants/app_data.dart';
import 'package:om_appcart/feature/failure/controller/station_controller.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/utils/responsive_helper.dart';

import '../widgets/accordion_card.dart';
import '../widgets/cust_button.dart';
import '../widgets/cust_date_time_picker.dart';
import '../widgets/cust_dropdown.dart';
import '../widgets/cust_text.dart';
import '../widgets/cust_textfield.dart';
import '../widgets/custom_app_bar.dart';
import 'tsr_details_screen.dart';


class TSRFormScreen extends StatefulWidget {
  const TSRFormScreen({Key? key}) : super(key: key);

  @override
  State<TSRFormScreen> createState() => _TSRFormScreenState();
}

class _TSRFormScreenState extends State<TSRFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // TSR Details
  String? _selectedDepartment;
  DateTime? _selectedImpositionDate;
  TimeOfDay? _selectedImpositionTime;
  String? _selectedLine;
  String? _selectedDirection;
  String? _selectedStationFrom;
  String? _selectedStationTo;
  int _speedRestriction = 0;
  final TextEditingController _specificTSRLocationController = TextEditingController();
  final TextEditingController _reasonForTSRController = TextEditingController();
  DateTime? _selectedExpectedClosingDateTime;

  final List<String> departmentList = ["OCC", "Maintenance", "Operations", "Safety"];
  final List<String> lineList = ["Line A", "Line B", "Line C", "Line D"];
  final List<String> directionList = ["North", "South", "East", "West", "Both"];

  @override
  void dispose() {
    _specificTSRLocationController.dispose();
    _reasonForTSRController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: 'TSR Details',
        showDrawer: false,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      backgroundColor: AppColors.bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ResponsiveHelper.spacing(context, 8)),
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: AccordionCard(
                  title: "TSR Details",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row 1: Department, Imposition Date, Imposition Time
                      Row(
                        children: [
                          Expanded(
                            child: CustDropdown(
                              label: 'Department *',
                              hint: 'Select Department',
                              items: departmentList,
                              selectedValue: _selectedDepartment,
                              validator: (value) => value == null || value.isEmpty ? 'Please Select Department' : null,
                              onChanged: (value) {
                                setState(() {
                                  _selectedDepartment = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustDateTimePicker(
                              label: 'Imposition Date *',
                              hint: 'DD/MM/YYYY',
                              pickerType: CustDateTimePickerType.date,
                              selectedDateTime: _selectedImpositionDate,
                              validator: (value) => _selectedImpositionDate == null ? 'Please Select Date' : null,
                              onDateTimeSelected: (date) {
                                setState(() {
                                  _selectedImpositionDate = date;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustDateTimePicker(
                              label: 'Imposition Time *',
                              hint: 'HH:mm',
                              pickerType: CustDateTimePickerType.time,
                              selectedDateTime: _selectedImpositionTime != null
                                  ? DateTime(2024, 1, 1, _selectedImpositionTime!.hour, _selectedImpositionTime!.minute)
                                  : null,
                              validator: (value) => _selectedImpositionTime == null ? 'Please Select Time' : null,
                              onDateTimeSelected: (dateTime) {
                                if (dateTime != null) {
                                  setState(() {
                                    _selectedImpositionTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
  
                      // Row 2: Line, Direction
                      Row(
                        children: [
                          Expanded(
                            child: CustDropdown(
                              label: 'Line *',
                              hint: 'Select',
                              items: lineList,
                              selectedValue: _selectedLine,
                              validator: (value) => value == null || value.isEmpty ? 'Please Select Line' : null,
                              onChanged: (value) {
                                setState(() {
                                  _selectedLine = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustDropdown(
                              label: 'Direction *',
                              hint: 'Select Direction',
                              items: directionList,
                              selectedValue: _selectedDirection,
                              validator: (value) => value == null || value.isEmpty ? 'Please Select Direction' : null,
                              onChanged: (value) {
                                setState(() {
                                  _selectedDirection = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
  
                      // Row 3: Station From, Station To, Speed Restriction
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() {
                              final stationController = Get.find<StationController>();
                              return CustDropdown(
                                label: 'Station From *',
                                hint: 'Select Station',
                                items: stationController.stations.isEmpty ? stationListValue : stationController.stationNames,
                                selectedValue: _selectedStationFrom,
                                validator: (value) => value == null || value.isEmpty ? 'Please Select Station' : null,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedStationFrom = value;
                                  });
                                },
                              );
                            }),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Obx(() {
                              final stationController = Get.find<StationController>();
                              return CustDropdown(
                                label: 'Station To *',
                                hint: 'Select Station',
                                items: stationController.stations.isEmpty ? stationListValue : stationController.stationNames,
                                selectedValue: _selectedStationTo,
                                validator: (value) => value == null || value.isEmpty ? 'Please Select Station' : null,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedStationTo = value;
                                  });
                                },
                              );
                            }),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustText(
                                  name: 'Temporary Speed Restriction (In Kmph) *',
                                  size: 1.8,
                                  fontWeightName: FontWeight.w500,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (_speedRestriction > 0) {
                                          setState(() {
                                            _speedRestriction--;
                                          });
                                        }
                                      },
                                      icon: const Icon(Icons.remove_circle_outline),
                                      color: AppColors.textColor3,
                                    ),
                                    Expanded(
                                      child: CustomTextField(
                                        controller: TextEditingController(
                                          text: _speedRestriction.toString().padLeft(2, '0'),
                                        ),
                                        hintText: '00',
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        validator: (value) => value == "00" ? 'Restriction required' : null,
                                        onChanged: (value) {
                                          final intValue = int.tryParse(value) ?? 0;
                                          setState(() {
                                            _speedRestriction = intValue;
                                          });
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _speedRestriction++;
                                        });
                                      },
                                      icon: const Icon(Icons.add_circle_outline),
                                      color: AppColors.textColor3,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
  
                      // Row 4: Specific TSR Location (full width)
                      CustText(
                        name: 'Specific TSR Location *',
                        size: 1.8,
                        fontWeightName: FontWeight.w500,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _specificTSRLocationController,
                        hintText: 'Enter Location',
                        validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Location' : null,
                      ),
                      const SizedBox(height: 16),
  
                      // Row 5: Reason For TSR * (full width)
                      CustText(
                        name: 'Reason For TSR *',
                        size: 1.8,
                        fontWeightName: FontWeight.w500,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _reasonForTSRController,
                        hintText: 'Enter Reason',
                        maxLines: 4,
                        validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Reason' : null,
                      ),
                      const SizedBox(height: 16),
  
                      // Row 6: Expected Date & Time of Closing *
                      CustDateTimePicker(
                        label: 'Expected Date & Time of Closing *',
                        hint: 'DD/MM/YYYY',
                        pickerType: CustDateTimePickerType.date,
                        selectedDateTime: _selectedExpectedClosingDateTime,
                        validator: (value) => _selectedExpectedClosingDateTime == null ? 'Please Select Date' : null,
                        onDateTimeSelected: (date) {
                          setState(() {
                            _selectedExpectedClosingDateTime = date;
                          });
                        },
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
                CustOutlineButton(name: "Cancel",
                    size: 30,
                    onSelected: (_) => Navigator.pop(context)),
                CustButton(
                  name: 'Save',
                  size: 30,
                  onSelected: (_) {
                    if (_formKey.currentState?.validate() ?? false) {
                      _saveTSR();
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

  void _saveTSR() {
    // TODO: Implement save logic
    print('TSR Details saved');
    // Navigate to TSR Details screen after saving
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TSRDetailsScreen(),
      ),
    );
  }
} 