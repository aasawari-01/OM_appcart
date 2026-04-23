import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:om_appcart/feature/failure/controller/station_controller.dart';
import 'package:om_appcart/view/widgets/custom_snackbar.dart';
import 'package:om_appcart/view/widgets/custom_update_dialog.dart';
import '../model/lost_found_table_record.dart';
import '../service/lost_found_service.dart';
import 'lost_and_found_list_controller.dart';

class LostAndFoundFormController extends GetxController {
  final LostFoundService _service = LostFoundService();
  String mode = 'add';
  LostFoundTableRecord? initialRecord;

  final ScrollController stepScrollController = ScrollController();

  final GlobalKey<FormState> step1FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> step2FormKey = GlobalKey<FormState>();

  var currentStep = 0.obs;
  var registerAs = RxnString();
  var selectedStation = RxnString();
  var selectedDate = Rxn<DateTime>();
  
  final internalNotesController = TextEditingController();
  final passengerNameController = TextEditingController();
  final contactNoController = TextEditingController();
  final articleLostController = TextEditingController();
  final articleLostPlaceController = TextEditingController();
  final addressController = TextEditingController();
  final articleFoundController = TextEditingController();
  final articleFoundPlaceController = TextEditingController();

  var selectedColor = RxnString();
  var selectedCategory = RxnString();
  final quantityController = TextEditingController();
  final estimateValueController = TextEditingController();
  final descriptionController = TextEditingController();

  // Verification fields
  var verifiedColor = RxnString();
  var verifiedIdProof = RxnString();
  final verifiedUniqueIdController = TextEditingController();
  final verifiedDescriptionController = TextEditingController();

  // Handover fields
  var handoverDate = Rxn<DateTime>();
  final handoverToNameController = TextEditingController();
  final remarksController = TextEditingController();

  RxList<dynamic> attachedFiles = <dynamic>[].obs;
  var isLoading = false.obs;

  // Match related
  var showMatchResult = false.obs;
  var selectedMatchItems = Rxn<List<dynamic>>();
  var autoMatchResult = Rxn<Map<String, dynamic>>();
  var isAutoMatching = false.obs;
  var visibleItemsCount = 0.obs;

