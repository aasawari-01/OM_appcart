import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import 'package:om_appcart/constants/app_constants.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/view/widgets/custom_app_bar.dart';
import 'package:om_appcart/view/widgets/accordion_card.dart';
import 'package:om_appcart/view/widgets/cust_text.dart';
import 'package:om_appcart/view/widgets/cust_button.dart';
import 'package:om_appcart/view/widgets/cust_textfield.dart';
import 'package:om_appcart/view/widgets/cust_dropdown.dart';
import 'package:om_appcart/view/widgets/cust_date_time_picker.dart';
import 'package:om_appcart/utils/app_date_utils.dart';
import 'package:om_appcart/view/widgets/file_upload_section.dart';
import 'package:om_appcart/view/widgets/custom_form_dialog.dart';
import 'package:om_appcart/view/widgets/cust_switch.dart';
import 'dart:io';

import '../controller/failure_form_controller.dart';

class FailureForm extends StatefulWidget {
  const FailureForm({super.key});

  @override
  State<FailureForm> createState() => _FailureFormState();
}

class _FailureFormState extends State<FailureForm> {
  late final FailureFormController controller;

  @override
  void initState() {
    super.initState();
    // Guarantee strict reset and isolation
    if (Get.isRegistered<FailureFormController>()) {
      Get.delete<FailureFormController>();
    }
    controller = Get.put(FailureFormController());
  }

  @override
  void dispose() {
    Get.delete<FailureFormController>();
    super.dispose();
  }

