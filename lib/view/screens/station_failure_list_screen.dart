import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../utils/responsive_helper.dart';
import '../widgets/cust_text.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/cust_fab.dart';
import 'station_failure_screen.dart';
import 'station_failure_detail_screen.dart';
import 'package:flutter/rendering.dart';

class StationFailureListScreen extends StatefulWidget {
  const StationFailureListScreen({Key? key}) : super(key: key);

  @override
  State<StationFailureListScreen> createState() => _StationFailureListScreenState();
}

class _StationFailureListScreenState extends State<StationFailureListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;
  bool _isFabExtended = true;

  // Dummy data for demonstration
  List<Map<String, String>> failures = [
    {
      'priority': 'High',
      'status': 'Open',
      'failureNo': 'STN/10-2024/0001',
      'createdOn': '18-10-2024 09:30',
      'location': 'ABC',
    },
    {
      'priority': 'Medium',
      'status': 'Closed',
      'failureNo': 'STN/10-2024/0002',
      'createdOn': '17-10-2024 15:20',
      'location': 'XYZ',
    },
    {
      'priority': 'Low',
      'status': 'Ongoing',
      'failureNo': 'STN/10-2024/0003',
      'createdOn': '16-10-2024 11:10',
      'location': 'DEF',
    },
    {
      'priority': 'High',
      'status': 'Open',
      'failureNo': 'STN/10-2024/0004',
      'createdOn': '15-10-2024 14:30',
      'location': 'GHI',
    },
    {
      'priority': 'Medium',
      'status': 'Ongoing',
      'failureNo': 'STN/10-2024/0005',
      'createdOn': '14-10-2024 10:15',
      'location': 'JKL',
    },
    {
      'priority': 'Low',
      'status': 'Closed',
      'failureNo': 'STN/10-2024/0006',
      'createdOn': '13-10-2024 16:45',
      'location': 'MNO',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get filteredFailures {
    switch (_selectedTabIndex) {
      case 0: // Open
        return failures.where((failure) => failure['status'] == 'Open').toList();
      case 1: // Close
        return  failures.where((failure) => failure['status'] == 'Ongoing').toList();
      case 2: // Ongoing
        return failures.where((failure) => failure['status'] == 'Closed').toList();
      default:
        return failures;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: CustomAppBar(
          title: 'Station Failure List',
          showDrawer: false,
          onLeadingPressed: () => Navigator.pop(context),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
              onPressed: () {
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Tab Bar
            Container(
              height: ResponsiveHelper.height(context, 44),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.textFieldColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.textColor3,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textColor3.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textColor4,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text('Open'),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text('Ongoing'),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text('Closed'),
                    ),
                  ),
                ],
              ),
            ),
            // List View
            Expanded(
              child: filteredFailures.isEmpty
                  ? Center(
                      child: CustText(
                        name: 'No ${_getTabName(_selectedTabIndex)} failures found',
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
                        itemCount: filteredFailures.length,
                        itemBuilder: (context, index) {
                          final failure = filteredFailures[index];
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
                              failures.remove(failure);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Station Failure deleted'), duration: Duration(seconds: 2)),
                            );
                          },
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => StationFailureDetailScreen()),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.dividerColor2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustText(name: 'Priority:', size: 1.3, color: AppColors.textColor4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: failure['priority'] == "Low"
                                                ? AppColors.darkBlue.withOpacity(0.1)
                                                : failure['priority'] == "Medium"
                                                    ? AppColors.yellow.withOpacity(0.1)
                                                    : failure['priority'] == "High"
                                                        ? AppColors.orange.withOpacity(0.1)
                                                        : AppColors.red.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: CustText(
                                            name: failure['priority'] ?? '',
                                            size: 1.3,
                                            color: failure['priority'] == "Low"
                                                ? AppColors.darkBlue
                                                : failure['priority'] == "Medium"
                                                    ? AppColors.yellow
                                                    : failure['priority'] == "High"
                                                        ? AppColors.orange
                                                        : AppColors.red,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        CustText(name: 'Failure No:', size: 1.3, color: AppColors.textColor4),
                                        CustText(
                                          name: failure['failureNo'] ?? '',
                                          size: 1.4,
                                          color: AppColors.black,
                                          fontWeightName: FontWeight.w600,
                                        ),
                                        SizedBox(height: 4),
                                        CustText(name: 'Location:', size: 1.3, color: AppColors.textColor4),
                                        CustText(
                                          name: failure['location'] ?? '',
                                          size: 1.4,
                                          color: AppColors.black,
                                          fontWeightName: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustText(name: 'Status:', size: 1.3, color: AppColors.textColor4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(failure['status']).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: CustText(
                                            name: failure['status'] ?? '',
                                            size: 1.3,
                                            color: _getStatusColor(failure['status']),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        CustText(name: 'Created On:', size: 1.3, color: AppColors.textColor4),
                                        CustText(
                                          name: failure['createdOn'] ?? '',
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
                          ),
                          ),
                        );
                      },
                    ),
                  ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: CustFab(
          label: 'Add Failure',
          icon: Icons.add,
          isExtended: _isFabExtended,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StationFailureScreen()),
            );
          },
        ),
      ),
    );
  }

  String _getTabName(int index) {
    switch (index) {
      case 0:
        return 'Open';
      case 1:
        return 'Ongoing';
      case 2:
        return 'Closed';
      default:
        return '';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Open':
        return AppColors.red;
      case 'Ongoing':
        return AppColors.green;
      case 'Closed':
        return AppColors.orange;
      default:
        return AppColors.textColor4;
    }
  }
} 