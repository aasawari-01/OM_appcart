
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:om_appcart/constants/app_data.dart';
import 'package:om_appcart/constants/colors.dart';

import '../widgets/accordion_card.dart';
import '../widgets/cust_button.dart';
import '../widgets/cust_date_time_picker.dart';
import '../widgets/cust_dropdown.dart';
import '../widgets/cust_text.dart';
import '../widgets/cust_textfield.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/skeleton_loader.dart';


class AssetRegisterForm extends StatefulWidget {
  const AssetRegisterForm({Key? key}) : super(key: key);

  @override
  State<AssetRegisterForm> createState() => _AssetRegisterFormState();
}

class _AssetRegisterFormState extends State<AssetRegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _selectedStation;
  DateTime? _deliveryDate;
  final TextEditingController _assetDescriptionController = TextEditingController();
  final TextEditingController _nameOfAssetController = TextEditingController();
  final TextEditingController _financeAssetCodeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _modelNumberController = TextEditingController();

  @override
  void dispose() {
    _assetDescriptionController.dispose();
    _nameOfAssetController.dispose();
    _financeAssetCodeController.dispose();
    _quantityController.dispose();
    _modelNumberController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "Asset Register Form"),
      backgroundColor: AppColors.bgColor,
      body: _isLoading
          ? _buildSkeletonLoader()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: _buildAssetsDetailsStep(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustButton(
                        name: 'Submit',
                        onSelected: (_) {
                          if (_formKey.currentState?.validate() ?? false) {
                            Get.dialog(CustomDialog("Saved Successfully."));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
  Widget _buildAssetsDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: AccordionCard(
        expanded: true,
        onTap: () {},
        isExpanded: false,
        title: "Asset Details",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustDropdown(
              label: 'Station',
              hint: 'Select Station',
              items: stationListValue,
              selectedValue: _selectedStation,
              validator: (value) => value == null || value.isEmpty ? 'Please Select Station' : null,
              onChanged: (value) {
                setState(() {
                  _selectedStation = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustDateTimePicker(
              label: 'Date & Time *',
              hint: 'Select Date & Time',
              selectedDateTime: _deliveryDate,
              validator: (value) => _deliveryDate == null ? 'Please Select Date & Time' : null,
              onDateTimeSelected: (dateTime) {
                setState(() {
                  _deliveryDate = dateTime;
                });
              },
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Name of Asset*',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _nameOfAssetController,
              hintText: 'Enter Name of Asset',
              validator: (value) => value == null || value.trim().isEmpty ? 'Please Enter Name of Asset' : null,
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Finance Asset Code',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _financeAssetCodeController,
              hintText: 'Enter Finance Asset Code',
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Quantity',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _quantityController,
              hintText: 'Enter Quantity',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Model Number',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _modelNumberController,
              hintText: 'Enter Model Number',
            ),
            const SizedBox(height: 16),
            CustText(
              name: 'Asset Description',
              size: 1.8,
              fontWeightName: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _assetDescriptionController,
              hintText: 'Enter Asset Description',
              maxLines: 3,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLoader.title(height: 24),
          const SizedBox(height: 24),
          SkeletonLoader.formField(height: 48),
          const SizedBox(height: 16),
          SkeletonLoader.formField(height: 48),
          const SizedBox(height: 16),
          SkeletonLoader.title(height: 20),
          const SizedBox(height: 8),
          SkeletonLoader.formField(height: 48),
          const SizedBox(height: 16),
          SkeletonLoader.title(height: 20),
          const SizedBox(height: 8),
          SkeletonLoader.formField(height: 48),
          const SizedBox(height: 16),
          SkeletonLoader.title(height: 20),
          const SizedBox(height: 8),
          SkeletonLoader.formField(height: 48),
          const SizedBox(height: 16),
          SkeletonLoader.title(height: 20),
          const SizedBox(height: 8),
          SkeletonLoader.formField(height: 120),
          const SizedBox(height: 24),
          SkeletonLoader.button(width: 120),
        ],
      ),
    );
  }

} 