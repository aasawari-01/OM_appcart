import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'station_controller.dart';
import '../../user_profile/service/user_profile_service.dart';
import '../service/failure_master_service.dart';
import '../model/failure_master_model.dart';
import '../../user_profile/model/master_model.dart';
import '../../user_profile/model/user_profile_model.dart';

class FailureFormController extends GetxController {
  final FailureMasterService _masterService = FailureMasterService();
  final UserProfileService _userProfileService = UserProfileService();
  final StationController _stationController = Get.find<StationController>();

  // --- Master Data Lists ---
  var categoryTypes = <FailureCategoryType>[].obs;
  var departments = <MasterDepartmentType>[].obs;
  var locations = <FailureLocation>[].obs;
  var functionalLocations = <FailureFunctionLocation>[].obs;
  var allSubLocations = <FailureSubLocation>[].obs;
  var filteredSubLocations = <FailureSubLocation>[].obs;
  var users = <UserProfileData>[].obs;
  var objectParts = <ObjectPart>[].obs;
  var faults = <Fault>[].obs;
  var rootCauses = <RootCause>[].obs;
  var materials = <FailureMaterial>[].obs;
  var actionTakens = <FailureActionTaken>[].obs;
  var storeLocations = <StoreLocation>[].obs;

  var isLoadingMasters = false.obs;

  // --- Master Data Getters ---
  List<String> get stationNames => _stationController.stationNames;
  List<String> get categoryTypeNames => categoryTypes.map((e) => e.name).toList();
  List<String> get departmentNames => departments.map((e) => e.name).toList();
  List<String> get locationNames => locations.map((e) => e.name).toList();
  List<String> get functionalLocationNames => functionalLocations.map((e) => e.name).toList();
  List<String> get filteredSubLocationNames => filteredSubLocations.map((e) => e.name).toList();
  List<String> get userNames => users.map((u) => "${u.firstName} ${u.lastName}").toList();
  List<String> get objectPartDescriptions => objectParts.map((e) => e.description).toList();
  List<String> get faultDescriptions => faults.map((e) => e.description).toList();
  List<String> get rootCauseDescriptions => rootCauses.map((e) => e.description).toList();
  List<String> get materialNames => materials.map((e) => "${e.grpCode} - ${e.code} - ${e.name}").toList();
  List<String> get actionTakenNames => actionTakens.map((e) => e.description).toList();
  List<String> get storeLocationNames => storeLocations.map((e) => "${e.grpCode} - ${e.code} - ${e.description}").toList();

  // --- Toggle States ---
  var isTripAffectedOn = false.obs;
  var isTrainReplaceOn = false.obs;
  var isPassengerDeboardingOn = false.obs;
  var isPassengerAffectedOn = false.obs;
  var isPtwRequestOn = false.obs;
  var isMaterialFailureTypeOn = false.obs;
  var isJoinInspectionOn = false.obs;

  // Accordion 1: Failure Detail
  // Dropdowns (RxStrings)
  var selectedStation = RxnString();
  var selectedCategoryType = RxnString();
  var selectedPriority = RxnString();
  var selectedDepartment = RxnString();
  var selectedLocation = RxnString();
  var selectedFunctionalLocation = RxnString();
  var selectedSublocation = RxnString();
  var selectedTrainId = RxnString();
  var selectedReportedBy = RxnString();
  var selectedReportedTo = RxnString();
  var selectedPersonResponsible = RxnString();

  // TextFields & DatePickers
  final systemController = TextEditingController();
  final equipmentNoController = TextEditingController();
  final failureDescriptionController = TextEditingController();

  var actualOccurrenceDate = ''.obs;
  var actualCompletedOnDate = ''.obs;

  // Accordion 2: Trip Affected & Replace (Combined)
  final tripDelayUplineController = TextEditingController();
  final tripCancelController = TextEditingController();
  final tripDelayDownlineController = TextEditingController();
  final tripDelayInMinController = TextEditingController();
  final tripWithdrawalController = TextEditingController();
  final tripReplaceTextFieldController = TextEditingController();
  
