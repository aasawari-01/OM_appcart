import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:om_appcart/feature/failure/controller/station_controller.dart';
import 'package:om_appcart/feature/user_profile/controller/user_profile_controller.dart';
import 'package:om_appcart/feature/user_profile/model/user_profile_model.dart';
import 'package:om_appcart/utils/app_date_utils.dart';
import 'package:om_appcart/utils/network_utils.dart';
import 'package:om_appcart/view/widgets/custom_confirmation_dialog.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:om_appcart/view/widgets/custom_dialog.dart';
import 'package:om_appcart/constants/colors.dart';

import '../../../view/widgets/custom_snackbar.dart';

class EditProfileController extends GetxController with GetSingleTickerProviderStateMixin {
  final UserProfileController profileController = Get.find<UserProfileController>();
  
  late TabController tabController;
  final ScrollController scrollController = ScrollController();

  final GlobalKey personalKey = GlobalKey();
  final GlobalKey employeeKey = GlobalKey();
  final GlobalKey financeKey = GlobalKey();

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

  var selectedGender = 'Male'.obs;
  var selectedShift = 'Morning'.obs;
  var sameAsCurrent = false.obs;

  var selectedStation = Rx<String?>('');
  var stationListValue = <String>[].obs;

  bool _isScrollingFromAuto = false;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    scrollController.addListener(_scrollListener);
    
    // Ensure master data is being fetched/refreshed
    Get.find<StationController>().fetchStations();
    profileController.fetchMasterData();
    
