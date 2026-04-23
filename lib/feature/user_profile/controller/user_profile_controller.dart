import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../model/user_profile_model.dart';
import '../model/master_model.dart';
import '../service/user_profile_service.dart';
import '../service/user_profile_cache_service.dart';
import '../../../service/auth_manager.dart';
import '../../../view/widgets/custom_snackbar.dart';

class UserProfileController extends GetxController with GetSingleTickerProviderStateMixin {
  final UserProfileService _service;
  final UserProfileCacheService _cacheService = UserProfileCacheService();

  UserProfileController({UserProfileService? service})
      : _service = service ?? UserProfileService();

  final RxBool isLoading = false.obs;
  final Rx<UserProfileData?> profileData = Rx<UserProfileData?>(null);
  final Rx<File?> selectedImage = Rx<File?>(null);

  final RxList<MasterCity> cities = <MasterCity>[].obs;
  final RxList<MasterDepartmentType> departmentTypes = <MasterDepartmentType>[].obs;
  final RxList<MasterRole> roles = <MasterRole>[].obs;
  final RxList<MasterDesignation> designations = <MasterDesignation>[].obs;

  final ImagePicker _picker = ImagePicker();

  // Expansion states for Profile View Accordions
  var isPersonalExpanded = true.obs;
  var isPermanentAddressExpanded = true.obs;
  var isCurrentAddressExpanded = true.obs;
  var isEmployeeExpanded = true.obs;
  var isFinanceExpanded = true.obs;

  late TabController tabController;
  final ScrollController scrollController = ScrollController();

  final GlobalKey personalKey = GlobalKey();
  final GlobalKey employeeKey = GlobalKey();
  final GlobalKey financeKey = GlobalKey();

  bool _isScrollingFromAuto = false;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    scrollController.addListener(_scrollListener);
    
