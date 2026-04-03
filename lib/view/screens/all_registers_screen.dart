import 'package:flutter/material.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/constants/strings.dart';
import 'package:om_appcart/view/widgets/cust_text.dart';

import '../widgets/custom_app_bar.dart';

class AllRegistersScreen extends StatelessWidget {
  const AllRegistersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.allRegisters),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _registerCard(
            title: AppStrings.complaintRegister,
            newCount: '4',
            pendingCount: '10',
            closedCount: '2',
          ),
          const SizedBox(height: 12),
          _registerCard(
            title: AppStrings.occFailureRegister,
            newCount: '15',
            pendingCount: '20',
            closedCount: '3',
          ),
          const SizedBox(height: 12),
          _registerCard(
            title: AppStrings.stationFailureRegister,
            newCount: '12',
            pendingCount: '10',
            closedCount: '6',
          ),
        ],
      ),
    );
  }
}

Widget _registerCard({
  required String title,
  required String newCount,
  required String pendingCount,
  required String closedCount,
}) {
  return Builder(
    builder: (context) => Container(
      width: MediaQuery.of(context).size.width / 2,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white1,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustText(
                name: title,
                size: 1.8,
                fontWeightName: FontWeight.w600,
                color: AppColors.black,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: _statusIndicator(
                  count: newCount,
                  label: AppStrings.statusNew,
                  backgroundColor: AppColors.red.withOpacity(0.1),
                  color: AppColors.red,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: _statusIndicator(
                  count: pendingCount,
                  label: AppStrings.statusPending,
                  backgroundColor: AppColors.orange.withOpacity(0.1),
                  color: AppColors.orange,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: _statusIndicator(
                  count: closedCount,
                  label: AppStrings.statusClosed,
                  backgroundColor: AppColors.orange.withOpacity(0.1),
                  color: AppColors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _statusIndicator({
  required String count,
  required String label,
  required Color backgroundColor,
  required Color color,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustText(
          name: label,
          size: 1.4,
          color: color,
          fontWeightName: FontWeight.w500,
        ),
        CustText(name: count, size: 2.2, color: AppColors.textColor, fontWeightName: FontWeight.w600),

      ],
    ),
  );
}