    _loadInitialData();
  }

  @override
  void onClose() {
    tabController.dispose();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    
    firstNameController.dispose();
    lastNameController.dispose();
    empNoController.dispose();
    contactNoController.dispose();
    altContactNoController.dispose();
    emailController.dispose();
    dobController.dispose();
    bloodGroupController.dispose();
    birthPlaceController.dispose();
    panCardController.dispose();
    aadharCardController.dispose();
    resHouseNoController.dispose();
    localityController.dispose();
    pincodeController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    pResHouseNoController.dispose();
    pLocalityController.dispose();
    pPincodeController.dispose();
    pCityController.dispose();
    pStateController.dispose();
    pCountryController.dispose();
    dojController.dispose();
    empCityController.dispose();
    deptController.dispose();
    stationController.dispose();
    roleController.dispose();
    designationController.dispose();
    bankNameController.dispose();
    accountNoController.dispose();
    ifscController.dispose();
    branchController.dispose();
    
    super.onClose();
  }

  void _scrollListener() {
    if (_isScrollingFromAuto) return;

    final personalOffset = _getOffset(personalKey);
    final employeeOffset = _getOffset(employeeKey);
    final financeOffset = _getOffset(financeKey);

    if (scrollController.offset >= (financeOffset - 100)) {
      if (tabController.index != 2) tabController.animateTo(2);
    } else if (scrollController.offset >= (employeeOffset - 100)) {
      if (tabController.index != 1) tabController.animateTo(1);
    } else {
      if (tabController.index != 0) tabController.animateTo(0);
    }
  }

  double _getOffset(GlobalKey key) {
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return 0;
    return renderBox.localToGlobal(Offset.zero, ancestor: null).dy + scrollController.offset - 250; 
  }

  void scrollToSection(int index) {
    _isScrollingFromAuto = true;
    tabController.animateTo(index);
    
    GlobalKey targetKey;
    switch (index) {
      case 0: targetKey = personalKey; break;
      case 1: targetKey = employeeKey; break;
      case 2: targetKey = financeKey; break;
      default: targetKey = personalKey;
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

  String capitalizefirst(String? value) {
    if (value == null || value.isEmpty) return '';
    return value.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  void _loadInitialData() {
    final data = profileController.profileData.value;
    if (data != null) {
      firstNameController.text = capitalizefirst(data.firstName);
      lastNameController.text = capitalizefirst(data.lastName);
      emailController.text = data.emailID;
      contactNoController.text = data.contactNo ?? '';
      empNoController.text = data.userDetails?.employeeID ?? data.uniqueCode;
      
      final details = data.userDetails;
      if (details != null) {
        dobController.text = details.dateOfBirth ?? '';
        dojController.text = details.dateOfJoining ?? '';

        bloodGroupController.text = (details.bloodGroup ?? '').toUpperCase();
        birthPlaceController.text = capitalizefirst(details.birthPlace);
        panCardController.text = (details.panCardNo ?? '').toUpperCase();
        aadharCardController.text = details.aadharCardNo ?? '';
        altContactNoController.text = details.alternateContactNo ?? '';
        selectedGender.value = details.gender ?? 'Male';
        selectedShift.value = details.shiftType ?? 'Morning';
        
        void parseAddress(String? addressStr, TextEditingController house, TextEditingController locality, TextEditingController pin, TextEditingController city, TextEditingController state, TextEditingController country) {
          if (addressStr == null || addressStr.isEmpty) return;
          List<String> parts = addressStr.split('|');
          if (parts.length == 6) {
            house.text = capitalizefirst(parts[0]);
            locality.text = capitalizefirst(parts[1]);
            pin.text = parts[2]; 
            city.text = capitalizefirst(parts[3]);
            state.text = capitalizefirst(parts[4]);
            country.text = capitalizefirst(parts[5]);
          } else {
            List<String> commaParts = addressStr.split(', ').map((e) => e.trim()).toList();
            if (commaParts.isNotEmpty) house.text = capitalizefirst(commaParts[0]);
            if (commaParts.length > 1) locality.text = capitalizefirst(commaParts[1]);
            if (commaParts.length > 2) city.text = capitalizefirst(commaParts[2]);
            if (commaParts.length > 3) state.text = capitalizefirst(commaParts[3]);
            if (commaParts.length > 4) pin.text = commaParts[4];
          }
        }

        parseAddress(details.currentAddress, resHouseNoController, localityController, pincodeController, cityController, stateController, countryController);
        parseAddress(details.permanentAddress, pResHouseNoController, pLocalityController, pPincodeController, pCityController, pStateController, pCountryController);

        bool isPermanentEmpty = details.permanentAddress == null || details.permanentAddress!.trim().isEmpty;
        bool isBothSame = resHouseNoController.text == pResHouseNoController.text &&
                          localityController.text == pLocalityController.text &&
                          pincodeController.text == pPincodeController.text &&
                          cityController.text == pCityController.text &&
                          stateController.text == pStateController.text &&
                          countryController.text == pCountryController.text;

        if (isPermanentEmpty || isBothSame) {
          toggleSameAsCurrent(true);
        } else {
          sameAsCurrent.value = false;
        }
      }

      if (data.cities != null && data.cities!.isNotEmpty) empCityController.text = data.cities!.first.name;
      if (data.departments != null && data.departments!.isNotEmpty) deptController.text = data.departments!.first.name;
      if (data.stations != null && data.stations!.isNotEmpty) selectedStation.value = data.stations!.first.name;
      if (data.role != null) roleController.text = data.role!.name;
      if (data.designation != null) designationController.text = data.designation!.name;
    }
  }

  void toggleSameAsCurrent(bool? val) {
    sameAsCurrent.value = val ?? false;
    if (sameAsCurrent.value) {
      pResHouseNoController.text = resHouseNoController.text;
      pLocalityController.text = localityController.text;
      pPincodeController.text = pincodeController.text;
      pCityController.text = cityController.text;
      pStateController.text = stateController.text;
      pCountryController.text = countryController.text;
    }
  }

  Future<void> handleUpdate() async {
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

    final stationController = Get.find<StationController>();
    int? stationID = stationController.getStationIdByName(selectedStation.value);
    
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
      permanentAddress: sameAsCurrent.value ? 
        joinAddress(
          resHouseNoController, localityController, pincodeController, 
          cityController, stateController, countryController
        ) : 
        joinAddress(
          pResHouseNoController, pLocalityController, pPincodeController, 
          pCityController, pStateController, pCountryController
        ),
      alternateContactNo: altContactNoController.text,
      gender: selectedGender.value,
      aadharCardNo: aadharCardController.text,
      panCardNo: panCardController.text,
      shiftType: selectedShift.value,
    );

    int? cityId = profileController.getCityIdByName(empCityController.text);
    int? deptId = profileController.getDepartmentIdByName(deptController.text);
    int? roleId = profileController.getRoleIdByName(roleController.text);
    int? desigId = profileController.getDesignationIdByName(designationController.text);

    bool success = await profileController.updateProfile(
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
      Get.back(); // Go back to Profile View
      CustomSnackBar.show(
        title: 'Success', 
        message: 'Profile updated successfully',
        isError: false,
      );
    }
  }
}