  final List<String> registerAsOptions = ['Lost', 'Found'];
  final List<String> basicColorList = ['Red', 'Blue', 'Green', 'Black', 'White', 'Yellow', 'Other'];
  final List<String> categoryList = ['Electronics', 'Clothing', 'Documents', 'Bag', 'Wallet', 'Water bottle', 'Other'];
  final List<String> idProofList = ['Aadhar Card', 'PAN Card', 'Driving License', 'Voter ID', 'Passport', 'Other'];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      mode = args['mode'] ?? 'add';
      initialRecord = args['record'];
    }

    if (mode == 'edit' && initialRecord != null) {
      _populateFields(initialRecord!);
    }
  }

  void _populateFields(LostFoundTableRecord record) {
    registerAs.value = record.registerAs;
    selectedStation.value = Get.find<StationController>().getStationNameById(record.stationID) ?? record.stations?.name;
    selectedDate.value = record.date;
    internalNotesController.text = record.internalNotes ?? '';

    if (record.registerAs == 'Lost') {
      passengerNameController.text = record.passengerName ?? '';
      contactNoController.text = record.contactNo ?? '';
      articleLostController.text = record.articleLost ?? '';
      articleLostPlaceController.text = record.articleLostPlace ?? '';
      addressController.text = record.address ?? '';
    } else {
      articleFoundController.text = record.articleFound ?? '';
      articleFoundPlaceController.text = record.articleFoundPlace ?? '';
    }

    selectedColor.value = record.color;
    selectedCategory.value = record.category;
    quantityController.text = record.quantity?.toString() ?? '';
    estimateValueController.text = record.estimateValue ?? '';
    descriptionController.text = record.description ?? '';

    verifiedColor.value = record.verifiedColor;
    verifiedIdProof.value = record.verifiedIdProof;
    verifiedUniqueIdController.text = record.verifiedUniqueIdentification ?? '';
    verifiedDescriptionController.text = record.verifiedDescription ?? '';

    handoverDate.value = record.handoverDate;
    handoverToNameController.text = record.handoverToName ?? '';
    remarksController.text = record.remarks ?? '';

    if (record.matches != null) {
      selectedMatchItems.value = [record.matches!];
      showMatchResult.value = true;
    }

    attachedFiles.assignAll(record.foundAttachments);
  }

  void nextStep() {
    if (currentStep.value == 0) {
      if (step1FormKey.currentState?.validate() ?? false) {
        currentStep.value++;
      }
    } else if (currentStep.value == 1) {
      if (step2FormKey.currentState?.validate() ?? false) {
        currentStep.value++;
      }
    } else {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  Future<void> submitForm({String? updateRemark}) async {
    // Basic validation based on registerAs
    if (registerAs.value == null) {
      CustomSnackBar.show(title: 'Error', message: 'Please select Register As');
      return;
    }

    final stationController = Get.find<StationController>();
    int? stationId = stationController.getStationIdByName(selectedStation.value!);

    final Map<String, dynamic> data = {
      'registerAs': registerAs.value,
      'stationID': stationId,
      'date': selectedDate.value?.toIso8601String(),
      'internalNotes': internalNotesController.text,
      'color': selectedColor.value,
      'category': selectedCategory.value,
      'quantity': int.tryParse(quantityController.text),
      'estimateValue': estimateValueController.text,
      'description': descriptionController.text,
    };

    if (registerAs.value == 'Lost') {
      data.addAll({
        'passengerName': passengerNameController.text,
        'contactNo': contactNoController.text,
        'articleLost': articleLostController.text,
        'articleLostPlace': articleLostPlaceController.text,
        'address': addressController.text,
      });
    } else {
      data.addAll({
        'articleFound': articleFoundController.text,
        'articleFoundPlace': articleFoundPlaceController.text,
      });
    }

    if (mode == 'edit') {
      data['remark'] = updateRemark ?? '';
      // Add verification/handover fields if they are visible in edit mode
      if (initialRecord!.matchStatus >= 3) {
        data.addAll({
          'verifiedColor': verifiedColor.value,
          'verifiedIdProof': verifiedIdProof.value,
          'verifiedUniqueIdentification': verifiedUniqueIdController.text,
          'verifiedDescription': verifiedDescriptionController.text,
          'handoverDate': handoverDate.value?.toIso8601String(),
          'handoverToName': handoverToNameController.text,
          'remarks': remarksController.text,
        });

        if (selectedMatchItems.value != null && selectedMatchItems.value!.isNotEmpty) {
           final matchedItem = selectedMatchItems.value!.first;
           data['matchedID'] = matchedItem is LostFoundTableRecord ? matchedItem.id : (matchedItem['found_item']?['id'] ?? matchedItem['id']);
        }
      }
    }

    try {
      isLoading.value = true;
      Map<String, dynamic> response;

      List<File> files = attachedFiles
          .where((file) => file is File)
          .map((file) => file as File)
          .toList();

      if (mode == 'edit') {
        response = await _service.updateLostFound(initialRecord!.id, data, files);
      } else {
        response = await _service.createLostFound(data, files);
      }

      if (response['status'] == true) {
        Get.find<LostAndFoundListController>().refreshItems();
        Get.back(result: true);
        CustomSnackBar.show(
          title: 'Success',
          message: response['message'] ?? (mode == 'edit' ? 'Updated successfully' : 'Created successfully'),
          isError: false,
        );
      }
    } catch (e) {
      CustomSnackBar.show(title: 'Error', message: e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startAutoMatch() async {
    if (initialRecord == null) return;
    
    isAutoMatching.value = true;
    autoMatchResult.value = null;
    visibleItemsCount.value = 0;

    try {
      final result = await _service.autoMatch(initialRecord!.uniqueCode);
      autoMatchResult.value = {
        ...?result['data'],
        'totalRecords': result['totalRecords'] ?? 0,
      };
    } catch (e) {
      CustomSnackBar.show(title: 'Error', message: 'Auto-match failed: $e');
    } finally {
      isAutoMatching.value = false;
    }
  }

  @override
  void onClose() {
    internalNotesController.dispose();
    passengerNameController.dispose();
    contactNoController.dispose();
    articleLostController.dispose();
    articleLostPlaceController.dispose();
    addressController.dispose();
    articleFoundController.dispose();
    articleFoundPlaceController.dispose();
    quantityController.dispose();
    estimateValueController.dispose();
    descriptionController.dispose();
    verifiedUniqueIdController.dispose();
    verifiedDescriptionController.dispose();
    handoverToNameController.dispose();
    remarksController.dispose();
    stepScrollController.dispose();
    super.onClose();
  }
}
