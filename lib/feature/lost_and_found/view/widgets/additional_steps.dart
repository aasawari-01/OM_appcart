import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/lost_found_table_record.dart';
import 'package:om_appcart/view/widgets/accordion_card.dart';
import 'package:om_appcart/view/widgets/cust_dropdown.dart';
import 'package:om_appcart/view/widgets/cust_textfield.dart';
import 'package:om_appcart/view/widgets/file_upload_section.dart';
import 'package:om_appcart/view/widgets/cust_date_time_picker.dart';
import '../../controller/lost_and_found_form_controller.dart';

class LFFoundAttachmentsStep extends StatelessWidget {
  final LostAndFoundFormController controller;

  const LFFoundAttachmentsStep({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: AccordionCard(
        title: 'Attachments',
        child: Obx(() {
          final files = controller.attachedFiles.toList();

          return FileUploadSection(
            files: files,
            onFilesChanged: (files) =>
                controller.attachedFiles.assignAll(files.cast<File>()),
          );
        }),
      ),
    );
  }
}

class LFVerificationStep extends StatelessWidget {
  final LostAndFoundFormController controller;

  const LFVerificationStep({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: AccordionCard(
        title: 'Verification Details',
        child: Column(
          children: [
            Obx(() => CustDropdown(
              label: 'Verified Color',
              hint: 'Select Verified Color',
              items: controller.basicColorList,
              selectedValue: controller.verifiedColor.value,
              onChanged: (val) => controller.verifiedColor.value = val,
            )),
            const SizedBox(height: 16),
            Obx(() => CustDropdown(
              label: 'ID Proof',
              hint: 'Select ID Proof',
              items: controller.idProofList,
              selectedValue: controller.verifiedIdProof.value,
              onChanged: (val) => controller.verifiedIdProof.value = val,
            )),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Unique ID',
              controller: controller.verifiedUniqueIdController,
              hintText: 'Enter Unique ID',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Verification Description',
              controller: controller.verifiedDescriptionController,
              hintText: 'Enter Description',
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}

class LFHandoverStep extends StatelessWidget {
  final LostAndFoundFormController controller;

  const LFHandoverStep({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: AccordionCard(
        title: 'Handover Details',
        child: Column(
          children: [
            Obx(() => CustDateTimePicker(
              label: 'Handover Date',
              hint: 'Select Date',
              pickerType: CustDateTimePickerType.date,
              selectedDateTime: controller.handoverDate.value,
              onDateTimeSelected: (date) => controller.handoverDate.value = date,
            )),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Handover To',
              controller: controller.handoverToNameController,
              hintText: 'Enter Handover To Name',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Remarks',
              controller: controller.remarksController,
              hintText: 'Enter Remarks',
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
