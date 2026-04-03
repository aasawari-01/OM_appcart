import 'package:flutter/material.dart';
import 'package:om_appcart/constants/colors.dart';

import '../widgets/cust_text.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_sheet.dart';
import '../widgets/cust_fab.dart';
import 'divyang_form.dart';
import 'package:flutter/rendering.dart';

class DivyangListScreen extends StatefulWidget {
  const DivyangListScreen({Key? key}) : super(key: key);

  @override
  State<DivyangListScreen> createState() => _DivyangListScreenState();
}

class _DivyangListScreenState extends State<DivyangListScreen> {
  bool _isFabExtended = true;

  List<Map<String, String>> divyangList = [
    {
      'divyangId': 'DIV001',
      'station': 'Khapri',
      'name': 'Amit Kumar',
      'reportingTime': '10:00 AM',
      'contactNo': '9876543210',
      'disabilityType': 'Divyang',
      'wheelchairProvided': 'Yes',
      'journey': 'Khapri - Airport',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: 'Divyang List',
        showDrawer: false,
        onLeadingPressed: () => Navigator.pop(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
            onPressed: () {
              // Optional: Implement filter logic
            },
          ),
        ],
      ),
      body: divyangList.isEmpty
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
          itemCount: divyangList.length,
          itemBuilder: (context, index) {
            final divyang = divyangList[index];
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
                divyangList.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Divyang record deleted'), duration: Duration(seconds: 2)),
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
                            CustText(name: 'Divyang Id:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: divyang['divyangId'] ?? '',
                              size: 1.4,
                              color: AppColors.black,
                              fontWeightName: FontWeight.w600,
                            ),
                            const SizedBox(height: 4),
                            CustText(name: 'Station:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: divyang['station'] ?? '',
                              size: 1.4,
                              color: AppColors.black,
                              fontWeightName: FontWeight.w600,
                            ),
                            const SizedBox(height: 4),
                            CustText(name: 'Passenger Name:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: divyang['name'] ?? '',
                              size: 1.4,
                              color: AppColors.black,
                              fontWeightName: FontWeight.w600,
                            ),
                            const SizedBox(height: 4),
                            CustText(name: 'Reporting Time:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: divyang['reportingTime'] ?? '',
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
                            CustText(name: 'Contact No.:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: divyang['contactNo'] ?? '',
                              size: 1.4,
                              color: AppColors.black,
                              fontWeightName: FontWeight.w600,
                            ),
                            const SizedBox(height: 4),
                            CustText(name: 'Disability Type:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: divyang['disabilityType'] ?? '',
                              size: 1.4,
                              color: AppColors.black,
                              fontWeightName: FontWeight.w600,
                            ),
                            const SizedBox(height: 4),
                            CustText(name: 'Wheelchair Provided:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: divyang['wheelchairProvided'] ?? '',
                              size: 1.4,
                              color: AppColors.black,
                              fontWeightName: FontWeight.w600,
                            ),
                            const SizedBox(height: 4),
                            CustText(name: 'Journey Start - End:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: divyang['journey'] ?? '',
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
                        title: "Divyang Id : ${divyang['divyangId'] ?? ''}",
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
        label: 'Add Divyang',
        icon: Icons.add,
        isExtended: _isFabExtended,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DivyangForm()));
        },
      ),
    );
  }
}
