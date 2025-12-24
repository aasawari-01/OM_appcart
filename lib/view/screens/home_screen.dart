import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:om_appcart/utils/size_config.dart';
import '../../constants/colors.dart';
import '../widgets/cust_text.dart';
import '../widgets/custom_drawer.dart';
import 'station_diary_screen.dart';
import 'create_failure_screen.dart';
import 'station_failure_screen.dart';
import 'all_registers_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onMenuTap;
  const HomeScreen({super.key,required this.onMenuTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
initState() {
    super.initState();
   print("home");
  }
  Future<void> _onRefresh() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {}); // rebuild UI if needed
  }
  @override
  Widget build(BuildContext context) {
    print("home2");
    return  Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      body: RefreshIndicator(
          onRefresh: _onRefresh,
        child: Stack(
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
                    SizedBox(height: 3 * SizeConfig.heightMultiplier),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              print("menu");
                              _scaffoldKey.currentState?.openDrawer();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.menuBackgroundColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: const Icon(
                                TablerIcons.menu_2,
                                color: AppColors.white2,
                              ),
                            ),
                          ),
                          SizedBox(width: 3 * SizeConfig.widthMultiplier),
                          CustText(
                            name: "Hello, Rohan!",
                            size: 2.2,
                            color: AppColors.white2,
                            fontWeightName: FontWeight.w400,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.white2,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: CustText(
                              name: "RS",
                              size: 1.8,
                              color: AppColors.blue,
                              fontWeightName: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 130,
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                scrollDirection: Axis.horizontal,
                                itemCount: 4, // 3 cards + view all button
                                separatorBuilder: (_, __) => const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  if (index < 3) {
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.78,
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
                                            builder: (_) => const AllRegistersScreen(),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: AppColors.menuBackgroundColor.withOpacity(0.5),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(TablerIcons.arrow_right, color: AppColors.white2),
                                          ),
                                          const SizedBox(width: 8),
                                          CustText(name: "View All", size: 1.6, color: AppColors.white1),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // SingleChildScrollView(
                            //   padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                            //   scrollDirection: Axis.horizontal,
                            //   child: Row(
                            //     children: [
                            //       _registerCard(
                            //         title: "Complaint\nRegister",
                            //         newCount: "4",
                            //         pendingCount: "10",
                            //         closedCount: "2",
                            //       ),
                            //       const SizedBox(width: 9),
                            //       _registerCard(
                            //         title: "OCC Failure\nRegister",
                            //         newCount: "15",
                            //         pendingCount: "20",
                            //         closedCount: "3",
                            //       ),
                            //       const SizedBox(width: 9),
                            //       _registerCard(
                            //         title: "Station Failure\nRegister",
                            //         newCount: "12",
                            //         pendingCount: "10",
                            //         closedCount: "6",
                            //       ),
                            //     ],
                            //   ),
                            // ),
                             SizedBox(height: 2 * SizeConfig.heightMultiplier),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.white1,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 1 * SizeConfig.heightMultiplier),
                                  _section("Failure & Maintenance", [
                                    _iconItem("assets/images/f1.png", "Report\n Failure", () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const CreateFailureScreen()),
                                      );
                                    }, context),
                                    _iconItem("assets/images/f2.png", "Assigned\n Failures", () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const StationFailureScreen()),
                                      );
                                    }, context),
                                    _iconItem("assets/images/f3.png", "Maintenance\n Tasks", () {}, context),
                                    _iconItem("assets/images/f4.png", "Request\nPart", () {}, context),
                                  ], context),

                                  _section("Permit & Restrictions", [
                                    _iconItem("assets/images/p1.png", "Permit To Work", () {}, context),
                                    _iconItem("assets/images/p2.png", "Validate Permit", () {}, context),
                                    _iconItem("assets/images/p3.png", "Raise TSR", () {}, context),
                                  ], context),

                                  _section("Station Operation", [
                                    _iconItem("assets/images/s1.png", "Station Diary", () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const StationDiaryScreen()),
                                      );
                                    }, context),
                                  ], context),
                                ],
                              ),
                            ),
                          ],
                        ),
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

  Widget _registerCard({
    required String title,
    required String newCount,
    required String pendingCount,
    required String closedCount,
  }) {
    return Builder(
      builder: (context) => Container(
        width: MediaQuery.of(context).size.width/2,
        padding: EdgeInsets.all(16),
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
            SizedBox(height: 16),
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
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: _statusIndicator(
                    count: pendingCount,
                    label: "Pending",
                    backgroundColor: AppColors.orange.withOpacity(0.1),
                    color: AppColors.orange,
                  ),
                ),
                SizedBox(width: 8),
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
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
          CustText(name: count, size: 1.8, color: AppColors.textColor, fontWeightName: FontWeight.w600),

        ],
      ),
    );
  }
  Widget _section(String title, List<Widget> items,context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: AppColors.white1,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.dividerColor,width: 2)

        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustText(
                name: title,
                size: 2,
                color: AppColors.textColor5,
                fontWeightName: FontWeight.w500,
              ),
              const SizedBox(height: 12),
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
          ),
        ),
      ),
    );
  }

  /// ICON ITEM
  Widget _iconItem(String iconImage, String label, VoidCallback onTap,context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            iconImage,
            height: 9 * SizeConfig.imageSizeMultiplier,),
          const SizedBox(height: 6),
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
}


