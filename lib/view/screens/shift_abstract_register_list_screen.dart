import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../widgets/cust_text.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_sheet.dart';
import '../widgets/custom_bottom_sheet.dart';
import '../widgets/cust_fab.dart';
import 'shift_abstract_register_form.dart';
import 'package:flutter/rendering.dart';

class ShiftAbstractRegisterListScreen extends StatefulWidget {
  const ShiftAbstractRegisterListScreen({Key? key}) : super(key: key);

  @override
  State<ShiftAbstractRegisterListScreen> createState() => _ShiftAbstractRegisterListScreenState();
}

class _ShiftAbstractRegisterListScreenState extends State<ShiftAbstractRegisterListScreen> {
  bool _isFabExtended = true;

  // Dummy data for demonstration
  List<Map<String, String>> shiftAbstractList = [
    {
      'station': 'SAT- Airport South',
      'date': '08/02/2025',
      'tomOrEfo': 'TOM',
      'dutyStartTime': '14:00',
      'dutyEndTime': '15:00',
      'privateCash': 'Yes',
      'remarks': 'Tested And Verified',
    },
    {
      'station': 'AQS- Automotive Square',
      'date': '03/02/2025',
      'tomOrEfo': 'TOM',
      'dutyStartTime': '13:00',
      'dutyEndTime': '21:00',
      'privateCash': 'Yes',
      'remarks': 'Test@SAF',
    },
    {
      'station': 'NAO- Airport',
      'date': '27/07/2024',
      'tomOrEfo': 'TOM',
      'dutyStartTime': '12:00',
      'dutyEndTime': '12:00',
      'privateCash': 'Yes',
      'remarks': '5465',
    },
    {
      'station': 'CSS- Congress Nagar',
      'date': '08/07/2024',
      'tomOrEfo': 'TOM',
      'dutyStartTime': '05:30',
      'dutyEndTime': '13:30',
      'privateCash': 'No',
      'remarks': 'vbcv',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: 'Shift Abstract Register Inbox',
        showDrawer: false,
        onLeadingPressed: () => Navigator.pop(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: shiftAbstractList.isEmpty
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
                itemCount: shiftAbstractList.length,
                itemBuilder: (context, index) {
                  final item = shiftAbstractList[index];

                void _showBottomSheet() {
                  CustomBottomSheet.show(
                    context: context,
                    title: "Station : ${item['station'] ?? ''}",
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
                      shiftAbstractList.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Shift Abstract deleted'), duration: Duration(seconds: 2)),
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
                                  CustText(name: 'Station:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: item['station'] ?? '',
                                    size: 1.4,
                                    color: AppColors.black,
                                    fontWeightName: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  CustText(name: 'Date:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: item['date'] ?? '',
                                    size: 1.4,
                                    color: AppColors.black,
                                    fontWeightName: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  CustText(name: 'Tom OR Efo:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: item['tomOrEfo'] ?? '',
                                    size: 1.4,
                                    color: AppColors.black,
                                    fontWeightName: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  CustText(name: 'Duty Start Time:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: item['dutyStartTime'] ?? '',
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
                                  CustText(name: 'Duty End Time:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: item['dutyEndTime'] ?? '',
                                    size: 1.4,
                                    color: AppColors.black,
                                    fontWeightName: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  CustText(name: 'Private Cash:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: item['privateCash'] ?? '',
                                    size: 1.4,
                                    color: AppColors.black,
                                    fontWeightName: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  CustText(name: 'Remarks:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: item['remarks'] ?? '',
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
        label: 'Add Shift Abstract',
        icon: Icons.add,
        isExtended: _isFabExtended,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ShiftAbstractRegisterForm()),
          );
        },
      ),
    );
  }
}