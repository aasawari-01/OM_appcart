import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../widgets/cust_text.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_sheet.dart';
import '../widgets/cust_fab.dart';
import 'assurance_register_form.dart';
import 'package:flutter/rendering.dart';

class AssuranceRegisterListScreen extends StatefulWidget {
  const AssuranceRegisterListScreen({Key? key}) : super(key: key);

  @override
  State<AssuranceRegisterListScreen> createState() => _AssuranceRegisterListScreenState();
}

class _AssuranceRegisterListScreenState extends State<AssuranceRegisterListScreen> {
  bool _isFabExtended = true;

  // Dummy data for demonstration
  List<Map<String, String>> assuranceList = [
    {
      'assuranceId': 'SOASS/01-2025/0005',
      'topic': 'TRS',
      'date': '24-01-2025',
      'type': 'Special Instruction',
      'docNo': 'Trs45',
      'line': 'Line 1',
      'modRemarks': 'Enter Modification Remarks',
    },
    {
      'assuranceId': 'SOASS/12-2024/0002',
      'topic': 'Test',
      'date': '10-12-2024',
      'type': 'Temporary Instruction',
      'docNo': 'TestDoc',
      'line': 'Line 1',
      'modRemarks': 'Enter Modification Remarks',
    },
    {
      'assuranceId': 'SOASS/12-2024/0001',
      'topic': 'Test',
      'date': '09-12-2024',
      'type': 'Temporary Instruction',
      'docNo': 'TestDoc2',
      'line': 'Line 1',
      'modRemarks': 'Enter Modification Remarks',
    },
    {
      'assuranceId': 'SOASS/09-2024/0013',
      'topic': 'Test at 11/09/2024',
      'date': '11-09-2024',
      'type': 'Register Instruction',
      'docNo': 'Doc11',
      'line': 'Both Line',
      'modRemarks': 'Enter Modification Remarks',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: 'Assurance Register List',
        showDrawer: false,
        onLeadingPressed: () => Navigator.pop(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: assuranceList.isEmpty
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
                itemCount: assuranceList.length,
                itemBuilder: (context, index) {
                  final assurance = assuranceList[index];

                void _showBottomSheet() {
                  CustomBottomSheet.show(
                    context: context,
                    title: "Assurance ID : ${assurance['assuranceId'] ?? ''}",
                    options: [
                      CustomBottomSheetOption(
                        title: 'Edit',
                        icon: Icons.edit,
                        iconColor: AppColors.gradientEnd,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AssuranceRegisterForm()),
                          );
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
                      assuranceList.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Assurance deleted'), duration: Duration(seconds: 2)),
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
                                  CustText(name: 'Assurance ID No.:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: assurance['assuranceId'] ?? '',
                                    size: 1.4,
                                    color: AppColors.black,
                                    fontWeightName: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  CustText(name: 'Assurance Topic:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: assurance['topic'] ?? '',
                                    size: 1.4,
                                    color: AppColors.black,
                                    fontWeightName: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  CustText(name: 'Assurance Date:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: assurance['date'] ?? '',
                                    size: 1.4,
                                    color: AppColors.black,
                                    fontWeightName: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  CustText(name: 'Assurance Type:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: assurance['type'] ?? '',
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
                                  CustText(name: 'Document Number:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: assurance['docNo'] ?? '',
                                    size: 1.4,
                                    color: AppColors.black,
                                    fontWeightName: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  CustText(name: 'Line:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: assurance['line'] ?? '',
                                    size: 1.4,
                                    color: AppColors.black,
                                    fontWeightName: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  CustText(name: 'Modification Remarks:', size: 1.3, color: AppColors.textColor4),
                                  CustText(
                                    name: assurance['modRemarks'] ?? '',
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
        label: 'Add Assurance Register',
        icon: Icons.add,
        isExtended: _isFabExtended,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AssuranceRegisterForm()),
          );
        },
      ),
    );
  }
}