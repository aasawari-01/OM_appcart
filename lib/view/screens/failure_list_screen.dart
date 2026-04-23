import 'package:flutter/material.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/view/screens/view_detail_screen.dart' hide DetailColumn;
import 'package:om_appcart/view/widgets/skeleton_loader.dart';

import '../../feature/failure/view/failure_form.dart';
import '../../utils/responsive_helper.dart';
import '../widgets/cust_text.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/list_item_card_type1.dart';
import '../widgets/list_item_card_type2.dart';
import 'create_failure_screen.dart';
import '../widgets/cust_fab.dart';
import 'filter.dart';
import 'package:flutter/rendering.dart';

class FailureListScreen extends StatefulWidget {
  const FailureListScreen({Key? key}) : super(key: key);

  @override
  State<FailureListScreen> createState() => _FailureListScreenState();
}

class _FailureListScreenState extends State<FailureListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;
  bool _isLoading = false;
  bool _isFabExtended = true;

  // Dummy data for demonstration
  List<Map<String, String>> failures = [
    {
      'priority': 'Low',
      'status': 'Open',
      'failureNo': 'SIG/10-2024/0024',
      'createdOn': '17-10-2024 14:00',
      'location': 'DER',
    },
    {
      'priority': 'High',
      'status': 'Open',
      'failureNo': 'SIG/10-2024/0025',
      'createdOn': '15-10-2024 14:00',
      'location': 'DER',
    },
    {
      'priority': 'very High',
      'status': 'Ongoing',
      'failureNo': 'SIG/10-2024/0026',
      'createdOn': '12-10-2024 14:00',
      'location': 'DER',
    },
    {
      'priority': 'Medium',
      'status': 'Closed',
      'failureNo': 'SIG/10-2024/0027',
      'createdOn': '11-10-2024 14:00',
      'location': 'DER',
    },
    {
      'priority': 'High',
      'status': 'Ongoing',
      'failureNo': 'SIG/10-2024/0028',
      'createdOn': '10-10-2024 14:00',
      'location': 'DER',
    },
    {
      'priority': 'Low',
      'status': 'Closed',
      'failureNo': 'SIG/10-2024/0029',
      'createdOn': '09-10-2024 14:00',
      'location': 'DER',
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
    _simulateLoading();
  }

  void _simulateLoading() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
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
      case 1: // Ongoing
        return failures.where((failure) => failure['status'] == 'Ongoing').toList();
      case 2: // Close
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
          title: 'Maintainance List',
          showDrawer: false,
          onLeadingPressed: () => Navigator.pop(context),
          actions: [
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
              child: _isLoading
                  ? _buildSkeletonLoader()
                  : filteredFailures.isEmpty
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
                                  failures.remove(failure);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Failure deleted'), duration: Duration(seconds: 2)),
                                );
                              },
                              child: ListItemCardType1(
                                title: failure['failureNo'] ?? '',
                              statusText: failure['status'] ?? '',
                              statusColor: _getStatusColor(failure['status']),
                              leftBarColor: _getStatusColor(failure['status']),
                              subtitleTags: [
                                TagData(
                                  text: failure['priority'] ?? '',
                                  backgroundColor: AppColors.blue.withOpacity(0.05),
                                  textColor: AppColors.textColor,
                                ),
                                // TagData(
                                //   text: failure['status'] ?? '',
                                //   backgroundColor: AppColors.blue.withOpacity(0.05),
                                //   textColor: AppColors.textColor,
                                // ),
                              ],
                              detailColumns: [
                                DetailColumn(label: 'Location', value: failure['location'] ?? ''),
                                DetailColumn(label: 'Created on', value: failure['createdOn'] ?? ''),
                              ],
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
              MaterialPageRoute(builder: (context) => FailureForm()),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: SkeletonLoader.listItem(height: 100),
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

  Color _getPriorityColor(String? priority) {
    switch (priority) {
      case 'Low':
        return AppColors.darkBlue;
      case 'Medium':
        return AppColors.yellow;
      case 'High':
        return AppColors.orange;
      default:
        return AppColors.red;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Open':
        return AppColors.red;
      case 'Ongoing':
        return AppColors.orange;
      case 'Closed':
        return AppColors.green;
      default:
        return AppColors.textColor4;
    }
  }
}