import 'package:flutter/material.dart';
import 'package:om_appcart/constants/app_constants.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/utils/app_date_utils.dart';
import 'package:om_appcart/view/widgets/cust_text.dart';
import '../../model/lost_found_table_record.dart';
import 'package:om_appcart/utils/string_utils.dart';

class DetailHistorySection extends StatelessWidget {
  final List<History> history;

  const DetailHistorySection({
    Key? key,
    required this.history,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: CustText(
            name: 'Lost & Found History',
            size: AppConstants.sectionHeaderSize,
            fontWeightName: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        ...history.map((item) => _buildHistoryItem(item)).toList(),
      ],
    );
  }

  Widget _buildHistoryItem(History item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: CustText(
                      name: '#${item.id}',
                      size: 1.1,
                      fontWeightName: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  CustText(
                    name: item.action.toTitle(),
                    size: 1.3,
                    fontWeightName: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CustText(
                  name: item.status.toTitle(),
                  size: 1.0,
                  fontWeightName: FontWeight.bold,
                  color: const Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFF1F5F9), thickness: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 18, color: AppColors.textColor4),
              const SizedBox(width: 8),
              Expanded(
                child: CustText(
                  name: item.createdBy.toTitle(),
                  size: 1.2,
                  color: AppColors.black,
                  fontWeightName: FontWeight.w500,
                ),
              ),
              const Icon(Icons.access_time, size: 16, color: AppColors.textColor4),
              const SizedBox(width: 4),
              CustText(
                name: item.createdAt != null ? AppDateUtils.formatDate(item.createdAt!) : 'N/A',
                size: 1.1,
                color: AppColors.textColor4,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.notes_outlined, size: 18, color: AppColors.textColor4),
              const SizedBox(width: 8),
              Expanded(
                child: CustText(
                  name: 'Remark: ${item.remark.capitalizefirst()}',
                  size: 1.1,
                  color: AppColors.textColor4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
