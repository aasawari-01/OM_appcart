import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:om_appcart/utils/responsive_helper.dart';
import '../../feature/user_profile/view/profile_view.dart';
import 'home_screen.dart';
import '../../constants/colors.dart';
import '../widgets/cust_text.dart';
import '../../feature/auth_login/view/login_view.dart';
import '../widgets/custom_app_bar.dart';
import '../../service/auth_manager.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Settings',
        showDrawer: false,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Header Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/drawer/profile_pic.png'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustText(
                          name: 'Rohan Sharma',
                          size: 2,
                          fontWeightName: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                        CustText(
                          name: 'Station In-charge',
                          size: 1.4,
                          color: AppColors.textColor.withOpacity(0.6),
                          fontWeightName: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap:() =>  Get.to(() => const ProfileView()),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F7FA), // Light blue tint
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(TablerIcons.edit_circle, size: 16, color: AppColors.blue),
                          const SizedBox(width: 4),
                          CustText(
                            name: 'Edit Profile',
                            size: 1.4,
                            color: AppColors.blue,
                            fontWeightName: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: ResponsiveHelper.spacing(context, 24)),

              // Contact Info
              _buildContactRow(TablerIcons.mail, 'rohansharma@example.com'),
              SizedBox(height: ResponsiveHelper.spacing(context, 8)),
              _buildContactRow(TablerIcons.phone, '+91 9876543210'),

              SizedBox(height: ResponsiveHelper.spacing(context, 16)),
              const Divider(thickness: 1, color: Color(0xFFF0F0F0)),
              SizedBox(height: ResponsiveHelper.spacing(context, 8)),
              // General Section
              const CustText(
                name: 'General',
                size: 1.6,
                fontWeightName: FontWeight.w700,
                color: AppColors.textColor,
              ),
              SizedBox(height: ResponsiveHelper.spacing(context, 16)),
              _buildSettingsTile(icon: TablerIcons.color_swatch, title: 'Theme Settings',context: context),
              SizedBox(height: ResponsiveHelper.spacing(context, 16)),
              _buildSettingsTile(icon: TablerIcons.lock_password, title: 'Change Password',context: context),
              SizedBox(height: ResponsiveHelper.spacing(context, 16)),
              const Divider(thickness: 1, color: Color(0xFFF0F0F0)),
              SizedBox(height: ResponsiveHelper.spacing(context, 8)),
              const CustText(
                name: 'Help & Support',
                size: 1.6,
                fontWeightName: FontWeight.w700,
                color: AppColors.textColor,
              ),
              SizedBox(height: ResponsiveHelper.spacing(context, 16)),
              _buildSettingsTile(icon: TablerIcons.help_circle, title: 'Help Center', context: context),
              SizedBox(height: ResponsiveHelper.spacing(context, 16)),
              _buildSettingsTile(icon: TablerIcons.message_2, title: 'Feedback', context: context),
              SizedBox(height: ResponsiveHelper.spacing(context, 16)),
              const Divider(thickness: 1, color: Color(0xFFF0F0F0)),
              SizedBox(height: ResponsiveHelper.spacing(context, 16)),
              // Logout
              InkWell(
                onTap: () async {
                  await AuthManager().logout();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginView()),
                      (route) => false,
                    );
                  }
                },
                child: Row(
                  children: [
                    Icon(TablerIcons.arrow_left_from_arc, color: AppColors.red, size: 24),
                    SizedBox(width: ResponsiveHelper.spacing(context, 4)),
                    const CustText(
                      name: 'Logout',
                      size: 1.6,
                      color: AppColors.red,
                      fontWeightName: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(context, 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 24, color: AppColors.blue),
        const SizedBox(width: 12),
        CustText(
          name: text,
          size: 1.6,
          color: AppColors.textColor.withOpacity(0.7),
          fontWeightName: FontWeight.w400,
        ),
      ],
    );
  }

  Widget _buildSettingsTile({required IconData icon, required String title, required BuildContext context, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppColors.textColor),
          SizedBox(width: ResponsiveHelper.spacing(context, 4)),
          CustText(
            name: title,
            size: 1.5,
            color: AppColors.textColor,
            fontWeightName: FontWeight.w500,
          ),
        ],
      ),
    );
  }

}

