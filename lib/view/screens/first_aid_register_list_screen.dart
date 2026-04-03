import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../widgets/cust_text.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_sheet.dart';
import '../widgets/cust_fab.dart';
import 'first_aid_register_form.dart';
import 'package:flutter/rendering.dart';

class FirstAidRegisterListScreen extends StatefulWidget {
  const FirstAidRegisterListScreen({Key? key}) : super(key: key);

  @override
  State<FirstAidRegisterListScreen> createState() => _FirstAidRegisterListScreenState();
}

class _FirstAidRegisterListScreenState extends State<FirstAidRegisterListScreen> {
  bool _isFabExtended = true;

  List<Map<String, String>> firstAidList = [
    {
      'firstAidNo': 'FA001',
      'station': 'Khapri',
      'dateTime': '08/02/2025 14:00',
      'passengerName': 'Amit Kumar',
      'age': '32',
      'gender': 'Male',
      'address': '123 Main St',
      'consentAmbulance': 'Required',
      'reason': 'Fainted',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: 'First Aid Register List',
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
      body: firstAidList.isEmpty
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
          itemCount: firstAidList.length,
          itemBuilder: (context, index) {
            final item = firstAidList[index];
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
                firstAidList.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('First Aid record deleted'), duration: Duration(seconds: 2)),
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
                            CustText(name: 'First Aid No:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: item['firstAidNo'] ?? '',
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
                            CustText(name: 'Passenger Name:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: item['passengerName'] ?? '',
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
                            CustText(name: 'Age:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: item['age'] ?? '',
                              size: 1.4,
                              color: AppColors.black,
                              fontWeightName: FontWeight.w600,
                            ),
                            const SizedBox(height: 4),
                            CustText(name: 'Gender:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: item['gender'] ?? '',
                              size: 1.4,
                              color: AppColors.black,
                              fontWeightName: FontWeight.w600,
                            ),
                            const SizedBox(height: 4),
                            CustText(name: 'Address:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: item['address'] ?? '',
                              size: 1.4,
                              color: AppColors.black,
                              fontWeightName: FontWeight.w600,
                            ),
                            const SizedBox(height: 4),
                            CustText(name: 'Consent for Ambulance:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: item['consentAmbulance'] ?? '',
                              size: 1.4,
                              color: AppColors.black,
                              fontWeightName: FontWeight.w600,
                            ),
                            const SizedBox(height: 4),
                            CustText(name: 'Reason:', size: 1.3, color: AppColors.textColor4),
                            CustText(
                              name: item['reason'] ?? '',
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
                        title: "First Aid No : ${item['firstAidNo'] ?? ''}",
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
      label: 'Add First Aid',
      icon: Icons.add,
      isExtended: _isFabExtended,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FirstAidRegisterForm()),
        );
      },
    ),
  );
}
}
