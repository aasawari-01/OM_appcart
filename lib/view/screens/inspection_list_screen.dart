import 'package:flutter/material.dart';
import 'package:om_appcart/constants/colors.dart';

import '../widgets/cust_text.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/list_item_card_type1.dart';
import '../widgets/cust_fab.dart';
import 'filter.dart';
import 'inspection_detail_screen.dart';
import 'inspection_screen.dart';
import 'inspection_analytics_screen.dart';
import 'package:flutter/rendering.dart';

class InspectionListScreen extends StatefulWidget {
  const InspectionListScreen({Key? key}) : super(key: key);

  @override
  State<InspectionListScreen> createState() => _InspectionListScreenState();
}

class _InspectionListScreenState extends State<InspectionListScreen> {
  // Toggle state: 0 for Inspection List, 1 for Inspection Analytics
  int _selectedTabIndex = 0;
  bool _isFabExtended = true;

  // Dummy data updated to match the UI requirements
  List<Map<String, String>> inspections = [
    {
      'id': 'INS/02-2026/2110',
      'frequency': 'Monthly',
      'plan': 'Unscheduled', // Tag 1
      'department': 'Civil Department',
      'scheduledDate': '18/02/2026',
      'status': 'Open', // Tag 2
    },
    {
      'id': 'INS/02-2026/2110',
      'frequency': 'Weekly',
      'plan': 'Scheduled',
      'department': 'Civil Department',
      'scheduledDate': '18/02/2026',
      'status': 'Pending',
    },
    {
      'id': 'INS/02-2026/2110',
      'frequency': 'Monthly',
      'plan': 'Scheduled',
      'department': 'Civil Department',
      'scheduledDate': '18/02/2026',
      'status': 'Completed',
    },
    {
      'id': 'INS/02-2026/2110',
      'frequency': 'Weekly',
      'plan': 'Unscheduled',
      'department': 'Civil Department',
      'scheduledDate': '18/02/2026',
      'status': 'Pending',
    },
    {
      'id': 'INS/02-2026/2110',
      'frequency': 'Monthly',
      'plan': 'Scheduled',
      'department': 'Civil Department',
      'scheduledDate': '18/02/2026',
      'status': 'Completed',
    },
    {
      'id': 'INS/02-2026/2110',
      'frequency': 'Weekly',
      'plan': 'Unscheduled',
      'department': 'Civil Department',
      'scheduledDate': '18/02/2026',
      'status': 'Pending',
    },
  ];

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return AppColors.barColor1; // Red-ish
      case 'completed':
        return AppColors.barColor4; // Green
      case 'pending':
        return AppColors.yellow;
      default:
        return AppColors.grey;
    }
  }

  Color _getPlanColor(String plan) {
    switch (plan.toLowerCase()) {
      case 'unscheduled':
        return AppColors.unschedule; // Light Orange bg
      case 'scheduled':
        return AppColors.schedule; // Light Blue bg
      default:
        return Colors.grey.shade200;
    }
  }

  Color _getPlanTextColor(String plan) {
    switch (plan.toLowerCase()) {
      case 'unscheduled':
        return AppColors.maroon;
      case 'scheduled':
        return AppColors.blue2;
      default:
        return AppColors.textColor4;
    }
  }

  Color _getLeftBarColor(String status) {
     switch (status.toLowerCase()) {
      case 'open':
      case 'unscheduled':
        return AppColors.barColor1;
      case 'pending':
        return AppColors.yellow;
      case 'completed':
        return AppColors.barColor4; 
      default:
        return AppColors.blue;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: const CustomAppBar(
        title: 'Inspection List',
        showDrawer: false,

        // onLeadingPressed: () => Navigator.pop(context), // Assuming default back behavior is wanted or managed by CustomAppBar
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Custom Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 45,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTabIndex = 0),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(6,6,3,6),
                      decoration: BoxDecoration(
                        color: _selectedTabIndex == 0
                            ? AppColors.gradientEnd
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.list,
                            color: _selectedTabIndex == 0
                                ? Colors.white
                                : AppColors.textColor4,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          CustText(
                            name: 'Inspection List',
                            size: 1.4,
                            color: _selectedTabIndex == 0
                                ? Colors.white
                                : AppColors.textColor4,
                            fontWeightName: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTabIndex = 1),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(3,6,6,6),
                      decoration: BoxDecoration(
                        color: _selectedTabIndex == 1
                            ? AppColors.gradientEnd
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.pie_chart_outline,
                            color: _selectedTabIndex == 1
                                ? Colors.white
                                : AppColors.textColor4,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          CustText(
                            name: 'Inspection Analytics',
                            size: 1.4,
                            color: _selectedTabIndex == 1
                                ? Colors.white
                                : AppColors.textColor4,
                            fontWeightName: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(height: 16),
          Expanded(
            child: _selectedTabIndex == 0
                ? NotificationListener<UserScrollNotification>(
                    onNotification: (notification) {
                      if (notification.direction == ScrollDirection.forward) {
                        if (!_isFabExtended) setState(() => _isFabExtended = true);
                      } else if (notification.direction == ScrollDirection.reverse) {
                        if (_isFabExtended) setState(() => _isFabExtended = false);
                      }
                      return true;
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      itemCount: inspections.length,
                      itemBuilder: (context, index) {
                        final data = inspections[index];
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            inspections.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Inspection deleted'), duration: Duration(seconds: 2)),
                          );
                        },
                        child: ListItemCardType1(
                          title: data['id'] ?? '',
                        statusText: data['status'] ?? '',
                        statusColor: _getStatusColor(data['status'] ?? ''),
                        leftBarColor: _getLeftBarColor(data['status'] ?? ''),
                        subtitleTags: [
                          TagData(
                            text: data['plan'] ?? '',
                            backgroundColor: AppColors.blue.withOpacity(0.05),
                            textColor: AppColors.textColor,
                          ),
                          TagData(
                            text: data['department'] ?? '',
                            backgroundColor: AppColors.blue.withOpacity(0.05),
                            textColor: AppColors.textColor,
                          ),
                        ],
                        detailColumns: [
                          DetailColumn(label: 'Frequency', value: data['frequency'] ?? ''),
                          DetailColumn(label: 'Scheduled On', value: data['scheduledDate'] ?? ''),
                        ],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const InspectionDetailScreen()),
                        ),
                      ),
                      );
                    },
                  ),
                )
                : const InspectionAnalyticsScreen(),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustFab(
        label: 'Add Inspection',
        icon: Icons.add,
        isExtended: _isFabExtended,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InspectionScreen()),
          );
        },
      ),
    );
  }

}