  // From former Section 3 (now part of Section 2)
  final replaceWithController = TextEditingController();
  var replaceTimeDate = ''.obs;
  final trainReplaceController = TextEditingController();
  
  // Passenger Deboarding
  final passengerDeboardedController = TextEditingController();

  // Accordion 3: Passenger Affected
  final passengerAffectedNumbersController = TextEditingController();
  var trappedDuration = ''.obs;
  var rescuedDuration = ''.obs;

  // Accordion 4 & 6: Attachments
  var beforeAttachments = <dynamic>[].obs; // Using dynamic for File compatibility
  var afterAttachments = <dynamic>[].obs;

  // Accordion 5: Acknowledgement
  final failureRemarkController = TextEditingController();
  var selectedTechnician = RxnString();

  // Accordion 7: RCA Detail
  var rcaList = <Map<String, String>>[].obs;
  var rootCauseList = <Map<String, String>>[].obs;
  var rcaAttachments = <dynamic>[].obs;
  
  // Accordion 8: PTW Request
  final ptwNumberController = TextEditingController();

  // Accordion 9: Material Failure Type
  final List<String> materialFailureTypes = ['Software', 'Hardware', 'Other'];
  var selectedMaterialFailureType = RxnString();
  var sparePartsList = <Map<String, String>>[].obs;
  
  var isAddingSparePart = false.obs;
  var selectedSpareMaterialCode = RxnString();
  var selectedSpareStoreLocation = RxnString();
  final spareRequiredQtyController = TextEditingController();
  final spareBalanceQtyController = TextEditingController();
  int? editingSparePartIndex;

  List<String> get addedSparePartMaterialCodes => sparePartsList.map((e) => e['materialCode']!).toSet().toList();

  // Accordion 10: Material Dismantle
  var materialDismantleList = <Map<String, String>>[].obs;

  // RCA Bottom Sheet Temporary State
  var isAddingRootCause = false.obs;
  var selectedRcaObjectPart = RxnString();
  final rcaObjectPartDescController = TextEditingController();
  var selectedRcaFault = RxnString();
  final rcaFaultDescController = TextEditingController();
  
  var selectedRcaRootCause = RxnString();
  var selectedLinkedRca = RxnString();
  final rcaRootCauseTextController = TextEditingController();
  var selectedRcaActionTaken = RxnString();
  final rcaActionTakenTextController = TextEditingController();

  var tempRcaDetails = <Map<String, String>>[].obs;

  int? editingRcaIndex;
  int? editingRootCauseIndex;

  // Accordion 11: Join Inspection
  var selectedJoinDepartment = RxnString();
  var selectedJoinAssignTo = RxnString();
  final joinInspectionRemarkController = TextEditingController();

  // Accordion 12: Activity
  final rectificationDetailController = TextEditingController();
  var selectedUserStatus = RxnString();
  var failureAttendedDate = ''.obs;
  var actualFailureRectifiedDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    currentStep.value = 0; // Fixes step state persistence across navigation
    fetchMasterData();