  List<Widget> _getSteps() {
    return [
      _buildFailureDetailStep(),
      _buildTripAffectedStep(),
      _buildPassengerAffectedStep(),
      _buildBeforeAttachmentStep(),
      _buildAcknowledgementStep(),
      _buildAfterAttachmentStep(),
      _buildRCADetailStep(),
      _buildPTWRequestStep(),
      _buildMaterialFailureTypeStep(),
      _buildMaterialDismantleStep(),
      _buildJoinInspectionStep(),
      _buildActivityStep(),
    ];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 40),
        child: Obx(() {
          final steps = _getSteps();
          return CustomAppBar(
            title: "Failure Report",
            isForm: true,
            showDrawer: false,
            currentStep: controller.currentStep.value,
            totalSteps: steps.length,
            onLeadingPressed: () => Get.back(),
          );
        }),
      ),
      body: Obx(() {
        final steps = _getSteps();
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.horizontalPadding, 
                      vertical: AppConstants.verticalPadding
                    ),
                    child: steps[controller.currentStep.value.clamp(0, steps.length - 1)],
                  ),
                ),
                _buildNavigationButtons(context, steps),
              ],
            ),
            if (controller.isLoadingMasters.value)
              Container(
                color: Colors.white.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, List<Widget> steps) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (controller.currentStep.value > 0)
              CustOutlineButton(
                name: 'Back',
                onSelected: (_) => controller.previousStep(),
              ),
            const Spacer(),
            if (controller.currentStep.value < steps.length - 1)
              CustButton(
                name: 'Next',
                onSelected: (_) => controller.nextStep(),
              )
            else
              CustButton(
                name: 'Submit',
                onSelected: (_) {
                  controller.submitForm();
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFailureDetailStep() {
    return Obx(() => AccordionCard(
      title: "Failure Detail",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustDropdown(
            label: 'Station',
            hint: 'Select Station',
            items: controller.stationNames, 
            selectedValue: controller.selectedStation.value,
            onChanged: (v) => controller.selectedStation.value = v,
          ),
          const SizedBox(height: AppConstants.elementSpacing),
          CustDropdown(
            label: 'Failure Category Type',
            hint: 'Select Category',
            items: controller.categoryTypeNames, 
            selectedValue: controller.selectedCategoryType.value,
            onChanged: (v) => controller.selectedCategoryType.value = v,
          ),
          const SizedBox(height: AppConstants.elementSpacing),
          CustDropdown(
            label: 'Priority',
            hint: 'Select Priority',
            items: const ['Low', 'Medium', 'High', 'Critical'], 
            selectedValue: controller.selectedPriority.value,
            onChanged: (v) => controller.selectedPriority.value = v,
          ),
          const SizedBox(height: AppConstants.elementSpacing),
          CustDropdown(
            label: 'Department',
            hint: 'Select Department',
            items: controller.departmentNames, 
            selectedValue: controller.selectedDepartment.value,
            onChanged: (v) => controller.selectedDepartment.value = v,
          ),
          const SizedBox(height: AppConstants.elementSpacing),
          CustDropdown(
            label: 'Location',
            hint: 'Select Location',
            items: controller.locationNames, 
            selectedValue: controller.selectedLocation.value,
            onChanged: (v) => controller.selectedLocation.value = v,
          ),
          const SizedBox(height: AppConstants.elementSpacing),
          CustDropdown(
            label: 'Functional Location',
            hint: 'Select Functional Location',
            items: controller.functionalLocationNames, 
            selectedValue: controller.selectedFunctionalLocation.value,
            onChanged: (v) => controller.selectedFunctionalLocation.value = v,
          ),
          const SizedBox(height: AppConstants.elementSpacing),
          CustDropdown(
            label: 'Sublocation',
            hint: 'Select Sublocation',
            items: controller.filteredSubLocationNames, 
            selectedValue: controller.selectedSublocation.value,
            onChanged: (v) => controller.selectedSublocation.value = v,
          ),
          const SizedBox(height: AppConstants.elementSpacing),
          CustomTextField(
            controller: controller.systemController,
            label: 'System',
            hintText: 'Enter System',
          ),
          const SizedBox(height: AppConstants.elementSpacing),
          CustDropdown(
            label: 'Train Id',
            hint: 'Select Train Id',
            items: const ['TRN-001', 'TRN-002'], 
            selectedValue: controller.selectedTrainId.value,
            onChanged: (v) => controller.selectedTrainId.value = v,
          ),
          const SizedBox(height: AppConstants.elementSpacing),
          CustDateTimePicker(
            label: 'Actual Failure Occurrence',
            hint: 'Select Date/Time',
            selectedDateTime: controller.actualOccurrenceDate.value.isEmpty ? null : AppDateUtils.parseDate(controller.actualOccurrenceDate.value),
            pickerType: CustDateTimePickerType.date,
            onDateTimeSelected: (date) {
              if (date != null) {
                controller.actualOccurrenceDate.value = AppDateUtils.formatDate(date);
              }
            },
          ),
          const SizedBox(height: AppConstants.elementSpacing),
          CustDropdown(
            label: 'Failure Reported By',
            hint: 'Select Reporter',
            items: controller.userNames, 
            selectedValue: controller.selectedReportedBy.value,
            onChanged: (v) => controller.selectedReportedBy.value = v,
          ),
          const SizedBox(height: AppConstants.elementSpacing),
          CustDropdown(
            label: 'Failure Reported To',
            hint: 'Select Receiver',
            items: controller.userNames, 
            selectedValue: controller.selectedReportedTo.value,
            onChanged: (v) => controller.selectedReportedTo.value = v,
          ),
          const SizedBox(height: AppConstants.elementSpacing),
          CustomTextField(
            controller: controller.equipmentNoController,
            label: 'Equipment No',
            hintText: 'Enter Equipment No',
          ),
          const SizedBox(height: AppConstants.elementSpacing),
          CustDateTimePicker(
            label: 'Actual Failure Completed On',
            hint: 'Select Date',
            selectedDateTime: controller.actualCompletedOnDate.value.isEmpty ? null : AppDateUtils.parseDate(controller.actualCompletedOnDate.value),
            pickerType: CustDateTimePickerType.date,
            onDateTimeSelected: (date) {
              if (date != null) {
                controller.actualCompletedOnDate.value = AppDateUtils.formatDate(date);
              }
            },
          ),
          const SizedBox(height: AppConstants.elementSpacing),
          CustDropdown(
            label: 'Person Responsible',
            hint: 'Select Person',
            items: controller.userNames, 
            selectedValue: controller.selectedPersonResponsible.value,
            onChanged: (v) => controller.selectedPersonResponsible.value = v,
          ),
          const SizedBox(height: AppConstants.elementSpacing),
          CustomTextField(
            controller: controller.failureDescriptionController,
            label: 'Failure Description',
            hintText: 'Describe the failure',
            maxLines: 4,
          ),
        ],
      ),
    ));
  }

  Widget _buildTripAffectedStep() {
    return Obx(() => AccordionCard(
      title: "Trip Affected",
      headerTrailing: CustSwitch(
        value: controller.isTripAffectedOn.value,
        onChanged: (bool val) => controller.isTripAffectedOn.value = val,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.isTripAffectedOn.value) ...[
            CustomTextField(
              controller: controller.tripDelayUplineController,
              label: 'Trip Delay Upline *',
              hintText: 'Enter Train Delay In Min',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: AppConstants.elementSpacing),
            CustomTextField(
              controller: controller.tripDelayDownlineController,
              label: 'Trip Delay Downline',
              hintText: 'Enter Trip Delay Downline',
            ),
            const SizedBox(height: AppConstants.elementSpacing),
            CustDropdown(
              label: 'Trip Withdrawal',
              hint: 'Select Trip Withdrawal',
              items: const ['Withdrawal 1', 'Withdrawal 2'],
              selectedValue: controller.tripWithdrawalController.text.isEmpty ? null : controller.tripWithdrawalController.text,
              onChanged: (v) => controller.tripWithdrawalController.text = v ?? '',
            ),
            const SizedBox(height: AppConstants.elementSpacing),
             CustDropdown(
              label: 'Trip Cancel',
              hint: 'Select Trip Cancel',
              items: const ['Cancel 1', 'Cancel 2'],
              selectedValue: controller.tripCancelController.text.isEmpty ? null : controller.tripCancelController.text,
              onChanged: (v) => controller.tripCancelController.text = v ?? '',
            ),
            const SizedBox(height: AppConstants.elementSpacing),
            CustomTextField(
              controller: controller.tripDelayInMinController,
              label: 'Trip Delay in Min',
              hintText: 'Enter Trip Delay in Min',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: AppConstants.elementSpacing),
            CustomTextField(
              controller: controller.tripReplaceTextFieldController,
              label: 'Trip Replace',
              hintText: 'Enter Trip Replace',
            ),
            const SizedBox(height: AppConstants.elementSpacing),

            // Train Replace Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustText(name: 'Train Replace', size: 1.4, fontWeightName: FontWeight.w600),
                CustSwitch(
                  value: controller.isTrainReplaceOn.value,
                  onChanged: (bool val) => controller.isTrainReplaceOn.value = val,
                ),
              ],
            ),
            if (controller.isTrainReplaceOn.value) ...[
              const SizedBox(height: AppConstants.elementSpacing),
              CustomTextField(
                controller: controller.replaceWithController,
                label: 'Replace With',
                hintText: 'Enter Replace With',
              ),
              const SizedBox(height: AppConstants.elementSpacing),
              CustDateTimePicker(
                label: 'Replaced Time',
                hint: 'HH:mm',
                selectedDateTime: controller.replaceTimeDate.value.isEmpty ? null : AppDateUtils.parseTime(controller.replaceTimeDate.value),
                pickerType: CustDateTimePickerType.time,
                onDateTimeSelected: (date) {
                  if (date != null) {
                    controller.replaceTimeDate.value = AppDateUtils.formatTime(date);
                  }
                },
              ),
              const SizedBox(height: AppConstants.elementSpacing),
              CustomTextField(
                controller: controller.trainReplaceController,
                label: 'Train Replace',
                hintText: 'Enter Train Replace',
              ),
            ],
            const SizedBox(height: AppConstants.elementSpacing),

            // Passenger Deboarding Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustText(name: 'Passenger Deboarding', size: 1.4, fontWeightName: FontWeight.w600),
                CustSwitch(
                  value: controller.isPassengerDeboardingOn.value,
                  onChanged: (bool val) => controller.isPassengerDeboardingOn.value = val,
                ),
              ],
            ),
            if (controller.isPassengerDeboardingOn.value) ...[
              const SizedBox(height: AppConstants.elementSpacing),
              CustomTextField(
                controller: controller.passengerDeboardedController,
                label: 'Passenger Deboarded',
                hintText: 'Enter Passenger Deboarded',
              ),
            ],
          ],
        ],
      ),
    ));
  }

  Widget _buildPassengerAffectedStep() {
    return Obx(() => AccordionCard(
      title: "Passenger Affected",
      headerTrailing: CustSwitch(
        value: controller.isPassengerAffectedOn.value,
        onChanged: (bool val) => controller.isPassengerAffectedOn.value = val,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.isPassengerAffectedOn.value) ...[
            CustomTextField(
              controller: controller.passengerAffectedNumbersController,
              label: 'Number of passenger affected numbers',
              hintText: 'Enter numbers',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: AppConstants.elementSpacing),
            CustDateTimePicker(
              label: 'Trapped duration',
              hint: 'Select time',
              selectedDateTime: controller.trappedDuration.value.isEmpty ? null : AppDateUtils.parseTime(controller.trappedDuration.value),
              pickerType: CustDateTimePickerType.time,
              onDateTimeSelected: (date) {
                if (date != null) {
                  controller.trappedDuration.value = AppDateUtils.formatTime(date);
                }
              },
            ),
            const SizedBox(height: AppConstants.elementSpacing),
            CustDateTimePicker(
              label: 'Rescued duration',
              hint: 'Select time',
              selectedDateTime: controller.rescuedDuration.value.isEmpty ? null : AppDateUtils.parseTime(controller.rescuedDuration.value),
              pickerType: CustDateTimePickerType.time,
              onDateTimeSelected: (date) {
                if (date != null) {
                  controller.rescuedDuration.value = AppDateUtils.formatTime(date);
                }
              },
            ),
          ]
        ],
      ),
    ));
  }

  Widget _buildBeforeAttachmentStep() {
    return Obx(() => AccordionCard(
      title: "Before Attachment",
      child: FileUploadSection(
        files: controller.beforeAttachments.toList().cast<File>(),
        onFilesChanged: (files) => controller.beforeAttachments.assignAll(files),
      ),
    ));
  }

  Widget _buildAcknowledgementStep() {
    return Obx(() => AccordionCard(
      title: "Acknowledgement",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: controller.failureRemarkController,
            label: 'failure remark',
            hintText: 'Enter remark',
            maxLines: 4,
          ),
          const SizedBox(height: AppConstants.elementSpacing),
          CustDropdown(
            label: 'Assign Technician',
            hint: 'Select Technician',
            items: controller.userNames,
            selectedValue: controller.selectedTechnician.value,
            onChanged: (v) => controller.selectedTechnician.value = v,
          ),
        ],
      ),
    ));
  }

  Widget _buildAfterAttachmentStep() {
    return Obx(() => AccordionCard(
      title: "After Attachment",
      child: FileUploadSection(
        files: controller.afterAttachments.toList().cast<File>(),
        onFilesChanged: (files) => controller.afterAttachments.assignAll(files),
      ),
    ));
  }
  Widget _buildRCADetailStep() {
    return Obx(() => AccordionCard(
      title: "RCA details",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // RCA Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustText(name: 'RCA Detail', size: 1.4, fontWeightName: FontWeight.w600),
              CustButton(
                name: 'Add RCA',
                onSelected: (_) {
                  controller.clearRcaTempState();
                  controller.isAddingRootCause.value = false;
                  _showRCABottomSheet();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (controller.rcaList.isNotEmpty) ...[
            _buildRcaExpansionList(),
          ],
          
          if (controller.rcaList.isNotEmpty) ...[
            const SizedBox(height: AppConstants.elementSpacing),
            Align(
              alignment: Alignment.centerRight,
              child: CustButton(
                name: 'Add Root Cause',
                onSelected: (_) {
                  controller.clearRcaTempState();
                  controller.isAddingRootCause.value = true;
                  _showRCABottomSheet();
                },
              ),
            ),
            const SizedBox(height: AppConstants.elementSpacing),
            const Divider(),
            const SizedBox(height: AppConstants.elementSpacing),
          ],

          // File Upload Section for RCA
          const CustText(name: 'RCA Attachments', size: 1.4, fontWeightName: FontWeight.w600),
          const SizedBox(height: 8),
          FileUploadSection(
            files: controller.rcaAttachments.toList().cast<File>(),
            onFilesChanged: (files) => controller.rcaAttachments.assignAll(files),
          ),
        ],
      ),
    ));
  }

  Widget _buildRcaExpansionList() {
    // Force Obx to register the dependency on rootCauseList
    // ignore: unused_local_variable
    final dependencyTracker = controller.rootCauseList.length;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.rcaList.length,
      itemBuilder: (context, index) {
        final rca = controller.rcaList[index];
        final rcaIdentifier = "${rca['objectPart']} - ${rca['fault']}";
        final specificRootCauses = controller.rootCauseList.asMap().entries.where((e) => e.value['rcaId'] == rcaIdentifier).toList();
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.12),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(right: 12, top: 4),
                    decoration: BoxDecoration(
                      color: AppColors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: CustText(
                      name: '${index + 1}', 
                      size: 1.1, 
                      fontWeightName: FontWeight.bold,
                      color: AppColors.blue,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.build_circle_outlined, size: 14, color: Colors.grey.shade600),
                                      const SizedBox(width: 4),
                                      const Expanded(child: CustText(name: 'Object Part', size: 0.8, color: Colors.grey)),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  CustText(name: rca['objectPart'] ?? '', size: 1.1, fontWeightName: FontWeight.bold),
                                  if (rca['objectPartDesc']?.isNotEmpty == true)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: CustText(name: rca['objectPartDesc']!, size: 0.9, color: Colors.grey.shade700),
                                    ),
                                ],
                              )
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.error_outline, size: 14, color: Colors.red.shade400),
                                      const SizedBox(width: 4),
                                      const Expanded(child: CustText(name: 'Fault', size: 0.8, color: Colors.grey)),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  CustText(name: rca['fault'] ?? '', size: 1.1, fontWeightName: FontWeight.bold),
                                  if (rca['faultDesc']?.isNotEmpty == true)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: CustText(name: rca['faultDesc']!, size: 0.9, color: Colors.grey.shade700),
                                    ),
                                ],
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                          onPressed: () => _editRca(index),
                          tooltip: 'Edit RCA',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                          onPressed: () => controller.removeRca(index),
                          tooltip: 'Delete RCA',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50.withOpacity(0.3),
                    border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1.5)),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: specificRootCauses.isEmpty 
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, color: Colors.grey.shade500, size: 18),
                          const SizedBox(width: 8),
                          CustText(name: 'No root causes added yet', size: 1.0, color: Colors.grey.shade600),
                        ]
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.account_tree_outlined, size: 16, color: Colors.grey.shade700),
                              const SizedBox(width: 8),
                              const CustText(name: 'Root Causes', size: 1.1, fontWeightName: FontWeight.w600),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...specificRootCauses.asMap().entries.map((entry) {
                            final localIndex = entry.key;
                            final globalIndex = entry.value.key;
                            final rc = entry.value.value;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10.0),
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.04),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    margin: const EdgeInsets.only(right: 12, top: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade100.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: CustText(
                                      name: '${localIndex + 1}', 
                                      size: 0.9, 
                                      fontWeightName: FontWeight.bold,
                                      color: Colors.amber.shade900,
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const CustText(name: 'Root Cause', size: 0.8, color: Colors.grey),
                                              const SizedBox(height: 2),
                                              CustText(name: rc['rootCause'] ?? '', size: 1.0, fontWeightName: FontWeight.w600),
                                              if (rc['rootCauseText']?.isNotEmpty == true)
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2.0),
                                                  child: CustText(name: rc['rootCauseText']!, size: 0.9, color: Colors.grey.shade700),
                                                ),
                                            ],
                                          )
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const CustText(name: 'Action Taken', size: 0.8, color: Colors.grey),
                                              const SizedBox(height: 2),
                                              CustText(name: rc['actionTaken'] ?? '', size: 1.0, fontWeightName: FontWeight.w600),
                                              if (rc['actionTakenText']?.isNotEmpty == true)
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2.0),
                                                  child: CustText(name: rc['actionTakenText']!, size: 0.9, color: Colors.grey.shade700),
                                                ),
                                            ],
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 18),
                                        onPressed: () => _editRootCause(globalIndex),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        tooltip: 'Edit Root Cause',
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                                        onPressed: () => controller.rootCauseList.removeAt(globalIndex),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        tooltip: 'Delete Root Cause',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _editRca(int index) {
    final rca = controller.rcaList[index];
    controller.clearRcaTempState();
    controller.isAddingRootCause.value = false;
    controller.selectedRcaObjectPart.value = rca['objectPart'];
    controller.rcaObjectPartDescController.text = rca['objectPartDesc'] ?? '';
    controller.selectedRcaFault.value = rca['fault'];
    controller.rcaFaultDescController.text = rca['faultDesc'] ?? '';
    controller.editingRcaIndex = index;
    _showRCABottomSheet();
  }

  void _editRootCause(int index) {
    final rc = controller.rootCauseList[index];
    controller.clearRcaTempState();
    controller.isAddingRootCause.value = true;
    controller.selectedLinkedRca.value = rc['rcaId'];
    controller.selectedRcaRootCause.value = rc['rootCause'];
    controller.rcaRootCauseTextController.text = rc['rootCauseText'] ?? '';
    controller.selectedRcaActionTaken.value = rc['actionTaken'];
    controller.rcaActionTakenTextController.text = rc['actionTakenText'] ?? '';
    controller.editingRootCauseIndex = index;
    _showRCABottomSheet();
  }

  void _showRCABottomSheet() {
    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      Obx(() => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(Get.context!).size.height * 0.9,
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustText(
                    name: controller.isAddingRootCause.value 
                      ? (controller.editingRootCauseIndex != null ? 'Edit Root Cause' : 'Add Root Cause')
                      : (controller.editingRcaIndex != null ? 'Edit RCA Detail' : 'Add RCA Detail'), 
                    size: 1.8, 
                    fontWeightName: FontWeight.bold
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),
              
              if (!controller.isAddingRootCause.value) ...[
                // RCA FORM (Object/Fault)
                CustDropdown(
                  label: 'Object part',
                  hint: 'Select Part',
                  items: controller.objectPartDescriptions,
                  selectedValue: controller.selectedRcaObjectPart.value,
                  onChanged: (v) => controller.selectedRcaObjectPart.value = v,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Object part description', 
                  controller: controller.rcaObjectPartDescController
                ),
                const SizedBox(height: 12),
                CustDropdown(
                  label: 'Fault',
                  hint: 'Select Fault',
                  items: controller.faultDescriptions,
                  selectedValue: controller.selectedRcaFault.value,
                  onChanged: (v) => controller.selectedRcaFault.value = v,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'fault description', 
                  controller: controller.rcaFaultDescController
                ),
                const SizedBox(height: 24),
                CustButton(
                  name: controller.editingRcaIndex != null ? 'Update RCA' : 'Save RCA',
                  onSelected: (_) {
                    controller.saveRca();
                    Get.back();
                  },
                ),
                const SizedBox(height: 20),
              ] else ...[
                // ROOT CAUSE FORM
                CustDropdown(
                  label: 'Select RCA',
                  hint: 'Link to RCA',
                  items: controller.rcaList.map((e) => "${e['objectPart']} - ${e['fault']}").toList(),
                  selectedValue: controller.selectedLinkedRca.value,
                  onChanged: (v) => controller.selectedLinkedRca.value = v,
                ),
                const SizedBox(height: 12),
                CustDropdown(
                  label: 'root cause',
                  hint: 'Select Root Cause',
                  items: controller.rootCauseDescriptions,
                  selectedValue: controller.selectedRcaRootCause.value,
                  onChanged: (v) => controller.selectedRcaRootCause.value = v,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'root cause text', 
                  controller: controller.rcaRootCauseTextController, 
                  maxLength: 100,
                ),
                const SizedBox(height: 12),
                CustDropdown(
                  label: 'action taken',
                  hint: 'Select Action',
                  items: controller.actionTakenNames,
                  selectedValue: controller.selectedRcaActionTaken.value,
                  onChanged: (v) => controller.selectedRcaActionTaken.value = v,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Action taken text', 
                  controller: controller.rcaActionTakenTextController,
                  maxLength: 100,
                ),
                const SizedBox(height: 24),
                CustButton(
                  name: controller.editingRootCauseIndex != null ? 'Update Root Cause' : 'Save Root Cause',
                  onSelected: (_) {
                    controller.saveRootCause();
                    Get.back();
                  },
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      )),
    );
  }

  // _buildRcaDetailsTable is replaced by _buildRcaTable and _buildRootCauseTable

  Widget _buildPTWRequestStep() {
    return Obx(() => AccordionCard(
      title: "PTW Request",
      headerTrailing: CustSwitch(
        value: controller.isPtwRequestOn.value,
        onChanged: (bool val) => controller.isPtwRequestOn.value = val,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.isPtwRequestOn.value) ...[
            CustomTextField(
              controller: controller.ptwNumberController,
              label: 'PTW NUmber',
              hintText: 'Enter PTW Number',
            ),
          ]
        ],
      ),
    ));
  }

  Widget _buildMaterialFailureTypeStep() {
    return Obx(() => AccordionCard(
      title: "Material Failure Type",
      headerTrailing: CustSwitch(
        value: controller.isMaterialFailureTypeOn.value,
        onChanged: (bool val) => controller.isMaterialFailureTypeOn.value = val,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.isMaterialFailureTypeOn.value) ...[
            CustDropdown(
              label: 'Material Failure Type',
              hint: 'Select Failure Type',
              items: controller.materialFailureTypes,
              selectedValue: controller.selectedMaterialFailureType.value,
              onChanged: (v) => controller.selectedMaterialFailureType.value = v,
            ),
            if (controller.selectedMaterialFailureType.value == 'Hardware') ...[
              const SizedBox(height: AppConstants.elementSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustText(name: 'Spare Parts', size: 1.4, fontWeightName: FontWeight.w600),
                  CustButton(
                    name: 'Add Spare Parts',
                    onSelected: (_) {
                      controller.clearSparePartTempState();
                      _showSparePartsBottomSheet();
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.elementSpacing),
              if (controller.sparePartsList.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.sparePartsList.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = controller.sparePartsList[index];
                    return ListTile(
                      title: CustText(name: item['materialCode'] ?? '', size: 1.2, fontWeightName: FontWeight.w600),
                      subtitle: CustText(name: 'Store: ${item['storeLocation']} | Req: ${item['requiredQty']} | Bal: ${item['balanceQty']}', size: 1.0),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              controller.clearSparePartTempState();
                              controller.editingSparePartIndex = index;
                              controller.selectedSpareMaterialCode.value = item['materialCode'];
                              controller.selectedSpareStoreLocation.value = item['storeLocation'];
                              controller.spareRequiredQtyController.text = item['requiredQty'] ?? '';
                              controller.spareBalanceQtyController.text = item['balanceQty'] ?? '';
                              _showSparePartsBottomSheet();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => controller.removeSparePart(index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ]
        ],
      ),
    ));
  }

  void _showSparePartsBottomSheet() {
    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      Obx(() => Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustText(
                    name: controller.editingSparePartIndex != null ? 'Edit Spare Part' : 'Add Spare Part', 
                    size: 1.8, 
                    fontWeightName: FontWeight.bold
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),
              CustDropdown(
                label: 'material code and description',
                hint: 'Select Material',
                items: controller.materialNames,
                selectedValue: controller.selectedSpareMaterialCode.value,
                onChanged: (v) => controller.selectedSpareMaterialCode.value = v,
              ),
              const SizedBox(height: 12),
              CustDropdown(
                label: 'store location',
                hint: 'Select Location',
                items: controller.storeLocationNames,
                selectedValue: controller.selectedSpareStoreLocation.value,
                onChanged: (v) => controller.selectedSpareStoreLocation.value = v,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'required quantity',
                controller: controller.spareRequiredQtyController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'balance quantity',
                controller: controller.spareBalanceQtyController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 24),
              CustButton(
                name: controller.editingSparePartIndex != null ? 'Update' : 'Add',
                onSelected: (_) {
                  controller.saveSparePart();
                  Get.back();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      )),
    );
  }
  Widget _buildMaterialDismantleStep() {
    return Obx(() => AccordionCard(
      title: "Material dismantle",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustText(name: 'Material dismantle', size: 1.4, fontWeightName: FontWeight.w600),
              CustButton(
                name: 'Add',
                onSelected: (_) => _showAddMaterialDismantlePopup(),
              ),
            ],
          ),
          if (controller.materialDismantleList.isNotEmpty) ...[
            const SizedBox(height: AppConstants.elementSpacing),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.materialDismantleList.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = controller.materialDismantleList[index];
                return ListTile(
                  title: CustText(name: item['material'] ?? '', size: 1.2, fontWeightName: FontWeight.w600),
                  subtitle: CustText(name: 'Old S/N: ${item['oldSN']} | New S/N: ${item['newSN']}', size: 1.0),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => controller.materialDismantleList.removeAt(index),
                  ),
                );
              },
            ),
          ]
        ],
      ),
    ));
  }

  void _showAddMaterialDismantlePopup() {
    String? material;
    final oldSN = TextEditingController();
    final newSN = TextEditingController();
    DateTime? oldDate;
    DateTime? newDate;

    CustomFormDialog.show(
      title: 'Add Material Dismantle',
      saveButtonText: 'Save',
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => CustDropdown(
                label: 'Material code and description',
                hint: 'Select Material',
                items: controller.addedSparePartMaterialCodes.isNotEmpty 
                    ? controller.addedSparePartMaterialCodes 
                    : const [],
                selectedValue: material,
                onChanged: (v) => setState(() => material = v),
              )),
              const SizedBox(height: 12),
          CustomTextField(
            label: 'old serial num', 
            controller: oldSN, 
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'new serial num', 
            controller: newSN, 
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 12),
          CustDateTimePicker(
            label: 'old serial number dismantle date',
            hint: 'Select Date',
            selectedDateTime: oldDate,
            onDateTimeSelected: (d) => setState(() => oldDate = d),
          ),
          const SizedBox(height: 12),
          CustDateTimePicker(
            label: 'new serial number dismantle date',
            hint: 'Select Date',
            selectedDateTime: newDate,
            onDateTimeSelected: (d) => setState(() => newDate = d),
          ),
        ],
      );
      }),
      onSave: () {
        controller.materialDismantleList.add({
          'material': material ?? '',
          'oldSN': oldSN.text,
          'newSN': newSN.text,
          'oldDate': oldDate != null ? AppDateUtils.formatDate(oldDate!) : '',
          'newDate': newDate != null ? AppDateUtils.formatDate(newDate!) : '',
        });
        Get.back();
      },
    );
  }

  Widget _buildJoinInspectionStep() {
    return Obx(() => AccordionCard(
      title: "Join inspection",
      headerTrailing: CustSwitch(
        value: controller.isJoinInspectionOn.value,
        onChanged: (bool val) => controller.isJoinInspectionOn.value = val,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.isJoinInspectionOn.value) ...[
            CustDropdown(
              label: 'department',
              hint: 'Select Department',
              items: controller.departments.map((e) => e.name).toList(),
              selectedValue: controller.selectedJoinDepartment.value,
              onChanged: (v) => controller.selectedJoinDepartment.value = v,
            ),
            const SizedBox(height: AppConstants.elementSpacing),
            CustDropdown(
              label: 'Assign to',
              hint: 'Select Assignee',
              items: controller.userNames,
              selectedValue: controller.selectedJoinAssignTo.value,
              onChanged: (v) => controller.selectedJoinAssignTo.value = v,
            ),
            const SizedBox(height: AppConstants.elementSpacing),
            CustomTextField(
              controller: controller.joinInspectionRemarkController,
              label: 'join inspection remark',
              hintText: 'Enter remark',
              maxLines: 4,
            ),
          ]
        ],
      ),
    ));
  }

  Widget _buildActivityStep() {
    return Obx(() => AccordionCard(
      title: "Activity",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: controller.rectificationDetailController,
            label: 'failure Rectification detail',
            hintText: 'Enter details',
            maxLines: 4,
          ),
          const SizedBox(height: AppConstants.elementSpacing),
          CustDropdown(
            label: 'user status',
            hint: 'Select Status',
            items: const ['Under Observation', 'In Progress', 'Closed', 'Escalated'],
            selectedValue: controller.selectedUserStatus.value,
            onChanged: (v) => controller.selectedUserStatus.value = v,
          ),
          const SizedBox(height: AppConstants.elementSpacing),
          CustDateTimePicker(
            label: 'Failure Attended',
            hint: 'Select Date/Time',
            selectedDateTime: controller.failureAttendedDate.value.isEmpty ? null : AppDateUtils.parseDate(controller.failureAttendedDate.value),
            onDateTimeSelected: (date) {
              if (date != null) {
                controller.failureAttendedDate.value = AppDateUtils.formatDate(date);
              }
            },
          ),
          const SizedBox(height: AppConstants.elementSpacing),
          CustDateTimePicker(
            label: 'ACtual failure Rectified',
            hint: 'Select Date/Time',
            selectedDateTime: controller.actualFailureRectifiedDate.value.isEmpty ? null : AppDateUtils.parseDate(controller.actualFailureRectifiedDate.value),
            onDateTimeSelected: (date) {
              if (date != null) {
                controller.actualFailureRectifiedDate.value = AppDateUtils.formatDate(date);
              }
            },
          ),
        ],
      ),
    ));
  }
}