    fetchProfileData();
    fetchMasterData();
  }

  @override
  void onClose() {
    tabController.dispose();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (_isScrollingFromAuto) return;

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

  Future<void> fetchMasterData() async {
    // Try to load from cache first for immediate UI update
    final cachedCities = await _cacheService.getCities();
    if (cachedCities != null) cities.value = cachedCities;

    final cachedDepts = await _cacheService.getDepartments();
    if (cachedDepts != null) departmentTypes.value = cachedDepts;

    final cachedRoles = await _cacheService.getRoles();
    if (cachedRoles != null) roles.value = cachedRoles;

    final cachedDesigs = await _cacheService.getDesignations();
    if (cachedDesigs != null) designations.value = cachedDesigs;

    try {
      final cityRes = await _service.getCities();
      if (cityRes.status) {
        cities.value = cityRes.data;
        _cacheService.saveCities(cityRes.data);
      }
    } catch (e) {
      // Ignored for individual fetch failures to allow others to continue
    }

    try {
      final deptRes = await _service.getDepartmentTypes();
      if (deptRes.status) {
        departmentTypes.value = deptRes.data;
        _cacheService.saveDepartments(deptRes.data);
      }
    } catch (e) {
      // Ignore
    }

    try {
      final roleRes = await _service.getRoles();
      if (roleRes.status) {
        roles.value = roleRes.data;
        _cacheService.saveRoles(roleRes.data);
      }
    } catch (e) {
      // Ignore
    }

    try {
      final desigRes = await _service.getDesignations();
      if (desigRes.status) {
        designations.value = desigRes.data;
        _cacheService.saveDesignations(desigRes.data);
      }
    } catch (e) {
      // Ignore
    }
  }

  Future<void> fetchProfileData() async {
    try {
      isLoading.value = true;
      
      // Load from cache first
      final cachedProfile = await _cacheService.getProfile();
      if (cachedProfile != null) {
        profileData.value = cachedProfile;
      }

      final String? userIdStr = await AuthManager().getUserId();
      
      if (userIdStr == null) {
        return;
      }
      int userId = int.parse(userIdStr);

      final response = await _service.getUserProfile(userId: userId);
      
      if (response.status && response.data != null && response.data!.isNotEmpty) {
        // Safety check: Filter by ID in case the API returns multiple users
        UserProfileData? matchedData;
        try {
          matchedData = response.data!.firstWhere((u) => u.id == userId);
        } catch (_) {
          matchedData = response.data!.first;
        }

        profileData.value = matchedData;
        _cacheService.saveProfile(matchedData);
        
        await fetchUserDetails(matchedData.uniqueCode);
      }
    } catch (e) {
      // If we have cached data, we don't necessarily need to show an error
      if (profileData.value == null) {
         CustomSnackBar.show(title: 'Offline', message: 'Showing offline data.');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserDetails(String userCode) async {
    try {
      final response = await _service.getUserDetails(userCode: userCode);
      if (response.status && response.data != null && response.data!.isNotEmpty) {
        final detailedData = response.data!.first;
        profileData.value = detailedData;
        _cacheService.saveProfile(detailedData);
      }
    } catch (e) {
      // Ignored here, errors bubbled up to main fetch
    }
  }

  Future<void> pickAndCropImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return;

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // Square crop for profile
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Profile Photo',
            toolbarColor: const Color(0xFF003366), // Match app theme
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: true,
          ),
          IOSUiSettings(
            title: 'Crop Profile Photo',
            aspectRatioPickerButtonHidden: true,
            resetButtonHidden: true,
          ),
        ],
      );

      if (croppedFile != null) {
        selectedImage.value = File(croppedFile.path);
      }
    } catch (e) {
      CustomSnackBar.show(title: 'Error', message: 'Failed to pick image: $e');
    }
  }

  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    String? contactNo,
    List<int>? stationIDs,
    List<int>? cityIDs,
    List<int>? departmentIDs,
    int? roleID,
    int? designationID,
    UserDetails? userDetails,
  }) async {
    try {
      isLoading.value = true;
      
      final String? userIdStr = await AuthManager().getUserId();
      if (userIdStr == null) throw Exception("User ID not found");
      int userId = int.parse(userIdStr);

      final Map<String, dynamic> userData = {
        "firstName": firstName,
        "lastName": lastName,
        "emailID": email,
        "contactNo": contactNo,
        "cityIDs": cityIDs ?? profileData.value?.cityIDs ?? [],
        "departmentIDs": departmentIDs ?? profileData.value?.departmentIDs ?? [],
        "stationIDs": stationIDs ?? profileData.value?.stationIDs ?? [],
        "roleID": roleID ?? profileData.value?.roleID ?? 0,
        "designationID": designationID ?? profileData.value?.designationID ?? 0,
        "isActive": profileData.value?.isActive ?? true,
        if (userDetails != null) "userDetail": userDetails.toJson(),
      };

      final response = await _service.updateUserProfile(
        userId: userId,
        userData: userData,
        profilePic: selectedImage.value,
      );

      if (response.status) {
        if (response.data != null && response.data!.isNotEmpty) {
          profileData.value = response.data!.first;
        }
        
        // Optionally fetch detailed info again after update to ensure all nested fields are correct
        if (profileData.value != null) {
          await fetchUserDetails(profileData.value!.uniqueCode);
        }
        return true;
      } else {
        throw Exception(response.message ?? 'Update failed');
      }
    } catch (e) {
      CustomSnackBar.show(
        title: 'Update Failed',
        message: e.toString(),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  int? getCityIdByName(String? name) {
    if (name == null || name.isEmpty) return null;
    try {
      return cities.firstWhere((c) => c.name.toLowerCase() == name.trim().toLowerCase()).id;
    } catch (_) {
      return null;
    }
  }

  int? getDepartmentIdByName(String? name) {
    if (name == null || name.isEmpty) return null;
    try {
      return departmentTypes.firstWhere((d) => d.name.toLowerCase() == name.trim().toLowerCase()).id;
    } catch (_) {
      return null;
    }
  }

  int? getRoleIdByName(String? name) {
    if (name == null || name.isEmpty) return null;
    try {
      return roles.firstWhere((r) => r.name.toLowerCase() == name.trim().toLowerCase()).id;
    } catch (_) {
      return null;
    }
  }

  int? getDesignationIdByName(String? name) {
    if (name == null || name.isEmpty) return null;
    try {
      return designations.firstWhere((d) => d.name.toLowerCase() == name.trim().toLowerCase()).id;
    } catch (_) {
      return null;
    }
  }

  void clearProfile() {
    profileData.value = null;
    selectedImage.value = null;
  }
}