    // Listener for Sub-location filtering
    ever(selectedLocation, (String? locationName) {
      if (locationName == null || locationName.isEmpty) {
        filteredSubLocations.assignAll(allSubLocations);
      } else {
        try {
          final loc = locations.firstWhere((l) => l.name == locationName);
          filteredSubLocations.assignAll(
            allSubLocations.where((s) => s.locationID == loc.id).toList()
          );
        } catch (e) {
          filteredSubLocations.assignAll(allSubLocations);
        }
      }
      // Reset sublocation if it's no longer in the filtered list
      if (selectedSublocation.value != null && 
          !filteredSubLocations.any((s) => s.name == selectedSublocation.value)) {
        selectedSublocation.value = null;
      }
    });
  }

  Future<void> fetchMasterData() async {
    try {
      isLoadingMasters.value = true;
      
      // Stations are handled by StationController
      if (_stationController.stations.isEmpty) {
        await _stationController.fetchStations();
      }

      // Fetch other masters in parallel
      final results = await Future.wait([
        _masterService.getCategoryTypes(),
        _userProfileService.getDepartmentTypes(),
        _masterService.getLocations(),
        _masterService.getFunctionLocations(),
        _masterService.getSubLocations(),
        _userProfileService.getUsers(),
        _masterService.getObjectParts(),
        _masterService.getFaults(),
        _masterService.getRootCauses(),
        _masterService.getMaterials(),
        _masterService.getActionTaken(),
        _masterService.getStoreLocations(),
      ]);

      categoryTypes.assignAll((results[0] as FailureCategoryResponse).data);
      departments.assignAll((results[1] as DepartmentTypeResponse).data);
      locations.assignAll((results[2] as FailureLocationResponse).data);
      functionalLocations.assignAll((results[3] as FailureFunctionLocationResponse).data);
      allSubLocations.assignAll((results[4] as FailureSubLocationResponse).data);
      filteredSubLocations.assignAll(allSubLocations);
      users.assignAll((results[5] as UserProfileResponse).data ?? []);
      objectParts.assignAll((results[6] as ObjectPartResponse).data);
      faults.assignAll((results[7] as FaultResponse).data);
      rootCauses.assignAll((results[8] as RootCauseResponse).data);
      materials.assignAll((results[9] as FailureMaterialResponse).data);
      actionTakens.assignAll((results[10] as FailureActionTakenResponse).data);
      storeLocations.assignAll((results[11] as StoreLocationResponse).data);

    } catch (e) {
      Get.snackbar('Error', 'Failed to load master data: $e', 
                   snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingMasters.value = false;
    }
  }

  @override
  void onClose() {
    // Accordion 1 & 2 cleanup
    systemController.dispose();
    equipmentNoController.dispose();
    failureDescriptionController.dispose();
    tripDelayUplineController.dispose();
    tripCancelController.dispose();
    tripDelayDownlineController.dispose();
    tripDelayInMinController.dispose();
    tripWithdrawalController.dispose();
    tripReplaceTextFieldController.dispose();
    replaceWithController.dispose();
    trainReplaceController.dispose();
    passengerDeboardedController.dispose();

    // Accordion 3+ cleanup
    passengerAffectedNumbersController.dispose();
    failureRemarkController.dispose();
    ptwNumberController.dispose();
    joinInspectionRemarkController.dispose();
    rectificationDetailController.dispose();

    // RCA Temporary Controllers cleanup
    rcaObjectPartDescController.dispose();
    rcaFaultDescController.dispose();
    rcaRootCauseTextController.dispose();
    rcaActionTakenTextController.dispose();

    // Spare Parts Temp Controllers cleanup
    spareRequiredQtyController.dispose();
    spareBalanceQtyController.dispose();

    super.onClose();
  }

  // --- Stepper Logic ---
  var currentStep = 0.obs;

  void nextStep() {
    if (currentStep.value < 11) currentStep.value++;
  }

  void previousStep() {
    if (currentStep.value > 0) currentStep.value--;
  }

  void submitForm() {
    print("UI Only - API Submission Not Handled Yet");
  }

  // RCA Helper Methods
  void clearRcaTempState() {
    isAddingRootCause.value = false;
    selectedRcaObjectPart.value = null;
    rcaObjectPartDescController.clear();
    selectedRcaFault.value = null;
    rcaFaultDescController.clear();
    
    selectedLinkedRca.value = null;
    selectedRcaRootCause.value = null;
    rcaRootCauseTextController.clear();
    selectedRcaActionTaken.value = null;
    rcaActionTakenTextController.clear();
    tempRcaDetails.clear();
    editingRcaIndex = null;
    editingRootCauseIndex = null;
  }

  void saveRca() {
    if (selectedRcaObjectPart.value == null || selectedRcaFault.value == null) {
      Get.snackbar('Error', 'Please select both Object Part and Fault',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.withOpacity(0.1));
      return;
    }
    
    final newRca = {
      'id': editingRcaIndex != null ? rcaList[editingRcaIndex!]['id']! : DateTime.now().millisecondsSinceEpoch.toString(),
      'objectPart': selectedRcaObjectPart.value ?? '',
      'objectPartDesc': rcaObjectPartDescController.text,
      'fault': selectedRcaFault.value ?? '',
      'faultDesc': rcaFaultDescController.text,
    };

    if (editingRcaIndex != null) {
      // Need to update dependent root causes if the RCA identifier changed
      final oldRca = rcaList[editingRcaIndex!];
      final oldIdentifier = "${oldRca['objectPart']} - ${oldRca['fault']}";
      final newIdentifier = "${newRca['objectPart']} - ${newRca['fault']}";
      
      if (oldIdentifier != newIdentifier) {
        for (int i = 0; i < rootCauseList.length; i++) {
          if (rootCauseList[i]['rcaId'] == oldIdentifier) {
            rootCauseList[i]['rcaId'] = newIdentifier;
          }
        }
      }
      rcaList[editingRcaIndex!] = newRca;
    } else {
      rcaList.add(newRca);
    }
    
    // Reset RCA fields
    selectedRcaObjectPart.value = null;
    rcaObjectPartDescController.clear();
    selectedRcaFault.value = null;
    rcaFaultDescController.clear();
    editingRcaIndex = null;
  }

  void saveRootCause() {
    if (selectedLinkedRca.value == null ||
        selectedRcaRootCause.value == null ||
        selectedRcaActionTaken.value == null) {
      Get.snackbar('Error', 'Please select RCA, Root Cause and Action Taken',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.withOpacity(0.1));
      return;
    }
    
    final newRootCause = {
      'rcaId': selectedLinkedRca.value ?? '',
      'rootCause': selectedRcaRootCause.value ?? '',
      'rootCauseText': rcaRootCauseTextController.text,
      'actionTaken': selectedRcaActionTaken.value ?? '',
      'actionTakenText': rcaActionTakenTextController.text,
    };

    if (editingRootCauseIndex != null) {
      rootCauseList[editingRootCauseIndex!] = newRootCause;
    } else {
      rootCauseList.add(newRootCause);
    }

    // Clear root cause fields
    selectedLinkedRca.value = null;
    selectedRcaRootCause.value = null;
    rcaRootCauseTextController.clear();
    selectedRcaActionTaken.value = null;
    rcaActionTakenTextController.clear();
    isAddingRootCause.value = false;
    editingRootCauseIndex = null;
  }

  void removeRca(int index) {
    if (index >= 0 && index < rcaList.length) {
      final rca = rcaList[index];
      final rcaIdentifier = "${rca['objectPart']} - ${rca['fault']}";
      
      // Cascading delete for related root causes
      rootCauseList.removeWhere((rc) => rc['rcaId'] == rcaIdentifier);
      
      // Remove the RCA itself
      rcaList.removeAt(index);
    }
  }

  // finalizeRcaEntry is no longer used in the new flow as saveRca/saveRootCause push directly to final lists.

  // Spare Parts Helper Methods
  void clearSparePartTempState() {
    isAddingSparePart.value = false;
    selectedSpareMaterialCode.value = null;
    selectedSpareStoreLocation.value = null;
    spareRequiredQtyController.clear();
    spareBalanceQtyController.clear();
    editingSparePartIndex = null;
  }

  void saveSparePart() {
    if (selectedSpareMaterialCode.value == null) {
      Get.snackbar('Error', 'Please select Material Code',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.withOpacity(0.1));
      return;
    }

    final newSparePart = {
      'materialCode': selectedSpareMaterialCode.value ?? '',
      'storeLocation': selectedSpareStoreLocation.value ?? '',
      'requiredQty': spareRequiredQtyController.text,
      'balanceQty': spareBalanceQtyController.text,
    };

    if (editingSparePartIndex != null) {
      sparePartsList[editingSparePartIndex!] = newSparePart;
    } else {
      sparePartsList.add(newSparePart);
    }
  }

  void removeSparePart(int index) {
    if (index >= 0 && index < sparePartsList.length) {
      sparePartsList.removeAt(index);
    }
  }
}
