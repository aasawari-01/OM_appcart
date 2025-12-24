import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../screens/analysis_screen.dart';
import '../screens/home_screen.dart';
import '../screens/notification_screen.dart';
import '../screens/task_screen.dart';
import '../widgets/custom_drawer.dart';
import '../../constants/colors.dart'; // your color constants

class TabScreen extends StatefulWidget {
  final int index;
  const TabScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  late int _currentIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 1:
        return const TaskScreen();
      case 2:
        return const NotificationScreen();
      case 3:
        return AnalysisScreen();
      default:
        return HomeScreen(
          onMenuTap: () {
            print("menu");
            _scaffoldKey.currentState?.openDrawer();
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        } else {
          exit(0);
        }
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          extendBody: false,
          drawer: CustomDrawer(),
          body: _getScreen(_currentIndex),
          bottomNavigationBar: SafeArea(
            top: false,
            left: false,
            right: false,
            bottom: true,
            child: Container(
          decoration: BoxDecoration(
            color: AppColors.white1,
            // gradient: LinearGradient(
            //   begin: Alignment.centerLeft,
            //   end: Alignment.centerRight,
            //   colors: [
            //     AppColors.blue.withOpacity(0.7),
            //     AppColors.blueShade,
            //   ],
            // ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: GNav(
          backgroundColor: AppColors.white1, // important
          rippleColor: Colors.white.withOpacity(0.2),
          hoverColor: Colors.white.withOpacity(0.1),
          gap: 8,
          activeColor: Colors.white,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: AppColors.blue.withOpacity(0.7), // active tab bg
          color: Colors.white.withOpacity(0.7),
          selectedIndex: _currentIndex,
          onTabChange: _onTabTapped,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          tabs: [
            // 👇 replace icon with image
            GButton(
              icon: Icons.home, // still required, use a placeholder icon
              leading: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  _currentIndex == 0 ? AppColors.white1 : AppColors.tabImageColor,
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  "assets/images/1.png",
                  height: 24,
                  width: 24,
                ),
              ),
              text: 'Home',
              textStyle: GoogleFonts.workSans(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            GButton(
              icon: Icons.home, // still required, use a placeholder icon
              leading: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  _currentIndex == 1 ? AppColors.white1 : AppColors.tabImageColor,
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  "assets/images/2.png",
                  height: 24,
                  width: 24,
                ),
              ),
              text: 'Task',
              textStyle: GoogleFonts.workSans(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
            ),
            GButton(
                icon: Icons.home,
              leading: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  _currentIndex == 2 ? AppColors.white1 : AppColors.tabImageColor,
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  "assets/images/3.png",
                  height: 24,
                  width: 24,
                ),
              ),
              text: 'Notification',
              textStyle: GoogleFonts.workSans(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
            ),
            GButton(
                icon: Icons.home,
              leading: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  _currentIndex == 3 ? AppColors.white1 : AppColors.tabImageColor,
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  "assets/images/4.png",
                  height: 24,
                  width: 24,
                ),
              ),
              text: 'Analysis',
              textStyle: GoogleFonts.workSans(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ],
        ),
            ),
          ),
        ),
      ),
    );
  }
}
