import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:om_appcart/feature/failure/controller/station_controller.dart';
import 'package:om_appcart/view/widgets/accordion_card.dart';
import 'package:om_appcart/view/widgets/cust_date_time_picker.dart';
import 'package:om_appcart/view/widgets/cust_dropdown.dart';
import 'package:om_appcart/view/widgets/cust_textfield.dart';
import '../../controller/lost_and_found_form_controller.dart';

class LFRegistrationStep extends StatelessWidget {
  final LostAndFoundFormController controller;

  const LFRegistrationStep({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.step1FormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: AccordionCard(
          title: 'Basic Details',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => CustDropdown(
                label: 'Register As',
                hint: 'Select Register As',
                items: controller.registerAsOptions,
                selectedValue: controller.registerAs.value,
                validator: (value) => value == null || value.isEmpty ? 'Please Select Register As' : null,
                onChanged: (value) => controller.registerAs.value = value,
              )),
              const SizedBox(height: 16),
              Obx(() {
                final stationController = Get.find<StationController>();
                return CustDropdown(
                  label: 'Station',
                  hint: 'Enter Station',
                  items: stationController.stationNames,
                  selectedValue: controller.selectedStation.value,
                  validator: (value) => value == null || value.isEmpty ? 'Please Select Station' : null,
                  onChanged: (value) => controller.selectedStation.value = value,
                );
              }),
              const SizedBox(height: 16),
              Obx(() => CustDateTimePicker(
                label: 'Date',
                hint: 'Select Date',
                pickerType: CustDateTimePickerType.date,
                selectedDateTime: controller.selectedDate.value,
                validator: (value) => controller.selectedDate.value == null ? 'Please Select Date' : null,
                onDateTimeSelected: (date) => controller.selectedDate.value = date,
              )),
              const SizedBox(height: 16),
              Obx(() {
                bool isFound = controller.registerAs.value == 'Found';
                return Column(
                  children: [
                    if (!isFound) ...[
                      CustomTextField(
                        label: 'Passenger Name',
                        controller: controller.passengerNameController,
                        hintText: 'Enter Passenger Name',
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Contact No',
                        controller: controller.contactNoController,
                        hintText: 'Enter Contact No',
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Article Lost',
                        controller: controller.articleLostController,
                        hintText: 'Enter Article Lost',
                        textCapitalization: TextCapitalization.words,
                        validator: (value) => (value == null || value.isEmpty) ? 'Please Enter Article Lost' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Place of Article Lost',
                        controller: controller.articleLostPlaceController,
                        hintText: 'Enter Place of Article Lost',
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Permanent Address',
                        controller: controller.addressController,
                        hintText: 'Enter Permanent Address',
                        textCapitalization: TextCapitalization.words,
                        maxLines: 3,
                      ),
                    ] else ...[
                      CustomTextField(
                        label: 'Article Found',
                        controller: controller.articleFoundController,
                        hintText: 'Enter Article Found',
                        textCapitalization: TextCapitalization.words,
                        validator: (value) => (value == null || value.isEmpty) ? 'Please Enter Article Found' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Place of Article Found',
                        controller: controller.articleFoundPlaceController,
                        hintText: 'Enter Place of Article Found',
                        textCapitalization: TextCapitalization.words,
                      ),
                    ],
                  ],
                );
              }),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Internal Notes',
                controller: controller.internalNotesController,
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
}
