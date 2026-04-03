import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../widgets/cust_text.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_sheet.dart';
import '../widgets/cust_fab.dart';
import 'manual_ticket_details_form.dart';
import 'package:flutter/rendering.dart';

class ManualTicketDetailsListScreen extends StatefulWidget {
  const ManualTicketDetailsListScreen({Key? key}) : super(key: key);

  @override
  State<ManualTicketDetailsListScreen> createState() => _ManualTicketDetailsListScreenState();
}

class _ManualTicketDetailsListScreenState extends State<ManualTicketDetailsListScreen> {
  bool _isFabExtended = true;

  List<Map<String, String>> manualTicketList = [
    {
      'manualTicketNo': 'MT001',
      'station': 'Khapri',
      'date': '08/02/2025',
      'time': '14:00',
      'operatorName': 'Amit Kumar',
      'sourceStation': 'Khapri',
      'destinationStation': 'Airport',
      'fareAmount': '50',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: 'Manual Ticket List',
        showDrawer: false,
        onLeadingPressed: () => Navigator.pop(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
            onPressed: () {
              // Optional: Filter logic
            },
          ),
        ],
      ),
      body: manualTicketList.isEmpty
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
                itemCount: manualTicketList.length,
                itemBuilder: (context, index) {
                  final item = manualTicketList[index];
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
                manualTicketList.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Manual Ticket deleted'), duration: Duration(seconds: 2)),
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
                            CustText(name: 'Manual Ticket No:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: item['manualTicketNo'] ?? '',
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
                            CustText(name: 'Date:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: item['date'] ?? '',
                              size: 1.4,
                              color: AppColors.black,
                              fontWeightName: FontWeight.w600,
                            ),
                            const SizedBox(height: 4),
                            CustText(name: 'Time:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: item['time'] ?? '',
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
                            CustText(name: 'Operator Name:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: item['operatorName'] ?? '',
                              size: 1.4,
                              color: AppColors.black,
                              fontWeightName: FontWeight.w600,
                            ),
                            const SizedBox(height: 4),
                            CustText(name: 'Source Station:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: item['sourceStation'] ?? '',
                              size: 1.4,
                              color: AppColors.black,
                              fontWeightName: FontWeight.w600,
                            ),
                            const SizedBox(height: 4),
                            CustText(name: 'Destination Station:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: item['destinationStation'] ?? '',
                              size: 1.4,
                              color: AppColors.black,
                              fontWeightName: FontWeight.w600,
                            ),
                            const SizedBox(height: 4),
                            CustText(name: 'Fare Amount:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: '₹${item['fareAmount'] ?? ''}',
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
                        title: "Manual Ticket No : ${item['manualTicketNo'] ?? ''}",
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
        label: 'Add Manual Ticket',
        icon: Icons.add,
        isExtended: _isFabExtended,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ManualTicketDetailsForm()));
        },
      ),
    );
  }
}
