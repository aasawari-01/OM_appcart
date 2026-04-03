import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../widgets/cust_text.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/list_item_card_type1.dart';
import 'complaint_feedback_detail_screen.dart';
import 'complaint_feedback_screen.dart';
import 'filter.dart';
import '../widgets/cust_fab.dart';
import 'package:flutter/rendering.dart';

class ComplaintFeedbackListScreen extends StatefulWidget {
  const ComplaintFeedbackListScreen({Key? key}) : super(key: key);

  @override
  State<ComplaintFeedbackListScreen> createState() => _ComplaintFeedbackListScreenState();
}

class _ComplaintFeedbackListScreenState extends State<ComplaintFeedbackListScreen> {
  bool _isFabExtended = true;

  // Dummy data for demonstration
  List<Map<String, String>> complaints = [
    {
      'type': 'Complaint',
      'status': 'Open',
      'complaintNo': 'CMP/10-2024/0001',
      'createdOn': '17-10-2024 10:00',
      'category': 'Staff Complaints',
    },
    {
      'type': 'Feedback',
      'status': 'Closed',
      'complaintNo': 'FDB/10-2024/0002',
      'createdOn': '16-10-2024 09:30',
      'category': 'Suggestions',
    },
    {
      'type': 'Complaint',
      'status': 'Pending',
      'complaintNo': 'CMP/10-2024/0003',
      'createdOn': '15-10-2024 14:20',
      'category': 'Security/Safety',
    },
    {
      'type': 'Feedback',
      'status': 'Open',
      'complaintNo': 'FDB/10-2024/0004',
      'createdOn': '14-10-2024 11:45',
      'category': 'Appreciation',
    },
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: 'Complaint & Feedback List',
        showDrawer: false,
        onLeadingPressed: () => Navigator.pop(context),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.search, color: Colors.white),
          //   onPressed: () {},
          // ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
            onPressed: () {
              print("filter");
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  final size = MediaQuery.of(context).size;
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: size.height,
                      width: size.width,
                      child: Material(
                        color: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: const FilterPopup(),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            if (!_isFabExtended) setState(() => _isFabExtended = true);
          } else if (notification.direction == ScrollDirection.reverse) {
            if (_isFabExtended) setState(() => _isFabExtended = false);
          }
          return true;
        },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: complaints.length,
          itemBuilder: (context, index) {
            final complaint = complaints[index];
          final String status = complaint['status'] ?? '';
          
          Color statusColor;
          switch (status.toLowerCase()) {
            case 'open':
              statusColor = AppColors.red;
              break;
            case 'closed':
              statusColor = AppColors.green;
              break;
            case 'pending':
              statusColor = AppColors.orange;
              break;
            default:
              statusColor = AppColors.textColor4;
          }

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
                complaints.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Complaint/Feedback deleted'), duration: Duration(seconds: 2)),
              );
            },
            child: ListItemCardType1(
              onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ComplaintFeedbackDetailScreen()),
            ),
            title: complaint['complaintNo'] ?? '',
            statusText: status,
            statusColor: statusColor,
            leftBarColor: statusColor,
            subtitleTags: [
              TagData(
                text: complaint['type'] ?? '',
                backgroundColor: AppColors.textColor4.withOpacity(0.1),
                textColor: AppColors.textColor,
              ),
            ],
            detailColumns: [
              DetailColumn(label: 'Category', value: complaint['category'] ?? ''),
              DetailColumn(label: 'Created On', value: complaint['createdOn'] ?? ''),
            ],
          ),
          );
        },
      ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustFab(
        label: 'Add Complaint / Feedback',
        icon: Icons.add,
        isExtended: _isFabExtended,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ComplaintFeedbackScreen()),
          );
        },
      ),
    );
  }
}
