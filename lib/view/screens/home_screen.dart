import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:om_appcart/utils/responsive_helper.dart';
import 'package:om_appcart/view/screens/inspection_list_screen.dart';
import 'package:om_appcart/view/screens/tab_screen.dart';
import '../../constants/colors.dart';
import '../widgets/cust_text.dart';
import '../widgets/skeleton_loader.dart';

import 'failure_list_screen.dart';
import 'station_diary_screen.dart';
import 'create_failure_screen.dart';
import 'station_failure_list_screen.dart';
import 'station_failure_screen.dart';
import 'all_registers_screen.dart';

import '../../feature/user_profile/controller/user_profile_controller.dart';
import '../../utils/string_utils.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onMenuTap;

  const HomeScreen({super.key, required this.onMenuTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Show skeleton loader for 3 seconds to demonstrate
    _simulateLoading();
  }

  void _simulateLoading() async {
    setState(() {
      _isLoading = true;
    });
    
    // Wait 3 seconds to show skeleton loader
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("home2");
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: _isLoading
            ? _buildSkeletonLoader()
            : Stack(
                children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.blue.withOpacity(1),
                    AppColors.blue.withOpacity(0),
                  ],
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: ResponsiveHelper.spacing(context, 32)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: widget.onMenuTap,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.menuBackgroundColor
                                  .withOpacity(0.5),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: const Icon(
                              TablerIcons.menu_2,
                              color: AppColors.white2,
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.spacing(context, 12)),
                        Expanded(
                          child: Obx(() {
                            final userController = Get.find<UserProfileController>();
                            final user = userController.profileData.value;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustText(
                                  name: "Hello, ${(user?.firstName ?? 'User').capitalizeFirstLetter()}!",
                                  size: 2.2,
                                  color: AppColors.white2,
                                  fontWeightName: FontWeight.w500,
                                ),
                                 PopupMenuButton<String>(
                                  offset: const Offset(0, 42),
                                  elevation: 3,
                                  color: Colors.white,
                                  surfaceTintColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  onSelected: (value) {},
                                  itemBuilder: (context) {
                                    final currentRole = user?.role?.name;
                                    return [
                                      PopupMenuItem<String>(
                                        value: currentRole,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustText(
                                              name: currentRole ?? "N/A",
                                              size: 1.6,
                                              color: AppColors.textColor5,
                                              fontWeightName: FontWeight.w500,
                                            ),
                                            const SizedBox(width: 12),
                                            const Icon(
                                              TablerIcons.check,
                                              color: AppColors.blue,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ];
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustText(
                                        name: user?.role?.name ?? "N/A",
                                        size: 1.5,
                                        color: AppColors.white2
                                            .withOpacity(0.9),
                                        fontWeightName: FontWeight.w500,
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(TablerIcons.caret_down_filled,
                                          color: AppColors.white2
                                              .withOpacity(0.9),
                                          size: 16)
                                    ],
                                  ),
                                ),


                              ],
                            );
                          }),
                        ),
                        // const Spacer(),
                        // Container(
                        //   padding: const EdgeInsets.all(4),
                        //   decoration: BoxDecoration(
                        //     color: AppColors.white2,
                        //     borderRadius: BorderRadius.circular(7),
                        //   ),
                        //   child: CustText(
                        //     name: "RS",
                        //     size: 1.8,
                        //     color: AppColors.blue,
                        //     fontWeightName: FontWeight.w600,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: ResponsiveHelper.height(context, 140),
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            // 3 cards + view all button
                            separatorBuilder: (_, __) =>
                                SizedBox(width: ResponsiveHelper.spacing(context, 12)),
                            itemBuilder: (context, index) {
                              if (index < 3) {
                                return SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: _registerCard(
                                    title: index == 0
                                        ? "Complaint Register"
                                        : index == 1
                                            ? "OCC Failure Register"
                                            : "Station Failure Register",
                                    newCount: index == 0
                                        ? "4"
                                        : index == 1
                                            ? "15"
                                            : "12",
                                    pendingCount: index == 0
                                        ? "10"
                                        : index == 1
                                            ? "20"
                                            : "10",
                                    closedCount: index == 0
                                        ? "2"
                                        : index == 1
                                            ? "3"
                                            : "6",
                                  ),
                                );
                              }
                              // trailing "View All" button as the 4th list item
                              return Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const AllRegistersScreen(),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: AppColors.menuBackgroundColor
                                              .withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                            TablerIcons.arrow_right,
                                            color: AppColors.white2),
                                      ),
                                      SizedBox(width: ResponsiveHelper.spacing(context, 8)),
                                      CustText(
                                          name: "View All",
                                          size: 1.6,
                                          color: AppColors.white1),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(context, 16)),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.white1,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        height:
                                            ResponsiveHelper.spacing(context, 16)),
                                    _section(
                                        "Quick Action",
                                        [
                                          _iconItem("assets/images/f1.png",
                                              "Maintainance\n Failure", () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const FailureListScreen()),
                                            );
                                          }, context),
                                          _iconItem("assets/images/f2.png",
                                              "Station\n Failures", () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const StationFailureListScreen()),
                                            );
                                          }, context),
                                          _iconItem("assets/images/s1.png",
                                              "Station Diary", () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const StationDiaryScreen()),
                                            );
                                          }, context),
                                          _iconItem("assets/images/s1.png",
                                              "Inspection", () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const InspectionListScreen()),
                                            );
                                          }, context),
                                          // _iconItem("assets/images/f4.png", "Request\nPart", () {}, context),
                                        ],
                                        context),

                                    // _section("Station Operation", [
                                    //   _iconItem("assets/images/s1.png", "Station Diary", () {
                                    //     Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(builder: (_) => const StationDiaryScreen()),
                                    //     );
                                    //   }, context),
                                    // ], context),
                                    SizedBox(
                                        height:
                                            ResponsiveHelper.spacing(context, 16)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustText(
                                          name: "Recent Notifications",
                                          size: 2.1,
                                          color: AppColors.textColor5,
                                          fontWeightName: FontWeight.w600,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(
                                                context); // Close drawer
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const TabScreen(
                                                            index: 2)));
                                          },
                                          child: CustText(
                                            name: 'View All',
                                            size: 1.8,
                                            color: AppColors.blue,
                                            fontWeightName: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            ResponsiveHelper.spacing(context, 8)),
                                    _notificationCard(
                                      title: "System Update",
                                      message:
                                          "The app will be updated tonight at 2:00 AM.",
                                      time: "Just now",
                                    ),
                                    _notificationCard(
                                      title: "New Task Assigned",
                                      message:
                                          "You have been assigned a new inspection task.",
                                      time: "10 min ago",
                                    ),
                                    _notificationCard(
                                      title: "Feedback Received",
                                      message:
                                          "A new feedback has been submitted by a user.",
                                      time: "1 hour ago",
                                    ),
                                    _notificationCard(
                                      title: "Maintenance Alert",
                                      message:
                                          "Scheduled maintenance on 20/06/2025.",
                                      time: "Yesterday",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              child: IgnorePointer(
                child: Image.asset(
                  "assets/images/home_bg.png",
                  width: double.infinity,
                  // height: 200,
                  opacity: AlwaysStoppedAnimation(0.6),
                  // color: Colors.red,
                  // fit: BoxFit.fitWidth, // you can adjust fit
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationCard(
      {required String title, required String message, required String time}) {
    return Card(
      color: AppColors.white1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        title: CustText(
          name: title,
          size: 1.7,
          color: AppColors.textColor5,
          fontWeightName: FontWeight.w600,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustText(
              name: message,
              size: 1.5,
              color: AppColors.textColor,
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 4)),
            CustText(
              name: time,
              size: 1.3,
              color: AppColors.hintTextColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerCard({
    required String title,
    required String newCount,
    required String pendingCount,
    required String closedCount,
  }) {
    return Builder(
      builder: (context) => Container(
        width: double.infinity,
        padding: EdgeInsets.all(ResponsiveHelper.spacing(context, 16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustText(
                  name: title,
                  size: 1.8,
                  fontWeightName: FontWeight.w600,
                  color: AppColors.black,
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 13)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: _statusIndicator(
                    count: newCount,
                    label: "New",
                    backgroundColor: AppColors.red.withOpacity(0.1),
                    color: AppColors.red,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.spacing(context, 8)),
                Expanded(
                  flex: 1,
                  child: _statusIndicator(
                    count: pendingCount,
                    label: "Pending",
                    backgroundColor: AppColors.orange.withOpacity(0.1),
                    color: AppColors.orange,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.spacing(context, 8)),
                Expanded(
                  flex: 1,
                  child: _statusIndicator(
                    count: closedCount,
                    label: "Closed",
                    backgroundColor: AppColors.orange.withOpacity(0.1),
                    color: AppColors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusIndicator({
    required String count,
    required String label,
    required Color backgroundColor,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.spacing(context, 14), vertical: ResponsiveHelper.spacing(context, 8)),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustText(
            name: label,
            size: 1.4,
            color: color,
            fontWeightName: FontWeight.w500,
          ),
          CustText(
              name: count,
              size: 2.2,
              color: AppColors.textColor,
              fontWeightName: FontWeight.w600),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> items, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustText(
          name: title,
          size: 2.1,
          color: AppColors.textColor5,
          fontWeightName: FontWeight.w600,
        ),
        SizedBox(height: ResponsiveHelper.spacing(context, 12)),
        GridView.count(
          padding: EdgeInsets.zero,
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: List.generate(4, (index) {
            if (index < items.length) {
              return items[index];
            } else {
              return const SizedBox();
            }
          }),
        ),
      ],
    );
  }

  /// ICON ITEM
  Widget _iconItem(
      String iconImage, String label, VoidCallback onTap, context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            iconImage,
            height: ResponsiveHelper.height(context, 48),
          ),
          SizedBox(height: ResponsiveHelper.spacing(context, 6)),
          CustText(
            name: label,
            size: 1.4,
            textAlign: TextAlign.center,
            color: AppColors.textColor,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            fontWeightName: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header skeleton
          Row(
            children: [
              SkeletonLoader.avatar(size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoader.title(height: 24, width: 150),
                    const SizedBox(height: 8),
                    SkeletonLoader.subtitle(height: 16, width: 120),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Horizontal cards skeleton
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) => SkeletonLoader.card(
                height: 140,
                width: MediaQuery.of(context).size.width * 0.85,
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Grid sections skeleton
          SkeletonLoader.title(height: 24),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(4, (index) => Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  SkeletonLoader.avatar(size: 40),
                  const SizedBox(height: 8),
                  SkeletonLoader.subtitle(height: 13, width: 60),
                ],
              ),
            )),
          ),
          const SizedBox(height: 24),
          
          // Status cards skeleton
          SkeletonLoader.title(height: 24),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: SkeletonLoader.card(height: 80)),
              const SizedBox(width: 12),
              Expanded(child: SkeletonLoader.card(height: 80)),
              const SizedBox(width: 12),
              Expanded(child: SkeletonLoader.card(height: 80)),
            ],
          ),
        ],
      ),
    );
  }
}
