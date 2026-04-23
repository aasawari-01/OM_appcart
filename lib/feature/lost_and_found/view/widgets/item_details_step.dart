import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:om_appcart/view/widgets/accordion_card.dart';
import 'package:om_appcart/view/widgets/cust_dropdown.dart';
import 'package:om_appcart/view/widgets/cust_textfield.dart';
import '../../controller/lost_and_found_form_controller.dart';

class LFItemDetailsStep extends StatelessWidget {
  final LostAndFoundFormController controller;

  const LFItemDetailsStep({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.step2FormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: AccordionCard(
          title: 'Item Details',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => CustDropdown(
                label: 'Color',
                hint: 'Select Color',
                items: controller.basicColorList,
                selectedValue: controller.selectedColor.value,
                validator: (value) => value == null || value.isEmpty ? 'Please Select Color' : null,
                onChanged: (val) => controller.selectedColor.value = val,
              )),
              const SizedBox(height: 16),
              Obx(() => CustDropdown(
                label: 'Category',
                hint: 'Select Category',
                items: controller.categoryList,
                selectedValue: controller.selectedCategory.value,
                validator: (value) => value == null || value.isEmpty ? 'Please Select Category' : null,
                onChanged: (val) => controller.selectedCategory.value = val,
              )),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Quantity in No',
                controller: controller.quantityController,
                hintText: 'Enter Quantity in No',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Please Enter Quantity in No';
                  final qty = int.tryParse(value.trim());
                  if (qty == null || qty <= 0) return 'Invalid Quantity';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Estimated Value',
                controller: controller.estimateValueController,
                hintText: 'Enter Estimated Value',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Description',
                controller: controller.descriptionController,
                hintText: 'Enter Description',
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
