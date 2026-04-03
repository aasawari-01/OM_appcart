import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:om_appcart/constants/colors.dart';
import '../../../view/widgets/cust_loader.dart';
import '../../../view/widgets/cust_text.dart';
import '../../../view/widgets/custom_app_bar.dart';
import '../../../view/widgets/cust_button.dart';
import '../../../view/widgets/custom_snackbar.dart';

import '../service/lost_found_service.dart';
import '../model/lost_found_table_record.dart';

class FinalizeFoundLostItemsScreen extends StatefulWidget {
  final int lostID;
  final List<dynamic> matchData;

  const FinalizeFoundLostItemsScreen({
    Key? key, 
    required this.lostID,
    required this.matchData,
  }) : super(key: key);

  @override
  State<FinalizeFoundLostItemsScreen> createState() => _FinalizeFoundLostItemsScreenState();
}

class _FinalizeFoundLostItemsScreenState extends State<FinalizeFoundLostItemsScreen> {
  final Set<int> _selectedIndices = {};
  final LostFoundService _service = LostFoundService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Finalize Found Lost Items',
        showDrawer: false,
        isForm: false,
        onLeadingPressed: () => Navigator.pop(context),
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
                  ...List.generate(widget.matchData.length, (index) => Column(
                    children: [
                      _buildSelectableCard(index),
                      const SizedBox(height: 16),
                    ],
                  )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _isLoading 
          ? const CustLoader()
              : CustButton(
                name: 'Submit',
                onSelected: (val) async {
                  if (_selectedIndices.isEmpty) {
                    CustomSnackBar.show(title: 'Selection Required', message: 'Please select a found item.');
                    return;
                  }
                  
                  // Only allow one for now as per API spec
                  final int selectedIndex = _selectedIndices.first;
                  final match = widget.matchData[selectedIndex];
                  final int foundID = match['found_id'];

                  setState(() => _isLoading = true);

                  try {
                    final response = await _service.finalizeMatch(widget.lostID, foundID);
                    if (response['status'] == true) {
                      CustomSnackBar.show(title: 'Success', message: 'Match finalized successfully.', isError: false);
                      // Return selected item to refresh parent
                      Navigator.pop(context, match);
                    }
                  } catch (e) {
                    String msg = e.toString();
                    if (msg.contains('TimeoutException')) {
                      msg = 'Time out error';
                    }
                    CustomSnackBar.show(title: 'Error', message: msg);
                  } finally {
                    if (mounted) setState(() => _isLoading = false);
                  }
                },
                size: double.infinity,
                color1: AppColors.blue,
                borderRadius: 4,
                sHeight: 45,
                fontSize: 16,
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableCard(int index) {
    final match = widget.matchData[index];
    final foundItem = match['found_item'] ?? {};
    final breakdown = match['breakdown'] ?? {};
    final double score = (match['score'] ?? 0.0).toDouble();
    
    bool isSelected = _selectedIndices.contains(index);
    return GestureDetector(
      onTap: () {
        setState(() {
          // Single selection logic for finalize API
          _selectedIndices.clear();
          _selectedIndices.add(index);
        });
      },
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustText(name: 'Category', size: 1.1, color: AppColors.textColor4),
                      CustText(name: foundItem['category'] ?? 'N/A', size: 1.2, color: AppColors.black, fontWeightName: FontWeight.w500),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustText(name: 'Station', size: 1.1, color: AppColors.textColor4),
                      CustText(name: foundItem['stations']?['name'] ?? 'N/A', size: 1.2, color: AppColors.black, fontWeightName: FontWeight.w500),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustText(name: 'Found Place', size: 1.1, color: AppColors.textColor4),
                      CustText(name: foundItem['articleFoundPlace'] ?? 'N/A', size: 1.2, color: AppColors.black, fontWeightName: FontWeight.w500),
                    ],
                  ),
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

  Widget _buildSmallTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: CustText(
        name: text,
        size: 1.0,
        color: textColor,
        fontWeightName: FontWeight.w500,
      ),
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
