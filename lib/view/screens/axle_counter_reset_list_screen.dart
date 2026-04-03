import 'package:flutter/material.dart';


import '../../constants/colors.dart';
import '../widgets/cust_text.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_sheet.dart';
import '../widgets/cust_fab.dart';
import 'axle_counter_reset_form.dart';
import 'package:flutter/rendering.dart';

class AxleCounterResetListScreen extends StatefulWidget {
  const AxleCounterResetListScreen({Key? key}) : super(key: key);

  @override
  State<AxleCounterResetListScreen> createState() => _AxleCounterResetListScreenState();
}

class _AxleCounterResetListScreenState extends State<AxleCounterResetListScreen> {
  bool _isFabExtended = true;

  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration
    List<Map<String, String>> axleCounterList = [
      {
        'axleCounterNo': 'ACR001',
        'station': 'Khapri',
        'dateTime': '08/02/2025 14:00',
        'sddNo': 'SDD12',
        'location': 'Platform 1',
        'counterAfterReset': '100',
        'scEmployeeNo': 'SC123',
        'occPvtNo': '12',
        'stationPvtNo': '1234567890',
        'purpose': 'Routine check',
      },
      {
        'axleCounterNo': 'ACR002',
        'station': 'Airport',
        'dateTime': '09/02/2025 10:30',
        'sddNo': 'SDD15',
        'location': 'Platform 2',
        'counterAfterReset': '200',
        'scEmployeeNo': 'SC456',
        'occPvtNo': '15',
        'stationPvtNo': '9876543210',
        'purpose': 'Maintenance',
      },
      {
        'axleCounterNo': 'ACR003',
        'station': 'Zero Mile',
        'dateTime': '10/02/2025 09:00',
        'sddNo': 'SDD18',
        'location': 'Platform 3',
        'counterAfterReset': '150',
        'scEmployeeNo': 'SC789',
        'occPvtNo': '18',
        'stationPvtNo': '1122334455',
        'purpose': 'Emergency reset',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: 'Axle Counter Reset Register List',
        showDrawer: false,
        onLeadingPressed: () => Navigator.pop(context),
        actions: [
          // Row(
          //   children: [
          //     ElevatedButton(
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: AppColors.textColor4,
          //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //       ),
          //       onPressed: () {
          //         // TODO: Implement clear all logic
          //       },
          //       child: const Text('Clear All', style: TextStyle(color: Colors.white)),
          //     ),
          //     const SizedBox(width: 8),
          //   ],
          // ),
        ],
      ),
      body: axleCounterList.isEmpty
          ? Center(
              child: CustText(
                name: 'No data available in table',
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
                itemCount: axleCounterList.length,
                itemBuilder: (context, index) {
                  final item = axleCounterList[index];
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
                      axleCounterList.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Axle Counter Reset deleted'), duration: Duration(seconds: 2)),
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
                                  CustText(name: 'Axle Counter No:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: item['axleCounterNo'] ?? '',
                                    size: 1.4,
                                    color: AppColors.black,
                                    fontWeightName: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  CustText(name: 'Station:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: item['station'] ?? '',
                                    size: 1.4,
                                    color: AppColors.black,
                                    fontWeightName: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  CustText(name: 'Date & Time:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: item['dateTime'] ?? '',
                                    size: 1.4,
                                    color: AppColors.black,
                                    fontWeightName: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  CustText(name: 'SDD No:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: item['sddNo'] ?? '',
                                    size: 1.4,
                                    color: AppColors.black,
                                    fontWeightName: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  CustText(name: 'Location:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: item['location'] ?? '',
                                    size: 1.4,
                                    color: AppColors.black,
                                    fontWeightName: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  CustText(name: 'Counter No. After Reset:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: item['counterAfterReset'] ?? '',
                                    size: 1.4,
                                    color: AppColors.black,
                                    fontWeightName: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustText(name: 'SC Employee No:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: item['scEmployeeNo'] ?? '',
                                    size: 1.4,
                                    color: AppColors.black,
                                    fontWeightName: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  CustText(name: 'OCC PVT No:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: item['occPvtNo'] ?? '',
                                    size: 1.4,
                                    color: AppColors.black,
                                    fontWeightName: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  CustText(name: 'Station PVT No:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: item['stationPvtNo'] ?? '',
                                    size: 1.4,
                                    color: AppColors.black,
                                    fontWeightName: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  CustText(name: 'Purpose:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: item['purpose'] ?? '',
                                    size: 1.4,
                                    color: AppColors.black,
                                    fontWeightName: FontWeight.w600,
                                  ),
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
                          onPressed: () {
                            CustomBottomSheet.show(
                              context: context,
                              title: "Axle Counter No : ${item['axleCounterNo'] ?? ''}",
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
                          },
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
        label: 'Add Axle Counter Reset',
        icon: Icons.add,
        isExtended: _isFabExtended,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AxleCounterResetForm()),
          );
        },
      ),
    );
  }
}