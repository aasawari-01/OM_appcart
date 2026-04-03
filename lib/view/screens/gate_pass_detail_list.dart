import 'package:flutter/material.dart';
import 'package:om_appcart/constants/colors.dart';

import '../widgets/cust_text.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_sheet.dart';
import '../widgets/cust_fab.dart';
import 'gate_pass_details_form.dart';
import 'package:flutter/rendering.dart';

class GatePassDetailsList extends StatefulWidget {
  const GatePassDetailsList({super.key});

  @override
  State<GatePassDetailsList> createState() => _GatePassDetailsListState();
}

class _GatePassDetailsListState extends State<GatePassDetailsList> {
  bool _isFabExtended = true;

  List<Map<String, String>> gatePassList = [
    {
      'station': 'Pune',
      'date': '2025-07-15',
      'returnable': 'Returnable',
      'purpose': 'Hardware Dispatch',
      'employee': 'John Doe',
      'department': 'IT',
      'phone': '9876543210',
      'description': 'Canon Printer',
    },
    {
      'station': 'Delhi',
      'date': '2025-06-20',
      'returnable': 'Non-Returnable',
      'purpose': 'Projector Replacement',
      'employee': 'Priya Sharma',
      'department': 'Admin',
      'phone': '9123456789',
      'description': 'Epson Projector',
    },
    {
      'station': 'Mumbai',
      'date': '2025-05-30',
      'returnable': 'Returnable',
      'purpose': 'Scanner Loan',
      'employee': 'Amit Patel',
      'department': 'QA',
      'phone': '9988776655',
      'description': 'HP Scanner',
    },
    {
      'station': 'Chennai',
      'date': '2025-07-01',
      'returnable': 'Non-Returnable',
      'purpose': 'IT Asset Disposal',
      'employee': 'Divya Iyer',
      'department': 'IT',
      'phone': '9090909090',
      'description': 'Old CPU',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: 'Gate Pass Details',
        showDrawer: false,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: gatePassList.isEmpty
          ? Center(
        child: CustText(
          name: 'No data available',
          size: 1.6,
          color: AppColors.textColor4,
        ),
            )
          : NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                if (notification.direction == ScrollDirection.forward) {
                  if (!_isFabExtended) setState(() => _isFabExtended = true);
                } else if (notification.direction == ScrollDirection.reverse) {
                  if (_isFabExtended) setState(() => _isFabExtended = false);
                }
                return true;
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: gatePassList.length,
                itemBuilder: (context, index) {
                  final item = gatePassList[index];

          void _showBottomSheet() {
            CustomBottomSheet.show(
              context: context,
              title: "${item['station']} - ${item['description']}",
              options: [
                CustomBottomSheetOption(
                  title: 'Edit',
                  icon: Icons.edit,
                  iconColor: AppColors.gradientEnd,
                  onTap: () {
                    // TODO: Implement edit logic
                  },
                ),
                CustomBottomSheetOption(
                  title: 'Delete',
                  icon: Icons.delete,
                  iconColor: Colors.red,
                  onTap: () {
                    // TODO: Implement delete logic
                  },
                ),
              ],
            );
          }

          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            background: Container(
              margin: const EdgeInsets.only(bottom: 8),
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
                gatePassList.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gate Pass deleted'), duration: Duration(seconds: 2)),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.dividerColor2),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextPair("Station", item['station']),
                            _buildTextPair("Date", item['date']),
                            _buildTextPair("Returnable", item['returnable']),
                            _buildTextPair("Purpose", item['purpose']),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextPair("Employee", item['employee']),
                            _buildTextPair("Department", item['department']),
                            _buildTextPair("Phone", item['phone']),
                            _buildTextPair("Description", item['description']),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.more_vert, color: AppColors.textColor4),
                    onPressed: _showBottomSheet,
                  ),
                ),
              ],
            ),
            ),
          );
        },
      ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton: CustFab(
        label: 'Add Gate Pass',
        icon: Icons.add,
        isExtended: _isFabExtended,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GatePassDetailsForm()),
          );
        },
      ),
    );
  }

  Widget _buildTextPair(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustText(name: '$label:', size: 1.3, color: AppColors.textColor4),
          CustText(
            name: value ?? '',
            size: 1.4,
            color: AppColors.black,
            fontWeightName: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
