import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../widgets/cust_text.dart';
import '../widgets/custom_app_bar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white1,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             CustomAppBar(
              title: "Alerts",
              showDrawer: true,
              onLeadingPressed: () => Scaffold.of(context).openDrawer(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 16),
                  _buildDateHeader("Today, 20/02/2026"),
                  const SizedBox(height: 8),
                  _notificationCard(
                    title: "Incident Reported on Station Name",
                    message: "Incident Report",
                    time: "1 min ago",
                  ),
                  _notificationCard(
                    title: "Inspection INSP-2045 is due in 2 hours.",
                    message: "Inspection",
                    time: "2 min ago",
                  ),
                  _notificationCard(
                    title: "Inspection INSP-2045 has been created for Platform 2.",
                    message: "Inspection",
                    time: "3 hrs ago",
                  ),
                  const SizedBox(height: 16),
                  _buildDateHeader("19/02/2026"),
                  const SizedBox(height: 8),
                  _notificationCard(
                    title: "Lost request reported on station name",
                    message: "Incident Report",
                    time: "20/02/2026 11:00 AM",
                  ),
                  _notificationCard(
                    title: "Incident Reported on Station Name",
                    message: "Incident Report",
                    time: "2 min ago",
                  ),
                  _notificationCard(
                    title: "Incident Reported on Station Name",
                    message: "Incident Report",
                    time: "2 min ago",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader(String date) {
    return CustText(
      name: date,
      size: 1.8,
      color: AppColors.textColor5,
      fontWeightName: FontWeight.w600,
    );
  }

  Widget _notificationCard({required String title, required String message, required String time}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.containerColor1,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustText(
                    name: title,
                    size: 1.7,
                    color: AppColors.textColor5,
                    fontWeightName: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustText(
                  name: message,
                  size: 1.5,
                  color: AppColors.textColor,
                ),
                CustText(
                  name: time,
                  size: 1.4,
                  color: AppColors.hintTextColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
