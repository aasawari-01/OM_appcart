import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/utils/string_utils.dart';
import 'package:om_appcart/view/widgets/cust_text.dart';
import 'package:path/path.dart';
import '../../../../constants/app_constants.dart';
import '../../../../utils/responsive_helper.dart';
import '../../model/lost_found_table_record.dart';

class MatchedItemCard extends StatelessWidget {
  final dynamic item;
  final bool showIcons;

  const MatchedItemCard({
    Key? key,
    required this.item,
    this.showIcons = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isModel = item is LostFoundTableRecord;
    
    // Extract display values carefully
    final Map<String, dynamic>? foundItemData = isModel
        ? null
        : (item['found_item'] as Map<String, dynamic>? ?? item as Map<String, dynamic>);

    final String docNo = isModel 
        ? (item.docNumber.isNotEmpty ? item.docNumber : 'ID: ${item.id}')
        : (foundItemData!['docNumber'] ?? foundItemData['ticketId'] ?? 'ID: ${foundItemData['id'] ?? foundItemData['found_id'] ?? 'N/A'}');
    
    final String articleTitle = isModel
        ? (item.articleFound ?? item.articleLost ?? 'N/A')
        : (foundItemData!['articleFound'] ?? foundItemData['articleLost'] ?? foundItemData['docNumber'] ?? 'N/A');

    final score = isModel ? (item.matchPercentage ?? 0.0) : (item['score'] ?? item['matchPercentage'] ?? 0.0);
    final String percentageStr = '${((score as num)).toStringAsFixed(1)}%';
    
    final String category = isModel ? (item.category ?? 'N/A') : (foundItemData!['category'] ?? 'N/A');
    final String place = isModel
        ? (item.articleFoundPlace ?? item.articleLostPlace ?? 'N/A') 
        : (foundItemData!['articleFoundPlace'] ?? foundItemData['articleLostPlace'] ?? 'N/A');
    
    final String color = isModel ? (item.color ?? 'N/A') : (foundItemData!['color'] ?? 'N/A');
    final String  quantity = isModel ? (item.quantity?.toString() ?? '1') : (foundItemData!['quantity']?.toString() ?? '1');
    final String description = isModel ? (item.description ?? 'No description') : (foundItemData!['description'] ?? 'No description');
    final String registerAs = isModel ? (item.registerAs ?? 'N/A') : (foundItemData!['registerAs'] ?? 'N/A');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (showIcons) const Icon(TablerIcons.barcode, size: 18, color: AppColors.blue),
                      if (showIcons) const SizedBox(width: 8),
                      Flexible(
                        child: CustText(
                          name: docNo,
                          size: 1.1,
                          color: AppColors.black,
                          fontWeightName: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildSmallTag(percentageStr, const Color(0xFFE8F5E9), const Color(0xFF4CAF50)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildInfoRow(TablerIcons.clipboard_list, 'Register As', registerAs.toTitle(),context)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildInfoRow(TablerIcons.package, 'Article', articleTitle.toTitle(),context)),
                  ],
                ),
               const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildInfoRow(TablerIcons.map_pin, 'Place', place.toTitle(),context)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildInfoRow(TablerIcons.palette, 'Color', color.toTitle(),context)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildInfoRow(TablerIcons.category, 'Category', category.toTitle(),context)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildInfoRow(TablerIcons.numbers, 'Quantity', quantity.toTitle(),context)),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: Color(0xFFF1F5F9), thickness: 1),
                ),
                CustText.detailLabel("Description"),
                SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.labelSpacing)),
                CustText.detailValue(description.toString().capitalizefirst())
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showIcons) Icon(icon, size: 16, color: AppColors.textColor4),
        if (showIcons) const SizedBox(width: 8),
        CustText.detailLabel("$label :"),
        SizedBox(width: ResponsiveHelper.spacing(context, AppConstants.labelSpacing)),
        Expanded(child: CustText.detailValue(value))
      ],
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
}
