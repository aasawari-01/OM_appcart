import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:om_appcart/view/widgets/full_image_viewer.dart';
import 'package:om_appcart/view/widgets/custom_confirmation_dialog.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:om_appcart/utils/network_utils.dart';
import 'package:om_appcart/view/widgets/custom_dialog.dart';
import '../../../utils/app_date_utils.dart';

import '../../../constants/colors.dart';
import '../../../controller/station_controller.dart';
import '../../../service/network_service/app_urls.dart';
import '../../../utils/responsive_helper.dart';
import '../../../view/widgets/cust_text.dart';
import '../../../view/widgets/cust_textfield.dart';
import '../../../view/widgets/cust_dropdown.dart';
import '../../../view/widgets/custom_app_bar.dart';
import '../../../view/widgets/cust_button.dart';
import '../../../view/widgets/accordion_card.dart';
import '../../../view/widgets/custom_snackbar.dart';
import '../../../view/widgets/cust_date_time_picker.dart';
import '../controller/user_profile_controller.dart';
import '../model/user_profile_model.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> with SingleTickerProviderStateMixin {
  final UserProfileController controller = Get.find<UserProfileController>();
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _personalKey = GlobalKey();
  final GlobalKey _employeeKey = GlobalKey();
  final GlobalKey _financeKey = GlobalKey();

  // Personal Details Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final empNoController = TextEditingController();
  final contactNoController = TextEditingController();
  final altContactNoController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final bloodGroupController = TextEditingController();
  final birthPlaceController = TextEditingController();
  
  // Verification Details
  final panCardController = TextEditingController();
  final aadharCardController = TextEditingController();

  // Current Address
  final resHouseNoController = TextEditingController();
  final localityController = TextEditingController();
  final pincodeController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();

  // Permanent Address
  final pResHouseNoController = TextEditingController();
  final pLocalityController = TextEditingController();
  final pPincodeController = TextEditingController();
  final pCityController = TextEditingController();
  final pStateController = TextEditingController();
  final pCountryController = TextEditingController();

  // Employee Details
  final dojController = TextEditingController();
  final empCityController = TextEditingController();
  final deptController = TextEditingController();
  final stationController = TextEditingController();
  final roleController = TextEditingController();
  final designationController = TextEditingController();

  // Finance Details
  final bankNameController = TextEditingController();
  final accountNoController = TextEditingController();
  final ifscController = TextEditingController();
  final branchController = TextEditingController();

  String selectedGender = 'Male';
  String selectedShift = 'Morning';
  bool sameAsCurrent = false;

  String? _selectedStation;
  List<String> stationListValue = [];

  bool _isScrollingFromAuto = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadInitialData();
    _scrollController.addListener(_scrollListener);
    
    // Ensure master data is being fetched/refreshed
    Get.find<StationController>().fetchStations();
    controller.fetchMasterData();
    
    print("DEBUG: EditProfileView.initState - Master Data Status: "
          "Cities=${controller.cities.length}, "
          "Depts=${controller.departmentTypes.length}, "
          "Stations=${Get.find<StationController>().stations.length}");
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_isScrollingFromAuto) return;

    final personalOffset = _getOffset(_personalKey);
    final employeeOffset = _getOffset(_employeeKey);
    final financeOffset = _getOffset(_financeKey);

    if (_scrollController.offset >= (financeOffset - 100)) {
      if (_tabController.index != 2) _tabController.animateTo(2);
    } else if (_scrollController.offset >= (employeeOffset - 100)) {
      if (_tabController.index != 1) _tabController.animateTo(1);
    } else {
      if (_tabController.index != 0) _tabController.animateTo(0);
    }
  }

  double _getOffset(GlobalKey key) {
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return 0;
    return renderBox.localToGlobal(Offset.zero, ancestor: null).dy + _scrollController.offset - 250; 
    // -250 is an approximate adjustment for the header and tabs
  }

  void _scrollToSection(int index) {
    _isScrollingFromAuto = true;
    _tabController.animateTo(index);
    
    GlobalKey targetKey;
    switch (index) {
      case 0: targetKey = _personalKey; break;
      case 1: targetKey = _employeeKey; break;
      case 2: targetKey = _financeKey; break;
      default: targetKey = _personalKey;
    }

    final context = targetKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      ).then((_) {
        _isScrollingFromAuto = false;
      });
    } else {
      _isScrollingFromAuto = false;
    }
  }

  /// Capitalizes the first letter of each word in the string.
  String _capitalize(String? value) {
    if (value == null || value.isEmpty) return '';
    return value.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  void _loadInitialData() {
    final data = controller.profileData.value;
    if (data != null) {
      firstNameController.text = _capitalize(data.firstName);
      lastNameController.text = _capitalize(data.lastName);
      emailController.text = data.emailID;
      contactNoController.text = data.contactNo ?? '';
      empNoController.text = data.userDetails?.employeeID ?? data.uniqueCode;
      
      final details = data.userDetails;
      if (details != null) {
        dobController.text = details.dateOfBirth ?? '';
        dojController.text = details.dateOfJoining ?? '';

        bloodGroupController.text = (details.bloodGroup ?? '').toUpperCase();
        birthPlaceController.text = _capitalize(details.birthPlace);
        panCardController.text = (details.panCardNo ?? '').toUpperCase();
        aadharCardController.text = details.aadharCardNo ?? '';
        altContactNoController.text = details.alternateContactNo ?? '';
        selectedGender = details.gender ?? 'Male';
        selectedShift = details.shiftType ?? 'Morning';
        
        void parseAddress(String? addressStr, TextEditingController house, TextEditingController locality, TextEditingController pin, TextEditingController city, TextEditingController state, TextEditingController country) {
          if (addressStr == null || addressStr.isEmpty) return;
          List<String> parts = addressStr.split('|');
          if (parts.length == 6) {
            house.text = _capitalize(parts[0]);
            locality.text = _capitalize(parts[1]);
            pin.text = parts[2]; // pincode stays as-is
            city.text = _capitalize(parts[3]);
            state.text = _capitalize(parts[4]);
            country.text = _capitalize(parts[5]);
          } else {
            // Unstructured old data, put everything in house or try to comma split
            List<String> commaParts = addressStr.split(', ').map((e) => e.trim()).toList();
            if (commaParts.isNotEmpty) house.text = _capitalize(commaParts[0]);
            if (commaParts.length > 1) locality.text = _capitalize(commaParts[1]);
            if (commaParts.length > 2) city.text = _capitalize(commaParts[2]);
            if (commaParts.length > 3) state.text = _capitalize(commaParts[3]);
            if (commaParts.length > 4) pin.text = commaParts[4];
          }
        }

        parseAddress(details.currentAddress, resHouseNoController, localityController, pincodeController, cityController, stateController, countryController);
        parseAddress(details.permanentAddress, pResHouseNoController, pLocalityController, pPincodeController, pCityController, pStateController, pCountryController);
      }

      // Pre-fill some employee details from base model if available
      if (data.cities != null && data.cities!.isNotEmpty) empCityController.text = data.cities!.first.name;
      if (data.departments != null && data.departments!.isNotEmpty) deptController.text = data.departments!.first.name;
      if (data.stations != null && data.stations!.isNotEmpty)   _selectedStation = data.stations!.first.name;
      if (data.role != null) roleController.text = data.role!.name;
      if (data.designation != null) designationController.text = data.designation!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white1,
      appBar: CustomAppBar(
        title: 'Edit Profile',
        showDrawer: false,
        isForm: true,
        onLeadingPressed: () => Get.back(),
        actions: const [],
      ),
      body: Obx(() => Stack(
            children: [
              Column(
                children: [
                  _buildHeader(),
                  _buildTabs(),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          _buildPersonalDetailsSection(),
                          const SizedBox(height: 24),
                          _buildEmployeeDetailsSection(),
                          const SizedBox(height: 24),
                          _buildFinanceDetailsSection(),
                          const SizedBox(height: 10), // Extra space at bottom
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (controller.isLoading.value)
                Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          )),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() => CustButton(
                name: 'Update',
                onSelected: (_) async {
                  // Check connectivity first
                  bool isOnline = await NetworkUtils.checkConnectivity();
                  if (!isOnline) {
                    Get.dialog(
                      CustomDialog(
                        "You need an active internet connection to update your profile.",
                        onOk: () => Get.back(),
                      ),
                      barrierDismissible: false,
                    );
                    return;
                  }

                  bool confirm = false;
                  await CustomConfirmationDialog.show(
                    title: 'Confirm Update',
                    message: 'Are you sure you want to update your profile data?',
                    confirmText: 'Update',
                    confirmColor: AppColors.blue,
                    icon: TablerIcons.device_floppy,
                    onConfirm: () => confirm = true,
                    onCancel: () => confirm = false,
                  );

                  if (!confirm) return;



                  final _stationController = Get.find<StationController>();
                  int? stationID = _stationController.getStationIdByName(_selectedStation);
                  // Function to join address fields
                  String joinAddress(
                    TextEditingController house, TextEditingController locality, 
                    TextEditingController pin, TextEditingController city, 
                    TextEditingController state, TextEditingController country
                  ) {
                    return [house, locality, pin, city, state, country]
                        .map((c) => c.text.replaceAll('|', '').trim())
                        .join('|');
                  }

                  final userDetails = UserDetails(
                    dateOfBirth: AppDateUtils.formatToApiDate(dobController.text),
                    dateOfJoining: AppDateUtils.formatToApiDate(dojController.text),
                    employeeID: empNoController.text,
                    birthPlace: birthPlaceController.text,
                    bloodGroup: bloodGroupController.text,
                    currentAddress: joinAddress(
                      resHouseNoController, localityController, pincodeController, 
                      cityController, stateController, countryController
                    ),
                    permanentAddress: sameAsCurrent ? 
                      joinAddress(
                        resHouseNoController, localityController, pincodeController, 
                        cityController, stateController, countryController
                      ) : 
                      joinAddress(
                        pResHouseNoController, pLocalityController, pPincodeController, 
                        pCityController, pStateController, pCountryController
                      ),
                    alternateContactNo: altContactNoController.text,
                    gender: selectedGender,
                    aadharCardNo: aadharCardController.text,
                    panCardNo: panCardController.text,
                    shiftType: selectedShift,

                  );

                  int? cityId = controller.getCityIdByName(empCityController.text);
                  int? deptId = controller.getDepartmentIdByName(deptController.text);
                  int? roleId = controller.getRoleIdByName(roleController.text);
                  int? desigId = controller.getDesignationIdByName(designationController.text);

                  print("DEBUG: EditProfileView - Resolved IDs: City=$cityId, Dept=$deptId, Station=$stationID, Role=$roleId, Desig=$desigId");

                  bool success = await controller.updateProfile(
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    email: emailController.text,
                    contactNo: contactNoController.text,
                    stationIDs: stationID != null ? [stationID] : null,
                    cityIDs: cityId != null ? [cityId] : null,
                    departmentIDs: deptId != null ? [deptId] : null,
                    roleID: roleId,
                    designationID: desigId,
                    userDetails: userDetails,
                  );
                  if (success) {
                    Get.dialog(
                      CustomDialog("Profile updated successfully", onOk: () {
                        Get.back(); // Close dialog
                        Get.back(); // Go back to Profile View
                      }),
                      barrierDismissible: false,
                    );
                  }
                },
                isLoading: controller.isLoading.value,
              )),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: GestureDetector(
          onTap: _showImagePickerOptions,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Obx(() {
                  final imageFile = controller.selectedImage.value;
                  final profilePicUrl = controller.profileData.value?.profilePic;

                  Widget imageWidget;
                  if (imageFile != null) {
                    imageWidget = Image.file(imageFile, fit: BoxFit.cover, width: 100, height: 100);
                  } else if (profilePicUrl != null && profilePicUrl.isNotEmpty) {
                    imageWidget = Image.network(
                      profilePicUrl.startsWith('http') ? profilePicUrl : "${AppUrls.baseUrl}$profilePicUrl", 
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.person, size: 50, color: Colors.grey)),
                    );
                  } else {
                    imageWidget = const Center(child: Icon(Icons.person, size: 50, color: Colors.grey));
                  }

                  return Hero(
                    tag: 'profile_pic_edit',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: imageWidget,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustText(name: 'Select Profile Photo', size: 1.8, fontWeightName: FontWeight.w600),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPickerOption(Icons.visibility, 'View Photo', null),
                _buildPickerOption(Icons.camera_alt, 'Camera', ImageSource.camera),
                _buildPickerOption(Icons.photo_library, 'Gallery', ImageSource.gallery),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerOption(IconData icon, String label, ImageSource? source) {
    return InkWell(
      onTap: () {
        Get.back();
        if (source == null) {
          final imageFile = controller.selectedImage.value;
          final profilePicUrl = controller.profileData.value?.profilePic;
          final provider = imageFile != null
              ? FileImage(imageFile)
              : (profilePicUrl != null && profilePicUrl.isNotEmpty
                  ? NetworkImage(profilePicUrl.startsWith('http') ? profilePicUrl : "${AppUrls.baseUrl}$profilePicUrl")
                  : const AssetImage('assets/images/drawer/profile_pic.png')) as ImageProvider;
          FullImageViewer.show(context, imageProvider: provider, heroTag: 'profile_pic_edit');
        } else {
          controller.pickAndCropImage(source);
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.blue, size: 30),
          ),
          const SizedBox(height: 8),
          CustText(name: label, size: 1.4),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.dividerColor2, width: 1)),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.blue,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        unselectedLabelColor: AppColors.textColor4,
        indicatorColor: AppColors.blue,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 16),
        unselectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w400, fontSize: 16),
        onTap: (index) => _scrollToSection(index),
        tabs: const [
          Tab(text: 'Personal Details'),
          Tab(text: 'Employee Details'),
          Tab(text: 'Finance Details'),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsSection() {
    return Container(
      key: _personalKey,
      child: AccordionCard(
        title: 'Personal Details',
        isExpanded: true,
        expanded: true,
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustText(name: 'Personal Details', size: 1.6, fontWeightName: FontWeight.w600),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: CustomTextField(controller: firstNameController, label: 'First Name', hintText: 'First Name', textCapitalization: TextCapitalization.words)),
                const SizedBox(width: 12),
                Expanded(child: CustomTextField(controller: lastNameController, label: 'Last Name', hintText: 'Last Name', textCapitalization: TextCapitalization.words)),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(controller: empNoController, label: 'Employee Number', hintText: 'Enter Employee Number',keyboardType: TextInputType.number,),
            const SizedBox(height: 16),
            CustomTextField(controller: contactNoController, label: 'Contact Number', hintText: 'Enter Contact Number', keyboardType: TextInputType.phone, maxLength: 10,),
            const SizedBox(height: 16),
            CustomTextField(controller: altContactNoController, label: 'Alternate Contact Number', hintText: 'Enter Alternate Contact Number', keyboardType: TextInputType.phone, maxLength: 10),
            const SizedBox(height: 16),
            CustomTextField(controller: emailController, label: 'Email', hintText: 'Enter Email', keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildGenderSelection(),
            const SizedBox(height: 16),
            CustDateTimePicker(
              label: 'Date of Birth',
              hint: 'DD/MM/YYYY',
              selectedDateTime: dobController.text.isEmpty ? null : AppDateUtils.parseDate(dobController.text),
              pickerType: CustDateTimePickerType.date,
              onDateTimeSelected: (date) {
                if (date != null) {
                  setState(() => dobController.text = AppDateUtils.formatDate(date));
                }
              },
            ),
            const SizedBox(height: 16),
            CustDropdown(
              label: 'Blood Group', 
              hint: 'Select Blood Group', 
              items: const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
              selectedValue: bloodGroupController.text.isEmpty ? null : bloodGroupController.text,
              onChanged: (v) => setState(() => bloodGroupController.text = v ?? ''),
            ),
            const SizedBox(height: 16),
            CustomTextField(controller: birthPlaceController, label: 'Birth Place', hintText: 'Enter Birth Place', textCapitalization: TextCapitalization.words),
            
            const SizedBox(height: 24),
            const CustText(name: 'Verification Details', size: 1.6, fontWeightName: FontWeight.w600),
            const SizedBox(height: 16),
            CustomTextField(
              controller: panCardController, 
              label: 'Pan Card No.', 
              hintText: 'Enter Pan Card No.', 
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                TextInputFormatter.withFunction((oldValue, newValue) {
                  return newValue.copyWith(text: newValue.text.toUpperCase());
                }),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(controller: aadharCardController, label: 'Aadhar Card No.', hintText: 'Enter Aadhar Card No.',keyboardType: TextInputType.number,maxLength: 12,),

            const SizedBox(height: 24),
            const CustText(name: 'Current Address', size: 1.6, fontWeightName: FontWeight.w600),
            const SizedBox(height: 16),
            _buildAddressFields(
              resHouseNoController, localityController, pincodeController, 
              cityController, stateController, countryController
            ),

            const SizedBox(height: 24),
            const CustText(name: 'Permanent Address', size: 1.6, fontWeightName: FontWeight.w600),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: sameAsCurrent,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  onChanged: (val) {
                    setState(() {
                      sameAsCurrent = val ?? false;
                      if (sameAsCurrent) {
                        pResHouseNoController.text = resHouseNoController.text;
                        pLocalityController.text = localityController.text;
                        pPincodeController.text = pincodeController.text;
                        pCityController.text = cityController.text;
                        pStateController.text = stateController.text;
                        pCountryController.text = countryController.text;
                      }
                    });
                  },
                  activeColor: AppColors.blue,
                ),
                const SizedBox(width: 8),

                const CustText(name: 'Same as Current Address', size: 1.2, color: AppColors.textColor4),
              ],
            ),
            _buildAddressFields(
              pResHouseNoController, pLocalityController, pPincodeController, 
              pCityController, pStateController, pCountryController,
              enabled: !sameAsCurrent
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeDetailsSection() {
    return Container(
      key: _employeeKey,
      child: AccordionCard(
        title: 'Employee Details',
        isExpanded: true,
        expanded: true,
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustText(name: 'Employee Details', size: 1.6, fontWeightName: FontWeight.w600),
            const SizedBox(height: 16),
            CustDateTimePicker(
              label: 'Date of Joining',
              hint: 'DD/MM/YYYY',
              selectedDateTime: dojController.text.isEmpty ? null : AppDateUtils.parseDate(dojController.text),
              pickerType: CustDateTimePickerType.date,
              onDateTimeSelected: (date) {
                if (date != null) {
                  setState(() => dojController.text = AppDateUtils.formatDate(date));
                }
              },
            ),
            const SizedBox(height: 16),
            Obx(() => CustDropdown(
              label: 'City', 
              hint: 'Select City', 
              items: controller.cities.map((e) => e.name).toList(), 
              selectedValue: empCityController.text.isEmpty ? null : empCityController.text,
              onChanged: (v) => setState(() => empCityController.text = v ?? ''),
            )),
            const SizedBox(height: 16),
            Obx(() => CustDropdown(
              label: 'Department', 
              hint: 'Select Department', 
              items: controller.departmentTypes.map((e) => e.name).toList(), 
              selectedValue: deptController.text.isEmpty ? null : deptController.text,
              onChanged: (v) => setState(() => deptController.text = v ?? ''),
            )),
            const SizedBox(height: 16),
            Obx(() {
              final stationController = Get.find<StationController>();
              final items = stationController.stations.map((s) => s.name).toList();
              return CustDropdown(
                label: 'Station',
                hint: 'Enter Station',
                items: items.isEmpty ? stationListValue : items,
                selectedValue: _selectedStation,
                validator: (value) => value == null || value.isEmpty ? 'Please Select Station' : null,
                onChanged: (value) => setState(() => _selectedStation = value),
              );
            }),
            const SizedBox(height: 16),
            Obx(() => CustDropdown(
              label: 'Role', 
              hint: 'Select Role', 
              items: controller.roles.map((e) => e.name).toList(), 
              selectedValue: roleController.text.isEmpty ? null : roleController.text,
              onChanged: (v) => setState(() => roleController.text = v ?? ''),
            )),
            const SizedBox(height: 16),
            Obx(() => CustDropdown(
              label: 'Designation', 
              hint: 'Select Designation', 
              items: controller.designations.map((e) => e.name).toList(), 
              selectedValue: designationController.text.isEmpty ? null : designationController.text,
              onChanged: (v) => setState(() => designationController.text = v ?? ''),
            )),
            const SizedBox(height: 16),
            _buildShiftSelection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceDetailsSection() {
    return Container(
      key: _financeKey,
      child: AccordionCard(
        title: 'Finance Details',
        isExpanded: true,
        expanded: true,
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustText(name: 'Finance Details', size: 1.6, fontWeightName: FontWeight.w600),
            const SizedBox(height: 16),
            CustomTextField(controller: bankNameController, label: 'Bank Name', hintText: 'Enter Bank Name', textCapitalization: TextCapitalization.words),
            const SizedBox(height: 16),
            CustomTextField(controller: accountNoController, label: 'Account Number', hintText: 'Enter Account Number', keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            CustomTextField(controller: ifscController, label: 'IFSC Code', hintText: 'Enter IFSC Code', textCapitalization: TextCapitalization.characters),
            const SizedBox(height: 16),
            CustomTextField(controller: branchController, label: 'Branch Name', hintText: 'Enter Branch Name', textCapitalization: TextCapitalization.words),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressFields(
    TextEditingController house, TextEditingController locality, TextEditingController pin,
    TextEditingController city, TextEditingController state, TextEditingController country,
    {bool enabled = true}
  ) {
    country = TextEditingController(text: 'India');
    return Column(
      children: [
        CustomTextField(controller: house, label: 'Residency / House No.', hintText: 'House No / Residency', enabled: enabled, textCapitalization: TextCapitalization.words),
        const SizedBox(height: 16),
        CustomTextField(controller: locality, label: 'Locality / Town / Village', hintText: 'Locality / Town / Village', enabled: enabled, textCapitalization: TextCapitalization.words),
        const SizedBox(height: 16),
        CustomTextField(controller: pin, label: 'Pincode', hintText: 'Enter Pincode', keyboardType: TextInputType.number, enabled: enabled, maxLength: 6,),
        const SizedBox(height: 16),
        CustomTextField(controller: city, label: 'City', hintText: 'Enter City', enabled: enabled, textCapitalization: TextCapitalization.words),
        const SizedBox(height: 16),
        CustomTextField(controller: state, label: 'State', hintText: 'Enter State', enabled: enabled, textCapitalization: TextCapitalization.words),
        const SizedBox(height: 16),
        CustomTextField(controller: country, label: 'Country', hintText: 'Enter Country', enabled: enabled, textCapitalization: TextCapitalization.words),
      ],
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustText(name: 'Gender', size: 1.4, fontWeightName: FontWeight.w500, color: AppColors.textColor4),
        const SizedBox(height: 8),
        Row(
          children: [
            _genderButton('Male', "assets/images/man.png"),
            const SizedBox(width: 8),
            _genderButton('Female',"assets/images/woman.png"),
            const SizedBox(width: 8),
            _genderButton('Others', "assets/images/star.png"),
          ],
        ),
      ],
    );
  }

  Widget _genderButton(String label, String image) {
    bool isSelected = selectedGender == label;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => selectedGender = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.blue.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? AppColors.blue : AppColors.dividerColor2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image, height: 20, width: 20),
              const SizedBox(width: 8),
              CustText(name: label, size: 1.2, fontWeightName: FontWeight.w500, color: isSelected ? AppColors.blue : AppColors.textColor4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShiftSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustText(name: 'Duty Shift', size: 1.4, fontWeightName: FontWeight.w500, color: AppColors.textColor4),
        const SizedBox(height: 8),
        Row(
          children: [
            _shiftButton('Morning'),
            const SizedBox(width: 4),
            _shiftButton('Evening'),
            const SizedBox(width: 4),
            _shiftButton('Night'),
            const SizedBox(width: 4),
            _shiftButton('General'),
          ],
        ),
      ],
    );
  }

  Widget _shiftButton(String label) {
    bool isSelected = selectedShift == label;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => selectedShift = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.blue.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? AppColors.blue : AppColors.dividerColor2),
          ),
          child: Center(
            child: CustText(
              name: label, 
              size: 1.1, 
              color: isSelected ? AppColors.blue : AppColors.textColor4,
              fontWeightName: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

}
