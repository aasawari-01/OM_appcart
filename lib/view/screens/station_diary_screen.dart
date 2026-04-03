import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:om_appcart/controller/station_controller.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/utils/responsive_helper.dart';

import '../../constants/app_data.dart';
import '../widgets/accordion_card.dart';
import '../widgets/cust_button.dart';
import '../widgets/cust_date_time_picker.dart';
import '../widgets/cust_dropdown.dart';
import '../widgets/cust_radio.dart';
import '../widgets/cust_text.dart';
import '../widgets/cust_textfield.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_dialog.dart';


class StationDiaryScreen extends StatefulWidget {
  const StationDiaryScreen({Key? key}) : super(key: key);

  @override
  State<StationDiaryScreen> createState() => _StationDiaryScreenState();
}

class _StationDiaryScreenState extends State<StationDiaryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Diary Details
  String? _selectedStationName;
  String? _selectedDutyShift;
  DateTime? _selectedDate;
  final TextEditingController _controllerNameController = TextEditingController();

  // Outsourced Staff
  bool outsourcedExpanded = false;

  // Cash In Hand
  bool cashInHandExpanded = false;
  final TextEditingController _imprestController = TextEditingController();
  final TextEditingController _prevDayCashController = TextEditingController();
  final TextEditingController _cashToBankController = TextEditingController();
  final TextEditingController _depositSlip1Controller = TextEditingController();
  final TextEditingController _depositSlip2Controller = TextEditingController();
  final TextEditingController _depositSlip3Controller = TextEditingController();
  final TextEditingController _shiftEarningsController = TextEditingController();
  final TextEditingController _totalCashController = TextEditingController(text: '0');

  bool diaryDetailsExpanded = true;
  bool stockDetailsExpanded = false;
  bool statusOfEquipmentExpanded = true;
  bool eventDetailsExpanded = false;
  bool ptwDetailsExpanded = false;
  bool scHoChargeExpanded = false;
  final TextEditingController _scHoChargeController = TextEditingController();
  final TextEditingController _scHoDescriptionController = TextEditingController();

  final List<String> dutyShiftList = [
    'Morning',
    'Evening',
    'Night',
    "General"
  ];

  int _currentStep = 0;
  final List<String> _stepTitles = [
    "Diary Details",
    "Outsourced (FMS) Staff Details",
    "Cash In Hand",
    "Stock Details",
    "Status of Station Equipment",
    "Event Details",
    "PTW Details",
    "SC HO / Charge",
  ];

  List<Widget> get _steps => [
    _buildDiaryDetailsStep(),
    _buildOutsourcedStaffStep(),
    _buildCashInHandStep(),
    _buildStockDetailsStep(),
    _buildStatusOfEquipmentStep(),
    _buildEventDetailsStep(),
    _buildPTWDetailsStep(),
    _buildSCHoChargeStep(),
  ];

  @override
  void dispose() {
    _controllerNameController.dispose();
    _imprestController.dispose();
    _prevDayCashController.dispose();
    _cashToBankController.dispose();
    _depositSlip1Controller.dispose();
    _depositSlip2Controller.dispose();
    _depositSlip3Controller.dispose();
    _shiftEarningsController.dispose();
    _totalCashController.dispose();
    _scHoChargeController.dispose();
    _scHoDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: "Station Diary",
        isForm: true,
        currentStep: _currentStep,
        totalSteps: _steps.length,
      ),
      backgroundColor: AppColors.bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ResponsiveHelper.spacing(context, 8)),
           SizedBox(height: ResponsiveHelper.spacing(context, 8)),
          // Section header for current step
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
                    // size: 30,
                    onSelected: (_) {
                      if (_formKey.currentState?.validate() ?? false) {
                        Get.dialog(CustomDialog("Saved Successfully"));
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

  Widget _buildDiaryDetailsStep() {
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
            Obx(() => CustDropdown(
                  label: 'Station Name *',
                  hint: 'Select Station Name',
                  items: stationListValue,
                  selectedValue: _selectedStationName,
                  validator: (value) => value == null || value.isEmpty ? 'Please Select Station Name' : null,
                  onChanged: (value) {
                    setState(() {
                      _selectedStationName = value;
                    });
                  },
                )),
            const SizedBox(height: 16),
            CustText(
              name: 'Station Controller Name',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _controllerNameController,
              hintText: 'Enter Station Controller Name',
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Station Controller Name' : null,
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
          ],
        ),
      ),
    );
  }

  Widget _buildOutsourcedStaffStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: AccordionCard(
                      isExpanded: false,
                      expanded: true,
                      title: _stepTitles[_currentStep],
                      onTap: () {

                      },
                      child: SizedBox(
                        width: ResponsiveHelper.width(context, 200),
                        child: CustButton(
                          name: 'Add Staff Details',
                          size: 140,
                          onSelected: (p0) {
                            showDialog(
                              context: context,
                              builder: (context) => AddStaffDetailsDialog(),
                            );
                          },
                        ),
                      ),
                    ),
    );
  }

  Widget _buildCashInHandStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: AccordionCard(
                      isExpanded: false,
                      expanded: true,
                      title: _stepTitles[_currentStep],
                      onTap: () {

                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            label: 'Imprest',
                            controller: _imprestController,
                            hintText: 'Enter Imprest',
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Previous Day Shift Cash Takeover',
                            controller: _prevDayCashController,
                            hintText: 'Enter Previous Day Shift Cash Takeover',
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Cash To Bank',
                            controller: _cashToBankController,
                            hintText: 'Enter Cash To Bank',
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Deposit Slip No 1',
                            controller: _depositSlip1Controller,
                            hintText: 'Enter Deposit Slip No 1',
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Deposit Slip No 2',
                            controller: _depositSlip2Controller,
                            hintText: 'Enter Deposit Slip No 2',
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Deposit Slip No 3',
                            controller: _depositSlip3Controller,
                            hintText: 'Enter Deposit Slip No 3',
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Shift Earnings',
                            controller: _shiftEarningsController,
                            hintText: 'Enter Shift Earnings',
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Total Cash',
                            controller: _totalCashController,
                            hintText: '0',
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildStockDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: AccordionCard(
                      isExpanded: false,
                      expanded: true,
                      title: _stepTitles[_currentStep],
                      onTap: () {},
                      child: SizedBox(
                        width: ResponsiveHelper.width(context, 200),
                        child: CustButton(
                          name: 'Add Stock Details',
                          size: 140,
                          onSelected: (p0) {
                            showDialog(
                              context: context,
                              builder: (context) => const AddStockDetailsDialog(),
                            );
                          },
                        ),
                      ),
                    ),
    );
  }

  int expandedIndex = 0;
  Widget _buildStatusOfEquipmentStep() {
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
                          SizedBox(
                            width: ResponsiveHelper.width(context, 200),
                            child: CustButton(
                              name: 'Add Status',
                              size: 140,
                              onSelected: (p0) async {
                                final updatedItem = await showDialog<Map<String, dynamic>>(
                                  context: context,
                                  builder: (context) => UpdateEquipmentStatusDialog(dataList: dataList),
                                );

                                if (updatedItem != null) {
                                  setState(() {
                                    // Replace existing item in dataList
                                    final index = dataList.indexWhere(
                                          (item) => item['category']['value'] == updatedItem['category']['value'],
                                    );
                                    if (index != -1) {
                                      dataList[index] = updatedItem;
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                           SizedBox(height: ResponsiveHelper.spacing(context, 16)),
                          SizedBox(height: ResponsiveHelper.spacing(context, 16)),

                          dataList.where((item) => item['isSaved'] == true).isEmpty
                              ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CustText(
                                name: "No status added yet",
                                size: 1.6,
                                color: AppColors.textColor3,
                                fontWeightName: FontWeight.w500,
                              ),
                            ),
                          )
                              :Column(
                            children: List.generate(
                                dataList.where((item) =>
                                item['isSaved'] == true
                                ).length, (index) {
                              final filteredList = dataList.where((item) =>
                              item['isSaved'] == true
                              ).toList();

                              final item = filteredList[index];
                              return Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.white1,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.textFieldColor),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustText(
                                        name: "${item['category']['value']}",
                                        fontWeightName: FontWeight.bold,
                                        size: 1.6,
                                      ),
                                      Row(
                                        children: [
                                          CustText(name: "Work Status : ", size: 1.4),
                                          CustText(
                                            name: item['workStatus']['value'] == 1
                                                ? "Working"
                                                : "Not Working",
                                            size: 1.4,
                                            fontWeightName: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                      CustText(
                                        name: "Remark: ${item['remark']['value']}",
                                        size: 1.4,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            ),
                          )
                          // Table header
                          // Container(
                          //   color: Colors.grey.shade200,
                          //   padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          //   child: Row(
                          //     children: const [
                          //       Expanded(flex: 1, child: Text('Sr No.', style: TextStyle(fontWeight: FontWeight.bold))),
                          //       Expanded(flex: 3, child: Text('Category', style: TextStyle(fontWeight: FontWeight.bold))),
                          //       Expanded(flex: 2, child: Text('Work Status', style: TextStyle(fontWeight: FontWeight.bold))),
                          //       Expanded(flex: 4, child: Text('Remark', style: TextStyle(fontWeight: FontWeight.bold))),
                          //     ],
                          //   ),
                          // ),
                          // Table rows
                          // ...List.generate(dataList.length, (index) {
                          //   final item = dataList[index];
                          //   final isExpanded = expandedIndex == index;
                          //   return AccordionCard(
                          //     isExpanded: true,
                          //     expanded: isExpanded,
                          //     onTap: () {
                          //       print('tapped');
                          //       setState(() {
                          //         if (expandedIndex == index) {
                          //           expandedIndex = -1; // collapse
                          //         } else {
                          //           expandedIndex = index; // expand clicked one
                          //         }
                          //       });
                          //     },
                          //     title: "${item['srNo']['value']} ${item['category']['value']}",
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Row(
                          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             CustText(name: 'Work Status', fontWeightName: FontWeight.bold,size: 1.6,),
                          //             Transform.scale(
                          //               scale: 0.70,
                          //               child: Switch(
                          //                 activeColor: AppColors.green,
                          //                  thumbColor: WidgetStatePropertyAll(AppColors.white1),
                          //                 trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
                          //                 value: item['workStatus']['value'] == 1,
                          //                 onChanged: (val) {
                          //                   setState(() {
                          //                     item['workStatus']['value'] = val ? 1 : 0;
                          //                   });
                          //                 },
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //         CustText(name: 'Remark', fontWeightName: FontWeight.bold,size: 1.6,),
                          //         TextField(
                          //           decoration: const InputDecoration(
                          //             border: OutlineInputBorder(),
                          //             isDense: true,
                          //             contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          //           ),
                          //           minLines: 1,
                          //           maxLines: 2,
                          //           controller: TextEditingController(text: item['remark']['value'])
                          //             ..selection = TextSelection.collapsed(offset: item['remark']['value'].length),
                          //           onChanged: (val) {
                          //             item['remark']['value'] = val;
                          //           },
                          //         ),
                          //       ],
                          //     ),
                          //   );
                          // }),
                        ],
                      ),
                    ),
    );
  }



  Widget _buildEventDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: AccordionCard(
                      isExpanded: false,
                      expanded: true,
                      title: _stepTitles[_currentStep],
                      onTap: () {},
                      child: SizedBox(
                        width: ResponsiveHelper.width(context, 200),
                        child: CustButton(
                          name: 'Add Event Details',
                          size: 140,
                          onSelected: (p0) {
                            showDialog(
                              context: context,
                              builder: (context) => const AddEventDetailsDialog(),
                            );
                          },
                        ),
                      ),
                    ),
    );
  }

  Widget _buildPTWDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: AccordionCard(
                      isExpanded: false,
                      expanded: true,
                      title: _stepTitles[_currentStep],
                      onTap: () {},
                      child: SizedBox(
                        width: ResponsiveHelper.width(context, 200),
                        child: CustButton(
                          name: 'Add PTW Details',
                          size: 140,
                          onSelected: (p0) {
                            showDialog(
                              context: context,
                              builder: (context) => const AddPTWDetailsDialog(),
                            );
                          },
                        ),
                      ),
                    ),
    );
  }

  Widget _buildSCHoChargeStep() {
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
                          Wrap(
                            spacing: 32,
                            runSpacing: 24,
                            children: [
                              SizedBox(
                                width: 320,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextField(
                                      label: 'SC HO / Charge',
                                      controller: _scHoChargeController,
                                      hintText: 'Enter SC HO / Charge',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 320,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextField(
                                      label: 'Add Description',
                                      controller: _scHoDescriptionController,
                                      hintText: 'Enter Description',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                              ],
                            ),
                    ),
    );
  }
}

class UpdateEquipmentStatusDialog extends StatefulWidget {
  final List<Map<String, dynamic>> dataList; // pass your dataList
  const UpdateEquipmentStatusDialog({Key? key, required this.dataList}) : super(key: key);

  @override
  State<UpdateEquipmentStatusDialog> createState() => _UpdateEquipmentStatusDialogState();
}

class _UpdateEquipmentStatusDialogState extends State<UpdateEquipmentStatusDialog> {
  String? _selectedCategory;
  Map<String, dynamic>? _selectedItem;
  final TextEditingController _remarkController = TextEditingController();

  @override
  void dispose() {
    _remarkController.dispose();
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
          // Header
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
              name: "Update Equipment Status",
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
                children: [
                  // Category dropdown
                  CustDropdown(
                    label: 'Category',
                    hint: 'Select Category',
                    items: widget.dataList.map((item) => item['category']['value'].toString()).toList(),
                    selectedValue: _selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                        _selectedItem = widget.dataList.firstWhere(
                              (item) => item['category']['value'] == value,
                        );
                        _remarkController.text = _selectedItem?['remark']['value'] ?? "";
                      });
                    },
                  ),

                  const SizedBox(height: 16),
                   // Work Status toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustText(
                          name: "Work Status",
                          size: 1.8,
                          fontWeightName: FontWeight.w500,
                        ),
                        Transform.scale(
                          scale: 0.75,
                          child: Switch(
                            activeColor: AppColors.green,
                            thumbColor: const WidgetStatePropertyAll(AppColors.white1),
                            trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                            value: (_selectedItem?['workStatus']['value'] ?? 0) == 1,
                            onChanged: (val) {
                              setState(() {
                                if (_selectedItem != null) {
                                  _selectedItem!['workStatus']['value'] = val ? 1 : 0;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Remark input
                  CustText(
                    name: "Remark",
                    size: 1.8,
                    fontWeightName: FontWeight.w500,
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 8)),
                    CustomTextField(controller: _remarkController,maxLines: 3, onChanged: (val) {
                      _selectedItem?['remark']['value'] = val;
                    },),

                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GreyButton(name: "Cancel",size: 100, onSelected: (p0) => Navigator.pop(context),),
                      SizedBox(width: ResponsiveHelper.spacing(context, 8)),
                      CustButton(
                        name: "Save",
                         size: 100,
                        onSelected: (p0) {
                          if (_selectedItem != null) {
                            _selectedItem!['isSaved'] = true;   // mark as saved
                          }
                          Navigator.pop(context, _selectedItem);
                        },
                      ),
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


class AddStaffDetailsDialog extends StatefulWidget {
  @override
  State<AddStaffDetailsDialog> createState() => _AddStaffDetailsDialogState();
}

class _AddStaffDetailsDialogState extends State<AddStaffDetailsDialog> {
  String? _selectedCategory;
  final TextEditingController _supervisorController = TextEditingController();
  final TextEditingController _agencyController = TextEditingController();
  final TextEditingController _staffNoController = TextEditingController();

  // Example categories, replace with your actual list if needed
  final List<String> categoryList = [
    'House Keeping',
    'Security',
    'TOM',
    'CFA',
    'Others',
    'Supervisors',
  ];

  @override
  void dispose() {
    _supervisorController.dispose();
    _agencyController.dispose();
    _staffNoController.dispose();
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
              name: "Add Outsourced (FMS) Staff Details",
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
                  CustDropdown(
                    label: 'Category Name',
                    hint: 'Select Category Name',
                    items: categoryList,
                    selectedValue: _selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 16)),
                  CustText(
                    name: 'Supervisor Name',
                    size: 1.8,
                    fontWeightName: FontWeight.w500,
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 8)),
                  CustomTextField(
                    controller: _supervisorController,
                    hintText: 'Enter Supervisor Name',
                    labelText: 'Supervisor Name',
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 16)),
                  CustText(
                    name: 'Agency Name',
                    size: 1.8,
                    fontWeightName: FontWeight.w500,
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 8)),
                  CustomTextField(
                    controller: _agencyController,
                    hintText: 'Enter Agency Name',
                    labelText: 'Agency Name',
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 16)),
                  CustText(
                    name: 'No. of Staff Available',
                    size: 1.8,
                    fontWeightName: FontWeight.w500,
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 8)),
                  CustomTextField(
                    controller: _staffNoController,
                    hintText: 'Enter No',
                    labelText: 'No. of Staff Available',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GreyButton(name: "Cancel",size: 100, onSelected: (p0) => Navigator.pop(context),),
                      SizedBox(width: ResponsiveHelper.spacing(context, 8)),
                      CustButton(name: "Save", size: 100, onSelected: (p0){
                        Navigator.pop(context);
                      })
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

class AddStockDetailsDialog extends StatefulWidget {
  const AddStockDetailsDialog({Key? key}) : super(key: key);

  @override
  State<AddStockDetailsDialog> createState() => _AddStockDetailsDialogState();
}

class _AddStockDetailsDialogState extends State<AddStockDetailsDialog> {
  String? _selectedCategory;
  final TextEditingController _openingBalanceController = TextEditingController();
  final TextEditingController _receivedController = TextEditingController();
  final TextEditingController _issuedController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController(text: '0');
  final TextEditingController _defectController = TextEditingController();

  @override
  void dispose() {
    _openingBalanceController.dispose();
    _receivedController.dispose();
    _issuedController.dispose();
    _balanceController.dispose();
    _defectController.dispose();
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
              name: "Add Stock Details",
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
                  CustDropdown(
                    label: 'Category',
                    hint: 'Select Category',
                    items: stockCategories,
                    selectedValue: _selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CustText(name: 'Opening Balance', size: 1.8, fontWeightName: FontWeight.w500),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _openingBalanceController,
                    hintText: 'Enter Opening Balance',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustText(name: 'Received', size: 1.8, fontWeightName: FontWeight.w500),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _receivedController,
                    hintText: 'Enter Received',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustText(name: 'Issued', size: 1.8, fontWeightName: FontWeight.w500),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _issuedController,
                    hintText: 'Enter Issued',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustText(name: 'Balance', size: 1.8, fontWeightName: FontWeight.w500),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _balanceController,
                    hintText: '0',
                    keyboardType: TextInputType.number,
                    enabled: false,
                  ),
                  const SizedBox(height: 16),
                  CustText(name: 'Defect / Unreadable', size: 1.8, fontWeightName: FontWeight.w500),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _defectController,
                    hintText: 'Enter Defect',
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GreyButton(name: "Cancel",size: 100, onSelected: (p0) => Navigator.pop(context),),
                      SizedBox(width: ResponsiveHelper.spacing(context, 8)),
                      CustButton(name: "Save", size: 100, onSelected: (p0){
                        Navigator.pop(context);
                      })
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

class AddEventDetailsDialog extends StatefulWidget {
  const AddEventDetailsDialog({Key? key}) : super(key: key);

  @override
  State<AddEventDetailsDialog> createState() => _AddEventDetailsDialogState();
}

class _AddEventDetailsDialogState extends State<AddEventDetailsDialog> {
  String? _selectedType;
  String? _selectedStatus;
  TimeOfDay? _time;
  final TextEditingController _eventTypeController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> statusList = ['Active', 'Inactive'];

  @override
  void dispose() {
    _timeController.dispose();
    _descriptionController.dispose();
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
              name: "Add Event Details",
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
                  CustomTextField(
                    label: 'Type',
                    controller: _eventTypeController,
                    hintText: 'Enter Type',
                  ),
                  const SizedBox(height: 16),
                  CustDateTimePicker(
                    label: 'Time',
                    hint: 'HH:mm',
                    pickerType: CustDateTimePickerType.time,
                    selectedDateTime: _time != null
                        ? DateTime(2024, 1, 1, _time!.hour, _time!.minute)
                        : null,
                    onDateTimeSelected: (dateTime) {
                      if (dateTime != null) {
                        setState(() {
                          _time = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  CustText(name: 'Status', size: 1.8, fontWeightName: FontWeight.w500),
                  const SizedBox(height: 8),
                  Row(
                    children: statusList.map((option) => Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: CustRadio<String>(
                        value: option,
                        groupValue: _selectedStatus ?? '',
                        label: option,
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        },
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 16),
                  CustText(name: 'Description', size: 1.8, fontWeightName: FontWeight.w500),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _descriptionController,
                    hintText: 'Enter Description',
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

class AddPTWDetailsDialog extends StatefulWidget {
  const AddPTWDetailsDialog({Key? key}) : super(key: key);

  @override
  State<AddPTWDetailsDialog> createState() => _AddPTWDetailsDialogState();
}

class _AddPTWDetailsDialogState extends State<AddPTWDetailsDialog> {
  String? _selectedCategory;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _epicNameController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  TimeOfDay? _timeOfWorkCompletion;
  final TextEditingController _cancellationNoController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _epicNameController.dispose();
    _contactNoController.dispose();
    _balanceController.dispose();
    _cancellationNoController.dispose();
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
              name: "Add PTW Details",
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
                  CustText(name: 'Description', size: 1.8, fontWeightName: FontWeight.w500),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _descriptionController,
                    hintText: 'Enter Description',
                  ),
                  const SizedBox(height: 16),
                  CustText(name: 'Epic Name', size: 1.8, fontWeightName: FontWeight.w500),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _epicNameController,
                    hintText: 'Enter Epic Name',
                  ),
                  const SizedBox(height: 16),
                  CustText(name: 'Contact No', size: 1.8, fontWeightName: FontWeight.w500),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _contactNoController,
                    hintText: 'Enter ContactNo',
                  ),
                  const SizedBox(height: 16),
                  CustText(name: 'Balance', size: 1.8, fontWeightName: FontWeight.w500),
                  const SizedBox(height: 8),
                  CustomTextField(
                    keyboardType: TextInputType.number,
                    controller: _balanceController,
                    hintText: '0',
                  ),
                  const SizedBox(height: 16),
                  CustDateTimePicker(
                    label: 'Time Of Work Completion',
                    hint: 'HH:mm',
                    pickerType: CustDateTimePickerType.time,
                    selectedDateTime: _timeOfWorkCompletion != null
                        ? DateTime(2024, 1, 1, _timeOfWorkCompletion!.hour, _timeOfWorkCompletion!.minute)
                        : null,
                    onDateTimeSelected: (dateTime) {
                      if (dateTime != null) {
                        setState(() {
                          _timeOfWorkCompletion = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  CustText(name: 'Cancellation No.', size: 1.8, fontWeightName: FontWeight.w500),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _cancellationNoController,
                    hintText: 'Cancellation No.',
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
                      ),
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