
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:om_appcart/utils/network_utils.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/feature/lost&found/view/finalize_found_lost_items_screen.dart';
import 'package:om_appcart/utils/responsive_helper.dart';
import 'package:om_appcart/view/widgets/custom_dialog.dart';

import '../../../constants/app_data.dart';
import '../../../view/widgets/bp_gauge_widget.dart';
import '../../../view/widgets/accordion_card.dart';
import '../../../view/widgets/cust_button.dart';
import '../../../view/widgets/cust_date_time_picker.dart';
import '../../../view/widgets/cust_dropdown.dart';
import '../../../view/widgets/cust_text.dart';
import '../../../view/widgets/cust_textfield.dart';
import '../../../view/widgets/custom_app_bar.dart';
import '../../../view/widgets/custom_dialog.dart';
import '../../../view/widgets/custom_snackbar.dart';
import '../../../view/widgets/file_upload_section.dart';
import '../../../view/widgets/cust_loader.dart';


import 'dart:convert';
import '../../../service/auth_manager.dart';
import '../model/lost_found_table_record.dart';
import 'package:om_appcart/controller/station_controller.dart';
import '../controller/lost_and_found_list_controller.dart';
import '../service/lost_found_service.dart';

class LostAndFoundScreen extends StatefulWidget {
  final String mode; // 'add' or 'edit'
  final LostFoundTableRecord? record;

  const LostAndFoundScreen({
    Key? key,
    this.mode = 'add',
    this.record,
  }) : super(key: key);

  @override
  _LostAndFoundScreenState createState() => _LostAndFoundScreenState();
}

class _LostAndFoundScreenState extends State<LostAndFoundScreen> {
  final LostFoundService _service = LostFoundService();
  
  final GlobalKey<FormState> _step1FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _step2FormKey = GlobalKey<FormState>();

  String? _registerAs;
  String? _selectedStation;
  DateTime? _selectedDate;
  final TextEditingController _internalNotesController = TextEditingController();

  final TextEditingController _passengerNameController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _articleLostController = TextEditingController();
  final TextEditingController _articleLostPlaceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _articleFoundController = TextEditingController();
  final TextEditingController _articleFoundPlaceController = TextEditingController();

  String? _selectedColor;
  String? _selectedCategory;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _estimateValueController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _verifiedColor;
  String? _verifiedIdProof;
  final TextEditingController _verifiedUniqueIdController = TextEditingController();
  final TextEditingController _verifiedDescriptionController = TextEditingController();

  DateTime? _handoverDate;
  final TextEditingController _handoverToNameController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  List<dynamic> _attachedFiles = [];

  bool _isItemDetailsExpanded = true;
  bool _isVerificationDetailsExpanded = true;
  bool _isHandoverDetailsExpanded = true;
  bool _isAttachmentsExpanded = true;
  bool _isMatchStatusExpanded = true;

  bool _showMatchResult = false;
  List<dynamic>? _selectedMatchItems;
  Map<String, dynamic>? _autoMatchResult;
  bool _isAutoMatching = false;
  final ScrollController _stepScrollController = ScrollController();
  int _visibleItemsCount = 0;
  int _currentStep = 0;

  int? _roleId;
  bool _isLoadingRole = true;

  final List<String> _registerAsOptions = ['Lost', 'Found'];
  
  final List<String> _basicColorListValue = [
    'Red', 'Blue', 'Green', 'Black', 'White', 'Yellow', 'Other'
  ];
  
  final List<String> _lostItemCategoryListValue = [
    'Electronics', 'Clothing', 'Documents', 'Bag', 'Wallet','Water bottle' 'Other'
  ];
  
  final List<String> _idProofListValue = [
    'Aadhar Card', 'PAN Card', 'Driving License', 'Voter ID', 'Passport', 'Other'
  ];

