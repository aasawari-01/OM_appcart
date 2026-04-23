import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:om_appcart/constants/colors.dart';
import '../../../view/widgets/cust_loader.dart';
import '../../../view/widgets/cust_text.dart';
import '../../../view/widgets/custom_app_bar.dart';
import '../../../view/widgets/cust_button.dart';
import '../../../view/widgets/custom_snackbar.dart';

import '../controller/finalize_match_controller.dart';

class FinalizeFoundLostItemsScreen extends GetView<FinalizeMatchController> {
  const FinalizeFoundLostItemsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered
    if (!Get.isRegistered<FinalizeMatchController>()) {
      Get.put(FinalizeMatchController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Finalize Found Lost Items',
        showDrawer: false,
        isForm: false,
        onLeadingPressed: () => Get.back(),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustText(
                    name: 'Found Items',
                    size: 1.4,
                    color: AppColors.black,
                    fontWeightName: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),
                  const CustText(
                    name: 'Select the found item(s) to finalize',
                    size: 1.2,
                    color: AppColors.textColor4,
                  ),
                  const SizedBox(height: 20),
                  Obx(() => Column(
                    children: List.generate(controller.matchData.length, (index) => Column(
                      children: [
                        _buildSelectableCard(index),
                        const SizedBox(height: 16),
                      ],
                    )),
                  )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() => controller.isLoading.value 
              ? const CustLoader()
              : CustButton(
                name: 'Submit',
                onSelected: (val) => controller.submitFinalize(),
                size: double.infinity,
                color1: AppColors.blue,
                borderRadius: 4,
                sHeight: 45,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableCard(int index) {
    final match = controller.matchData[index];
    final foundItem = match['found_item'] ?? {};
    final breakdown = match['breakdown'] ?? {};
    final double score = (match['score'] ?? 0.0).toDouble();
    
    final isSelected = controller.selectedIndices.contains(index);
    
    return GestureDetector(
      onTap: () => controller.toggleSelection(index),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.blue : const Color(0xFFE0E0E0),
            width: isSelected ? 1.5 : 0.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.blue.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustText(
                        name: foundItem['docNumber'] ?? 'N/A',
                        size: 1.3,
                        color: AppColors.black,
                        fontWeightName: FontWeight.bold,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: CustText(
                          name: '${score.toStringAsFixed(2)}%',
                          size: 1.0,
                          color: const Color(0xFF4CAF50),
                          fontWeightName: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFF1F5F9), thickness: 1),
                  const SizedBox(height: 16),
                  _buildRowInfo('Category', foundItem['category'] ?? 'N/A'),
                  const SizedBox(height: 8),
                  _buildRowInfo('Station', foundItem['stations']?['name'] ?? 'N/A'),
                  const SizedBox(height: 8),
                  _buildRowInfo('Found Place', foundItem['articleFoundPlace'] ?? 'N/A'),
                  const SizedBox(height: 16),
                  const CustText(
                    name: 'Breakdown',
                    size: 1.1,
                    color: AppColors.textColor4,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildBreakdownItem('Category ${breakdown['category'] ?? 0}%'),
                      _buildBreakdownItem('Color ${breakdown['color'] ?? 0}%'),
                      _buildBreakdownItem('Station ${breakdown['station'] ?? 0}%'),
                      _buildBreakdownItem('Date ${breakdown['date'] ?? 0}%'),
                      _buildBreakdownItem('Place ${breakdown['place'] ?? 0}%'),
                      _buildBreakdownItem('Description ${breakdown['description'] ?? 0}%'),
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.check_circle, color: AppColors.blue, size: 24),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowInfo(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustText(name: label, size: 1.1, color: AppColors.textColor4),
        CustText(name: value, size: 1.2, color: AppColors.black, fontWeightName: FontWeight.w500),
      ],
    );
  }

  Widget _buildBreakdownItem(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: CustText(
        name: text,
        size: 1.0,
        color: AppColors.black,
        fontWeightName: FontWeight.w500,
      ),
    );
  }
}
