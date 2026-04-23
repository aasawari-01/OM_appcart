import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/colors.dart';
import '../../../utils/responsive_helper.dart';
import '../../../view/widgets/accordion_card.dart';
import '../../../view/widgets/cust_text.dart';
import '../../../view/widgets/custom_app_bar.dart';
import '../controller/user_profile_controller.dart';
import '../model/user_profile_model.dart';
import '../../../view/widgets/skeleton_loader.dart';
import '../../../view/widgets/cust_loader.dart';
import '../../../service/network_service/app_urls.dart';
import '../../../utils/string_utils.dart';
import 'edit_profile_view.dart';
import 'package:om_appcart/view/widgets/full_image_viewer.dart';
import '../../../constants/strings.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_images.dart';

class ProfileView extends GetView<UserProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<UserProfileController>()) {
      Get.put(UserProfileController());
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.myProfile,
        showDrawer: false,
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => const EditProfileView()),
            child: const Icon(TablerIcons.edit, color: AppColors.gradientStart),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.profileData.value == null) {
          return const CustLoader();
        }
        final data = controller.profileData.value;
        return CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildHeaderCard(context, data),
                ],
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                child: _buildTabs(),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.sectionSpacing)),
                  Container(key: controller.personalKey, child: _buildPersonalDetailsTab(context, data)),
                  SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.sectionSpacing)),
                  Container(key: controller.employeeKey, child: _buildEmployeeDetailsTab(context, data)),
                  SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.sectionSpacing)),
                  Container(key: controller.financeKey, child: _buildFinanceDetailsTab(context, data)),
                  SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.sectionSpacing)),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeaderCard(BuildContext context, UserProfileData? data) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.spacing(context, AppConstants.cardPadding)),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1, -0.2),
                    end: Alignment(1, 0.2),
                    colors: [
                      Color(0xFF007EAB),
                      Color(0xFF5CC1E5),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Obx(() {
                          final imageFile = controller.selectedImage.value;
                          final profilePicUrl = data?.profilePic;
                          return GestureDetector(
                            onTap: () {
                              final provider = imageFile != null
                                  ? FileImage(imageFile)
                                  : (profilePicUrl != null && profilePicUrl.isNotEmpty
                                  ? NetworkImage(profilePicUrl.startsWith('http') ? profilePicUrl : "${AppUrls.baseUrl}$profilePicUrl")
                                      : const AssetImage(AppAssets.profilePic)) as ImageProvider;
                              FullImageViewer.show(context, imageProvider: provider, heroTag: 'profilePic');
                            },
                            child: Hero(
                              tag: 'profilePic',
                              child: SizedBox(
                                height: ResponsiveHelper.height(context, 56),
                                child: CircleAvatar(
                                  radius: ResponsiveHelper.spacing(context, 35),
                                  backgroundColor: AppColors.white1,
                                  backgroundImage: imageFile != null
                                      ? FileImage(imageFile)
                                      : (profilePicUrl != null && profilePicUrl.isNotEmpty
                                      ? NetworkImage(profilePicUrl.startsWith('http') ? profilePicUrl : "${AppUrls.baseUrl}$profilePicUrl")
                                          : const AssetImage(AppAssets.profilePic)) as ImageProvider,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    SizedBox(width: ResponsiveHelper.width(context, AppConstants.elementSpacing)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustText(
                            name: '${data?.firstName.toTitle() ?? ""} ${data?.lastName.toTitle() ?? ""}',
                            size: 1.8,
                            color: AppColors.white1,
                            fontWeightName: FontWeight.w600,
                          ),
                          CustText(
                            name: (data?.designation?.name ?? '').toTitle(),
                            size: 1.4,
                            color: AppColors.white2,
                            fontWeightName: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  right: 10,
                  top: 10,
                  child: Image.asset(AppAssets.profileBg,height: ResponsiveHelper.height(context, 80),))
            ],
          ),
          Padding(
            padding: EdgeInsets.all(ResponsiveHelper.spacing(context, AppConstants.cardPadding)),
            child: Column(
              children: [
                _buildHeaderRow('Emp No :', data?.userDetails?.employeeID ?? data?.uniqueCode ?? 'N/A'),
                SizedBox(height: ResponsiveHelper.spacing(context, 4)),
                _buildHeaderRow('Department :', data?.departments?.isNotEmpty == true ? data!.departments!.map((e) => e.name.toTitle()).join(", ") : 'NA'),
                SizedBox(height: ResponsiveHelper.spacing(context, 4)),
                _buildHeaderRow(
                  'Allocated Stations :',
                  data?.stations?.isNotEmpty == true ? data!.stations!.map((e) => e.name.toTitle()).join(", ") : 'N/A',
                ),
                SizedBox(height: ResponsiveHelper.spacing(context, 4)),
                _buildHeaderRow('Date of Joining :', data?.userDetails?.dateOfJoining ?? 'N/A'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: CustText.detailLabel(label)
        ),
        Expanded(
          flex: 3,
          child: CustText.detailValue(value)
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white1,
        border: Border(bottom: BorderSide(color: AppColors.dividerColor2, width: 1),top:  BorderSide(color: AppColors.dividerColor2, width: 1)),
      ),
      child: TabBar(
        controller: controller.tabController,
        labelColor: AppColors.blue,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        unselectedLabelColor: AppColors.textColor4,
        indicatorColor: AppColors.blue,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 16),
        unselectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w400, fontSize: 16),
        onTap: (index) => controller.scrollToSection(index),
        tabs: const [
          Tab(text: AppStrings.personalDetails),
          Tab(text: AppStrings.employeeDetails),
          Tab(text: AppStrings.financeDetails),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsTab(BuildContext context, UserProfileData? data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.spacing(context, AppConstants.horizontalPadding)),
      child: AccordionCard(
        title: AppStrings.personalDetails,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow(context, AppStrings.nameLabel, '${data?.firstName.toTitle() ?? ""} ${data?.lastName.toTitle() ?? ""}', AppStrings.dateOfBirth, data?.userDetails?.dateOfBirth ?? AppStrings.notAvailable),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            _detailRow(context, AppStrings.gender, data?.userDetails?.gender?.toTitle() ?? AppStrings.notAvailable, AppStrings.birthPlace, data?.userDetails?.birthPlace?.toTitle() ?? AppStrings.notAvailable),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            _detailRow(context, AppStrings.contactNumber, data?.contactNo ?? AppStrings.notAvailable, AppStrings.altContactNumber, data?.userDetails?.alternateContactNo ?? AppStrings.notAvailable),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            _detailRow(context, AppStrings.panCard, data?.userDetails?.panCardNo?.toUpperCase() ?? AppStrings.notAvailable, AppStrings.aadharCard, data?.userDetails?.aadharCardNo ?? AppStrings.notAvailable),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            _detailRow(context, AppStrings.bloodGroup, data?.userDetails?.bloodGroup ?? AppStrings.notAvailable, AppStrings.shiftType, data?.userDetails?.shiftType?.toTitle() ?? AppStrings.notAvailable),
            
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.sectionSpacing)),
            CustText.sectionHeader(AppStrings.permanentAddress),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            _buildAddressDetails(context, data?.userDetails?.permanentAddress),
            
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.sectionSpacing)),
            CustText.sectionHeader(AppStrings.currentAddress),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            _buildAddressDetails(context, data?.userDetails?.currentAddress),
          ],
        ),
      ),
    );
  }



  Widget _buildAddressDetails(BuildContext context, String? addressStr) {
    if (addressStr == null || addressStr.isEmpty || addressStr == 'N/A') {
      return Text(AppStrings.notAvailable, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textColor));
    }
    
    List<String> parts = addressStr.split('|');
    if (parts.length == 6) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailRow(context, AppStrings.resHouseNo, parts[0].isEmpty ? AppStrings.notAvailable : parts[0], AppStrings.localityTownVillage, parts[1].isEmpty ? AppStrings.notAvailable : parts[1]),
          SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
          _detailRow(context, AppStrings.pincode, parts[2].isEmpty ? AppStrings.notAvailable : parts[2], AppStrings.city, parts[3].isEmpty ? AppStrings.notAvailable : parts[3]),
          SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
          _detailRow(context, AppStrings.state, parts[4].isEmpty ? AppStrings.notAvailable : parts[4], AppStrings.country, parts[5].isEmpty ? AppStrings.notAvailable : parts[5]),
        ],
      );
    }

    // Fallback display
    return Text(
      addressStr.toTitle(),
      style: GoogleFonts.outfit(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.textColor,
      ),
    );
  }

  Widget _buildEmployeeDetailsTab(BuildContext context, UserProfileData? data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.spacing(context, AppConstants.horizontalPadding)),
      child: AccordionCard(
        title: AppStrings.employeeDetails,
        child: Column(
          children: [
            _detailRow(context, AppStrings.dateOfJoining, data?.userDetails?.dateOfJoining ?? AppStrings.notAvailable, AppStrings.city, data?.cities?.isNotEmpty == true ? data!.cities!.first.name.toTitle() : AppStrings.notAvailable),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            _detailRow(context, AppStrings.department, data?.departments?.isNotEmpty == true ? data!.departments!.first.name.toTitle() : AppStrings.notAvailable, AppStrings.station, data?.stations?.isNotEmpty == true ? data!.stations!.first.name.toTitle() : AppStrings.notAvailable),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            _detailRow(context, AppStrings.role, data?.role?.name.toTitle() ?? AppStrings.notAvailable, AppStrings.designation, data?.designation?.name.toTitle() ?? AppStrings.notAvailable),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            _detailRow(context, AppStrings.dutyShift, data?.userDetails?.shiftType?.toTitle() ?? AppStrings.notAvailable, '', ''),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceDetailsTab(BuildContext context, UserProfileData? data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.spacing(context, AppConstants.horizontalPadding)),
      child: AccordionCard(
        title: AppStrings.financeDetails,
        child: Column(
          children: [
            _detailRow(context, AppStrings.bankName, AppStrings.notAvailable, AppStrings.accountNumber, AppStrings.notAvailable),
            SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.elementSpacing)),
            _detailRow(context, AppStrings.ifscCode, AppStrings.notAvailable, AppStrings.branchName, AppStrings.notAvailable),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(BuildContext context, String leftLabel, String leftValue, String rightLabel, String rightValue) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _detailItem(context, leftLabel, leftValue)),
        SizedBox(width: ResponsiveHelper.width(context, AppConstants.elementSpacing)),
        if (rightLabel.isNotEmpty)
          Expanded(child: _detailItem(context, rightLabel, rightValue))
        else
          const Spacer(),
      ],
    );
  }

  Widget _detailItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       CustText.detailLabel(label),
        SizedBox(height: ResponsiveHelper.spacing(context, 4)),
        CustText.detailValue(value),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.bgColor, // Matches background
      child: child,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