  List<Widget> get _steps {
    List<Widget> steps = [
      _buildRegistrationStep(),
      _buildItemDetailsStep(),
    ];

    if (_registerAs == 'Found') {
      steps.add(_buildFoundAttachmentsStep());
    }

    int matchID = widget.record?.matchStatus ?? 0;

    if (widget.mode == 'edit') {
      if (_registerAs == 'Lost') {
        steps.add(_buildMatchStatusStep());
        if (matchID >= 3) {
          steps.add(_buildVerificationDetailsStep());
          steps.add(_buildHandoverDetailsStep());
        }
      } else if (_registerAs == 'Found') {
        if (matchID >= 3) {
          steps.add(_buildMatchStatusTableStep());
        }
      }
    }

    return steps;
  }

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    if (widget.mode == 'edit' && widget.record != null) {
      _populateFields();
      
      // Reactive population for station name if it arrives after initialization
      final stationController = Get.find<StationController>();
      if (stationController.stations.isEmpty) {
        once(stationController.stations, (_) {
          if (mounted && _selectedStation == null) {
            setState(() {
              _selectedStation = stationController.getStationNameById(widget.record?.stationID);
            });
          }
        });
      }
    }
  }

  Future<void> _loadUserRole() async {
    final roleId = await AuthManager().getRoleId();
    setState(() {
      _roleId = roleId;
      _isLoadingRole = false;
    });
  }

  void _populateFields() {
    final record = widget.record!;
    _registerAs = record.registerAs;
    // Prioritize name from controller if available, fallback to record's stations object
    _selectedStation = Get.find<StationController>().getStationNameById(record.stationID) ?? 
                      record.stations?.name;
    _selectedDate = record.date;
    _internalNotesController.text = record.internalNotes ?? '';

    if (_registerAs == 'Lost') {
      _passengerNameController.text = record.passengerName ?? '';
      _contactNoController.text = record.contactNo ?? '';
      _articleLostController.text = record.articleLost ?? '';
      _articleLostPlaceController.text = record.articleLostPlace ?? '';
      _addressController.text = record.address ?? '';
    } else {
      _articleFoundController.text = record.articleFound ?? '';
      _articleFoundPlaceController.text = record.articleFoundPlace ?? '';
    }

    _selectedColor = record.color;
    _selectedCategory = record.category;
    _quantityController.text = record.quantity?.toString() ?? '';
    _estimateValueController.text = record.estimateValue ?? '';
    _descriptionController.text = record.description ?? '';
    
    // Verification fields
    _verifiedColor = record.verifiedColor;
    _verifiedIdProof = record.verifiedIdProof;
    _verifiedUniqueIdController.text = record.verifiedUniqueIdentification ?? '';
    _verifiedDescriptionController.text = record.verifiedDescription ?? '';

    // Handover fields
    _handoverDate = record.handoverDate;
    _handoverToNameController.text = record.handoverToName ?? '';
    _remarksController.text = record.remarks ?? '';

    // Populate matched items if available
    if (record.matches != null) {
      _selectedMatchItems = [record.matches!];
      _showMatchResult = true;
    }

    // Populate existing attachments
    _attachedFiles = List.from(record.foundAttachments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: widget.mode == 'edit' ? 'Edit Lost & Found' : 'Add Lost & Found',
        showDrawer: false,
        isForm: true,
        currentStep: _currentStep,
        totalSteps: _steps.length,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: ResponsiveHelper.spacing(context, 8)),
          Expanded(
            child: _steps[_currentStep],
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
                          if (_currentStep == 0) {
                            if (_step1FormKey.currentState?.validate() ?? true) {
                              setState(() => _currentStep++);
                            }
                          } else if (_currentStep == 1) {
                            if (_step2FormKey.currentState?.validate() ?? true) {
                              setState(() => _currentStep++);
                            }
                          } else {
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
                      if (_currentStep == 0) {
                        if (!(_step1FormKey.currentState?.validate() ?? true)) return;
                      } else if (_currentStep == 1) {
                        if (!(_step2FormKey.currentState?.validate() ?? true)) return;
                      }
                      _submitForm();
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationStep() {
    bool isFound = _registerAs == 'Found';
    return Form(
      key: _step1FormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: AccordionCard(
          title: 'Basic Details',
          isExpanded: true, 
          expanded: true,
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustDropdown(
                label: 'Register As',
                hint: 'Select Register As',
                items: _registerAsOptions,
                selectedValue: _registerAs,
                validator: (value) => value == null || value.isEmpty ? 'Please Select Register As' : null,
                onChanged: (value) {
                setState(() {
                  _registerAs = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Obx(() {
              final stationController = Get.find<StationController>();
              return CustDropdown(
                label: 'Station',
                hint: 'Enter Station',
                items: stationController.stations.isEmpty ? stationListValue : stationController.stationNames, 
                selectedValue: _selectedStation,
                validator: (value) => value == null || value.isEmpty ? 'Please Select Station' : null,
                onChanged: (value) => setState(() => _selectedStation = value),
              );
            }),
            const SizedBox(height: 16),
            CustDateTimePicker(
              label: 'Date',
              hint: 'Select Date',
              pickerType: CustDateTimePickerType.date,
              selectedDateTime: _selectedDate,
              validator: (value) => _selectedDate == null ? 'Please Select Date' : null,
              onDateTimeSelected: (date) => setState(() => _selectedDate = date),
            ),
            _buildDynamicFields(isFound),
              const SizedBox(height: 16),
            CustomTextField(
              label: 'Internal Notes',
              controller: _internalNotesController,
              hintText: 'Enter Internal Notes',
              textCapitalization: TextCapitalization.words,
              maxLines: 3,
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildItemDetailsStep() {
    return Form(
      key: _step2FormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: AccordionCard(
        title: 'Item Details',
        isExpanded: _isItemDetailsExpanded,
        expanded: true,
        onTap: () {
          setState(() {
            _isItemDetailsExpanded = !_isItemDetailsExpanded;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustDropdown(
              label: 'Color',
              hint: 'Select Color',
              items: _basicColorListValue,
              selectedValue: _selectedColor,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Color' : null,
              onChanged: (val) => setState(() => _selectedColor = val),
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Category',
              hint: 'Select Category',
              items: _lostItemCategoryListValue,
              selectedValue: _selectedCategory,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Category' : null,
              onChanged: (val) => setState(() => _selectedCategory = val),
            ),
            const SizedBox(height: 16),
            _buildTextFieldWithLabel('Quantity in No', 'Enter Quantity in No', _quantityController, keyboardType: TextInputType.number, customValidator: (value) {
                if (value == null || value.trim().isEmpty) return 'Please Enter Quantity in No';
                final qty = int.tryParse(value.trim());
                if (qty == null || qty <= 0) return 'Invalid Quantity';
                return null;
              }),
            const SizedBox(height: 16),
            _buildTextFieldWithLabel('Estimated Value', 'Enter Estimated Value', _estimateValueController, isRequired: false),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Description',
              controller: _descriptionController,
              hintText: 'Enter Description',
              textCapitalization: TextCapitalization.words,
              maxLines: 3,
            ),
          ],
        ),
      ),
      )
    );
  }

  Widget _buildMatchStatusStep() {
    return SingleChildScrollView(
      controller: _stepScrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          if (!_showMatchResult)
            AccordionCard(
              title: 'Match Status',
              isExpanded: true,
              expanded: true,
              onTap: () {},
              child: CustButton(
                name: 'Check Found Lost Items',
                onSelected: (val) {
                  setState(() {
                    _showMatchResult = true;
                  });
                  _startMatchAnimation();
                },
                size: double.infinity,
                color1: AppColors.blue,
                borderRadius: 4,
                sHeight: 45,
                fontSize: 14,
              ),
            )
          else ...[
            if (_selectedMatchItems == null || _selectedMatchItems!.isEmpty)
              AccordionCard(
                title: 'Match Status',
                isExpanded: true,
                expanded: _isMatchStatusExpanded,
                onTap: () => setState(() => _isMatchStatusExpanded = !_isMatchStatusExpanded),
                child: _buildMatchResultContent(),
              ),
            if (_selectedMatchItems != null && _selectedMatchItems!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildMatchedCardsSection(),
            ],
          ],
        ],
      ),
    );
  }

  void _startMatchAnimation() async {
    if (widget.record == null) return;
    
    setState(() {
      _isAutoMatching = true;
      _autoMatchResult = null;
      _visibleItemsCount = 0;
    });

    try {
      final result = await _service.autoMatch(widget.record!.uniqueCode);
      if (mounted) {
        setState(() {
          _autoMatchResult = {
            ...?result['data'],
            'totalRecords': result['totalRecords'] ?? 0,
          };
          _isAutoMatching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAutoMatching = false);
        String msg = e.toString();
        if (msg.contains('TimeoutException')) {
          msg = 'Time out error';
        }
        CustomSnackBar.show(title: 'Error', message: 'Auto-match failed: $msg');
      }
      return;
    }

    // Only start animation if we have matches OR if user wants to see the breakdown even for 0
    // But user said: "if 0 match then just show msg no match found no need to show all pie chart and other things"
    bool hasMatches = (_autoMatchResult?['matches'] as List?)?.isNotEmpty ?? false;
    
    if (!hasMatches) return;

    // Wait for gauge animation to finish (gauge duration is 1500ms)
    await Future.delayed(const Duration(milliseconds: 1500));
    
    for (int i = 0; i <= 6; i++) {
      if (!mounted) return;
      setState(() {
        _visibleItemsCount = i;
      });
      await Future.delayed(const Duration(milliseconds: 400));
      
      // Gradually scroll down as items appear
      if (_stepScrollController.hasClients) {
        _stepScrollController.animateTo(
          _stepScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  Widget _buildMatchResultContent() {
    if (_isAutoMatching) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: const CustLoader(),
        ),
      );
    }

    bool hasMatches = (_autoMatchResult?['matches'] as List?)?.isNotEmpty ?? false;

    if (!hasMatches && _autoMatchResult != null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CustText(
            name: 'No match found.',
            size: 1.4,
            fontWeightName: FontWeight.bold,
            color: AppColors.red,
          ),
        ),
      );
    }

    final breakdown = _autoMatchResult?['breakdownPassCount'] ?? {};
    final overallScore = (_autoMatchResult?['overallAverageScore'] ?? 0).toDouble();
    final totalRecords = _autoMatchResult?['totalRecords'] ?? 1;

    int getPerc(String key) {
      if (totalRecords == 0) return 0;
      return ((breakdown[key] ?? 0) / totalRecords * 100).toInt();
    }

    final catPerc = getPerc('category');
    final colorPerc = getPerc('color');
    final stationPerc = getPerc('station');
    final datePerc = getPerc('date');
    final placePerc = getPerc('place');
    final descPerc = getPerc('description');
    return Column(
      children: [
        BpGaugeWidget(percentage: overallScore / 100),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFFCC80), width: 0.5),
          ),
          child: const CustText(
            name: 'Match is based on the parameters provided by user. User is responsible for final handover.',
            size: 1.1,
            color: Color(0xFF8D6E63),
          ),
        ),
        const SizedBox(height: 16),
        
        // Animated List Items using API data
        _buildAnimatedListItem(0, 'Category Match', '$catPerc%', 
          catPerc >= 50 ? TablerIcons.circle_check_filled : Icons.cancel, 
          catPerc >= 50 ? AppColors.green : AppColors.red),
        
        _buildAnimatedListItem(1, 'Color Match', '$colorPerc%', 
          colorPerc >= 50 ? Icons.check_circle : Icons.cancel, 
          colorPerc >= 50 ? AppColors.green : AppColors.red),
        
        _buildAnimatedListItem(2, 'Station Match', '$stationPerc%', 
          stationPerc >= 50 ? Icons.check_circle : Icons.cancel, 
          stationPerc >= 50 ? AppColors.green : AppColors.red),
        
        _buildAnimatedListItem(3, 'Date Match', '$datePerc%', 
          datePerc >= 50 ? Icons.check_circle : Icons.watch_later, 
          datePerc >= 50 ? AppColors.green : AppColors.orange),
        
        _buildAnimatedListItem(4, 'Place Match', '$placePerc%', 
          placePerc >= 50 ? Icons.check_circle : Icons.watch_later, 
          placePerc >= 50 ? AppColors.green : AppColors.orange),
        
        _buildAnimatedListItem(5, 'Description Match', '$descPerc%', 
          descPerc >= 50 ? Icons.check_circle : Icons.watch_later, 
          descPerc >= 50 ? AppColors.green : AppColors.orange),

        if (_visibleItemsCount >= 6 && (_selectedMatchItems == null || _selectedMatchItems!.isEmpty)) ...[
          const SizedBox(height: 24),
          CustButton(
            name: 'Finalize Match',
            onSelected: (val) async {
              final result = await Get.to(() => FinalizeFoundLostItemsScreen(
                lostID: widget.record!.id!,
                matchData: _autoMatchResult?['matches'] ?? [],
              ));
              
              if (result != null && result is Map<String, dynamic>) {
                setState(() => _selectedMatchItems = [result]);
              }
            },
            size: 150,
            color1: AppColors.blue,
            borderRadius: 4,
            sHeight: 45,
            fontSize: 14,
          ),
        ],
      ],
    );
  }

  Widget _buildMatchedCardsSection() {
    if (_selectedMatchItems == null || _selectedMatchItems!.isEmpty) {
      return const Center(child: CustText(name: 'No matches selected', size: 1.2, color: AppColors.textColor4));
    }
    return  AccordionCard(
      title: 'Matched',
      isExpanded: _isVerificationDetailsExpanded,
      expanded: true,
      onTap: () => setState(() => _isVerificationDetailsExpanded = !_isVerificationDetailsExpanded),
      child: Column(
        children: _selectedMatchItems!.map((item) {
          // When item is a Map (returned from FinalizeFoundLostItemsScreen), the API response
          // nests all found item details inside a 'found_item' sub-map. We must unwrap it
          // first before reading fields — otherwise every field resolves to null (→ N/A).
          final isModel = item is LostFoundTableRecord;
          final Map<String, dynamic>? foundItemData = isModel
              ? null
              : (item['found_item'] as Map<String, dynamic>? ?? item as Map<String, dynamic>);
          final articleTitle = isModel
              ? (item.articleFound ?? item.articleLost ?? 'N/A')
              : (foundItemData!['articleFound'] ?? foundItemData['articleLost'] ?? foundItemData['docNumber'] ?? 'N/A');
          final percentage = isModel
              ? '${item.matchPercentage ?? 0}%'
              : '${((item['score'] ?? item['matchPercentage'] ?? 0.0) as num).toStringAsFixed(1)}%';
          final category = isModel ? (item.category ?? 'N/A') : (foundItemData!['category'] ?? 'N/A');
          final station = isModel ? (item.stations?.name ?? 'N/A') : (foundItemData!['stations']?['name'] ?? 'N/A');
          final place = isModel
              ? (item.articleFoundPlace ?? item.articleLostPlace ?? 'N/A')
              : (foundItemData!['articleFoundPlace'] ?? foundItemData['articleLostPlace'] ?? 'N/A');
          final color = isModel ? (item.color ?? 'N/A') : (foundItemData!['color'] ?? 'N/A');
          final quantity = isModel ? (item.quantity?.toString() ?? '1') : (foundItemData!['quantity']?.toString() ?? '1');
          final description = isModel ? (item.description ?? 'No description') : (foundItemData!['description'] ?? 'No description');
          final registerAs = isModel ? (item.registerAs ?? 'N/A') : (foundItemData!['registerAs'] ?? 'N/A');
          final articleLost = isModel ? (item.articleLost ?? '-') : (foundItemData!['articleLost'] ?? '-');
          final articleFound = isModel ? (item.articleFound ?? '-') : (foundItemData!['articleFound'] ?? '-');

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0), width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustText(
                            name: articleTitle,
                            size: 1.2,
                            color: AppColors.black,
                            fontWeightName: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: CustText(
                            name: percentage,
                            size: 1.0,
                            color: const Color(0xFF4CAF50),
                            fontWeightName: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMatchDetailRow('Register As', registerAs),
                        const SizedBox(height: 8),
                        _buildMatchDetailRow('Article Lost', articleLost),
                        const SizedBox(height: 8),
                        _buildMatchDetailRow('Article Found', articleFound),
                        const SizedBox(height: 8),
                        _buildMatchDetailRow('Place', place),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(child: _buildMatchDetailRow('Color', color)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildMatchDetailRow('Category', category)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildMatchDetailRow('Quantity', quantity),
                        const SizedBox(height: 8),
                        const CustText(name: 'Description', size: 1.0, color: AppColors.textColor4),
                        const SizedBox(height: 4),
                        CustText(
                          name: description,
                          size: 1.1,
                          color: AppColors.black,
                          fontWeightName: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMatchDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustText(name: label, size: 1.0, color: AppColors.textColor4),
        CustText(name: value, size: 1.1, color: AppColors.black, fontWeightName: FontWeight.w500),
      ],
    );
  }

  Widget _buildAnimatedListItem(int index, String title, String subtitle, IconData icon, Color iconColor) {
    bool isVisible = _visibleItemsCount > index;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: isVisible ? 1.0 : 0.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        margin: EdgeInsets.only(bottom: isVisible ? 0 : 0),
        height:  50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Icon(icon, color: iconColor, size: 24),
                if (index < 5)
                  Expanded(
                    child: CustomPaint(
                      size: const Size(1, double.infinity),
                      painter: DashedLinePainter(),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustText(
                          name: title,
                          size: 1.2,
                          color: AppColors.black,
                          fontWeightName: FontWeight.w600,
                        ),
                        CustText(
                          name: subtitle,
                          size: 1.1,
                          color: AppColors.textColor4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: AccordionCard(
        title: 'Verification',
        isExpanded: _isVerificationDetailsExpanded,
        expanded: true,
        onTap: () => setState(() => _isVerificationDetailsExpanded = !_isVerificationDetailsExpanded),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustDropdown(
              label: 'Color',
              hint: 'Select Color',
              items: _basicColorListValue,
              selectedValue: _verifiedColor,
              onChanged: (val) => setState(() => _verifiedColor = val),
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'ID Proof',
              hint: 'Select ID Proof',
              items: _idProofListValue,
              selectedValue: _verifiedIdProof,
              onChanged: (val) => setState(() => _verifiedIdProof = val),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Unique Identification',
              controller: _verifiedUniqueIdController,
              hintText: 'Enter unique identification',
              textCapitalization: TextCapitalization.words,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Description',
              controller: _verifiedDescriptionController,
              hintText: 'Enter Description',
              textCapitalization: TextCapitalization.words,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandoverDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: AccordionCard(
        title: 'Handover',
        isExpanded: _isHandoverDetailsExpanded,
        expanded: true,
        onTap: () => setState(() => _isHandoverDetailsExpanded = !_isHandoverDetailsExpanded),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustDateTimePicker(
              label: 'Handover Date & Time',
              hint: 'Select Date & Time',
              pickerType: CustDateTimePickerType.dateTime,
              selectedDateTime: _handoverDate,
              onDateTimeSelected: (date) => setState(() => _handoverDate = date),
            ),
            const SizedBox(height: 16),
            _buildTextFieldWithLabel('Name', 'Enter Name', _handoverToNameController),
            CustomTextField(
              label: 'Remark',
              controller: _remarksController,
              hintText: 'Enter Remark',
              textCapitalization: TextCapitalization.words,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoundAttachmentsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          AccordionCard(
            title: 'Found Attachments',
            isExpanded: _isAttachmentsExpanded,
            expanded: true,
            onTap: () => setState(() => _isAttachmentsExpanded = !_isAttachmentsExpanded),
            child: FileUploadSection(
              files: _attachedFiles,
              onFilesChanged: (files) => setState(() => _attachedFiles = files),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchStatusTableStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: _buildMatchedCardsSection(),
    );
  }

  Widget _buildDynamicFields(bool isFound) {
    if (_registerAs == null) return const SizedBox.shrink();

    if (isFound) {
      // Found Fields
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildTextFieldWithLabel('What Article Found', 'Enter Details of Article Found', _articleFoundController, textCapitalization: TextCapitalization.words),
          const SizedBox(height: 16),
          _buildTextFieldWithLabel('Place of Article Found', 'Enter Place of Article Found', _articleFoundPlaceController, textCapitalization: TextCapitalization.words),
        ],
      );
    } else {
      // Lost Fields
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildTextFieldWithLabel('Name of Passenger', 'Enter Name', _passengerNameController, textCapitalization: TextCapitalization.words),
          const SizedBox(height: 16),
          _buildTextFieldWithLabel('Contact No', 'Enter Contact No', _contactNoController, keyboardType: TextInputType.number,maxlength: 10),
          const SizedBox(height: 16),
          _buildTextFieldWithLabel('What Article Lost', 'Enter Details of Article Lost', _articleLostController, textCapitalization: TextCapitalization.words),
          const SizedBox(height: 16),
          _buildTextFieldWithLabel('Place of Article Lost', 'Enter Place of Article Lost', _articleLostPlaceController, textCapitalization: TextCapitalization.words),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Passenger Address',
            controller: _addressController,
            hintText: 'Enter Passenger Address',
            textCapitalization: TextCapitalization.words,
            maxLines: 3,
          ),
        ],
      );
    }
  }

  Widget _buildTextFieldWithLabel(String label, String hint, TextEditingController controller, {bool isRequired = true, String? Function(String?)? customValidator, int? maxlength, TextInputType? keyboardType, TextCapitalization textCapitalization = TextCapitalization.none}) {
    return CustomTextField(
      label: label, 
      controller: controller, 
      hintText: hint,
      keyboardType: keyboardType ?? TextInputType.text,
      textCapitalization: textCapitalization,
      maxLength: maxlength,
      validator: customValidator ?? (isRequired ? (value) => value == null || value.trim().isEmpty ? 'Please Enter $label' : null : null),
    );
  }

  void _submitForm() async {
    // Check connectivity first
    bool isOnline = await NetworkUtils.checkConnectivity();
    if (!isOnline) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => CustomDialog(
          'You need an active internet connection to ${widget.mode == 'edit' ? 'update' : 'create'} records.',
          onOk: () => Navigator.pop(context),
        ),
      );
      return;
    }

    if (_registerAs == null) {
      CustomSnackBar.show(title: "Required", message: "Please select 'Register As'");
      return;
    }

    try {
      Get.dialog(
        const CustLoader(),
        barrierDismissible: false,
      );

      final stationController = Get.find<StationController>();
      int? stationID = stationController.getStationIdByName(_selectedStation);
      
      if (stationID == null && widget.mode == 'edit') {
        stationID = widget.record?.stationID;
      }

      print("DEBUG: Selected Station: $_selectedStation, Mapped ID: $stationID");

      if (stationID == null || stationID == 0) {
        Get.back(); // close loading
        CustomSnackBar.show(title: "Required", message: "Please select a valid station");
        return;
      }

      String? nullable(String text) => text.trim().isEmpty ? null : text;

      final Map<String, dynamic> payload = {
        if (widget.mode == 'edit') "id": widget.record?.id,
        "registerAs": _registerAs,
        "stationID": stationID,
        "date": _selectedDate?.toIso8601String(),
        "passengerName": nullable(_passengerNameController.text),
        "contactNo": nullable(_contactNoController.text),
        "articleLost": nullable(_articleLostController.text),
        "articleLostPlace": nullable(_articleLostPlaceController.text),
        "articleFound": nullable(_articleFoundController.text),
        "articleFoundPlace": nullable(_articleFoundPlaceController.text),
        "address": nullable(_addressController.text),
        "internalNotes": nullable(_internalNotesController.text),
        "color": _selectedColor,
        "category": _selectedCategory,
        "quantity": int.tryParse(_quantityController.text) ?? 1,
        "estimateValue": nullable(_estimateValueController.text),
        "description": nullable(_descriptionController.text),
        "verifiedColor": _verifiedColor,
        "verifiedIdProof": _verifiedIdProof,
        "verifiedUniqueIdentification": nullable(_verifiedUniqueIdController.text),
        "verifiedDescription": nullable(_verifiedDescriptionController.text),
        "handoverDate": _handoverDate?.toIso8601String(),
        "handoverToName": nullable(_handoverToNameController.text),
        "remarks": nullable(_remarksController.text),
        "remark": nullable(_remarksController.text), // Many APIs use singular for update comment
        if (widget.mode == 'edit') "matchStatus": widget.record?.matchStatus ?? 0,
        if (widget.mode == 'edit') "isActive": widget.record?.isActive ?? true,
        "files": _attachedFiles
            .whereType<FoundAttachment>()
            .map((a) => a.originalPath)
            .toList(),
      };

      final service = LostFoundService();
      
      final List<File> filesToUpload = _attachedFiles.whereType<File>().toList();
      
      if (widget.mode == 'edit') {
        if (widget.record == null) throw Exception("Record data missing for edit mode");
        await service.updateLostFound(widget.record!.id, payload, filesToUpload);
      } else {
        await service.createLostFound(payload, filesToUpload);
      }

      Get.back();

      final successMsg = widget.mode == 'edit' ? "Updated Successfully." : "Saved Successfully.";
      
      void navigateBack() {
        try {
          if (Get.isRegistered<LostAndFoundListController>()) {
            Get.find<LostAndFoundListController>().refreshItems();
          }
        } catch (e) {
          print("Error refreshing list: $e");
        }
        
        Get.back();
        Get.back(result: true);
      }

      Get.dialog(
        CustomDialog(
          successMsg,
          onOk: () => navigateBack(),
        ),
        barrierDismissible: false,
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (Get.isDialogOpen ?? false) {
          navigateBack();
        }
      });

    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Close loading
      }
      String msg = e.toString();
      if (msg.contains('TimeoutException') || msg.contains('Timeout')) {
        msg = 'Connection timed out. Please try again.';
      } else if (msg.contains('SocketException')) {
        msg = 'No internet connection or server unreachable.';
      } else {
        msg = msg.replaceAll('Exception: ', '');
      }
      CustomSnackBar.show(title: "Error", message: msg);
    }
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 7, dashSpace = 4, startY = 0;
    final paint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 2;
    while (startY < size.height) {
      canvas.drawLine(Offset(size.width / 2, startY), Offset(size.width / 2, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
