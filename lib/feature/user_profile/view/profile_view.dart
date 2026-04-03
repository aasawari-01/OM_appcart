import 'dart:io';
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
import '../../../service/network_service/app_urls.dart';
import '../../../utils/string_utils.dart';
import 'edit_profile_view.dart';
import 'package:om_appcart/view/widgets/full_image_viewer.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with SingleTickerProviderStateMixin {
  final UserProfileController controller = Get.put(UserProfileController());
  
  bool _isPersonalExpanded = true;
  bool _isPermanentAddressExpanded = true;
  bool _isCurrentAddressExpanded = true;
  bool _isEmploymentExpanded = true;
  bool _isFinanceExpanded = true;

  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _personalKey = GlobalKey();
  final GlobalKey _employmentKey = GlobalKey();
  final GlobalKey _financeKey = GlobalKey();

  bool _isScrollingFromAuto = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_isScrollingFromAuto) return;

    final personalOffset = _getOffset(_personalKey);
    final employmentOffset = _getOffset(_employmentKey);
    final financeOffset = _getOffset(_financeKey);

    if (_scrollController.offset >= (financeOffset - 100)) {
      if (_tabController.index != 2) _tabController.animateTo(2);
    } else if (_scrollController.offset >= (employmentOffset - 100)) {
      if (_tabController.index != 1) _tabController.animateTo(1);
    } else {
      if (_tabController.index != 0) _tabController.animateTo(0);
    }
  }

  double _getOffset(GlobalKey key) {
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return 0;
    return renderBox.localToGlobal(Offset.zero, ancestor: null).dy + _scrollController.offset - 250;
  }

  void _scrollToSection(int index) {
    _isScrollingFromAuto = true;
    _tabController.animateTo(index);
    
    GlobalKey targetKey;
    switch (index) {
      case 0: targetKey = _personalKey; break;
      case 1: targetKey = _employmentKey; break;
      case 2: targetKey = _financeKey; break;
      default: targetKey = _personalKey;
    }

    final context = targetKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      ).then((_) {
        _isScrollingFromAuto = false;
      });
    } else {
      _isScrollingFromAuto = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Profile',
        showDrawer: false,
        actions: [
          // IconButton(
          //   padding: EdgeInsets.zero,
          //   icon: const Icon(TablerIcons.edit, color: AppColors.gradientStart),
          //   onPressed: () => Get.to(() => const EditProfileView()),
          // ),
          GestureDetector(
            onTap: () => Get.to(() => const EditProfileView()),
            child: const Icon(TablerIcons.edit, color: AppColors.gradientStart),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.profileData.value == null) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SkeletonLoader.card(height: 150),
                const SizedBox(height: 20),
                SkeletonLoader.paragraph(lines: 4),
                const SizedBox(height: 20),
                SkeletonLoader.paragraph(lines: 4),
              ],
            ),
          );
        }

        final data = controller.profileData.value;

        return CustomScrollView(
          controller: _scrollController,
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
              child: Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Container(key: _personalKey, child: _buildPersonalDetailsTab(data)),
                    const SizedBox(height: 16),
                    Container(key: _employmentKey, child: _buildEmploymentDetailsTab(data)),
                    const SizedBox(height: 16),
                    Container(key: _financeKey, child: _buildFinanceDetailsTab(data)),
                  ],
                ),
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
        // boxShadow: const [
        //   BoxShadow(
        //     color: Color.fromRGBO(133, 133, 133, 0.25),
        //     blurRadius: 10,
        //     spreadRadius: 0,
        //     offset: Offset(0, 0),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1, -0.2),
                    end: Alignment(1, 0.2),
                    colors: [
                      Color(0xFF007EAB),
                      Color(0xFF5CC1E5),
                    ],
                  ),
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(8),
                  //   topRight: Radius.circular(8),
                  // ),
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
                                      : const AssetImage('assets/images/drawer/profile_pic.png')) as ImageProvider;
                              FullImageViewer.show(context, imageProvider: provider, heroTag: 'profile_pic');
                            },
                            child: Hero(
                              tag: 'profile_pic',
                              child: SizedBox(
                                height: 56,
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundColor: AppColors.white1,
                                  backgroundImage: imageFile != null
                                      ? FileImage(imageFile)
                                      : (profilePicUrl != null && profilePicUrl.isNotEmpty
                                      ? NetworkImage(profilePicUrl.startsWith('http') ? profilePicUrl : "${AppUrls.baseUrl}$profilePicUrl")
                                          : const AssetImage('assets/images/drawer/profile_pic.png')) as ImageProvider,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustText(
                            name: '${data?.firstName.toTitleCase() ?? ""} ${data?.lastName.toTitleCase() ?? ""}',
                            size: 1.8,
                            color: AppColors.white1,
                            fontWeightName: FontWeight.w600,
                          ),
                          CustText(
                            name: (data?.designation?.name ?? 'Station Controller').toTitleCase(),
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
                  child: Image.asset("assets/images/profile_BG.png",height: ResponsiveHelper.height(context, 80),))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildHeaderRow('Emp No :', data?.userDetails?.employeeID ?? data?.uniqueCode ?? 'N/A'),
                const SizedBox(height: 4),
                _buildHeaderRow('Department :', data?.departments?.isNotEmpty == true ? data!.departments!.map((e) => e.name.toTitleCase()).join(", ") : 'NA'),
                const SizedBox(height: 4),
                _buildHeaderRow(
                  'Allocated Stations :',
                  data?.stations?.isNotEmpty == true ? data!.stations!.map((e) => e.name.toTitleCase()).join(", ") : 'N/A',
                ),
                const SizedBox(height: 4),
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
          child: CustText(
            name: label,
            size: 1.5,
            color: AppColors.textColor5,
            fontWeightName: FontWeight.w400,
          ),
        ),
        Expanded(
          flex: 3,
          child: CustText(
            name: value,
            size: 1.6,
            color: AppColors.textColor5,
            fontWeightName: FontWeight.w600,
          ),
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
        controller: _tabController,
        labelColor: AppColors.blue,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        unselectedLabelColor: AppColors.textColor4,
        indicatorColor: AppColors.blue,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 16),
        unselectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w400, fontSize: 16),
        onTap: (index) => _scrollToSection(index),
        tabs: const [
          Tab(text: 'Personal Details'),
          Tab(text: 'Employment Details'),
          Tab(text: 'Finance Details'),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsTab(UserProfileData? data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccordionCard(
            title: 'Personal Details',
            isExpanded: true,
            expanded: _isPersonalExpanded,
            onTap: () => setState(() => _isPersonalExpanded = !_isPersonalExpanded),
            child: Column(
              children: [
                _detailRow('Name', '${data?.firstName.toTitleCase() ?? ""} ${data?.lastName.toTitleCase() ?? ""}', 'Date of Birth', data?.userDetails?.dateOfBirth ?? 'N/A'),
                const SizedBox(height: 16),
                _detailRow('Gender', data?.userDetails?.gender?.toTitleCase() ?? 'N/A', 'Birth Place', data?.userDetails?.birthPlace?.toTitleCase() ?? 'N/A'),
                const SizedBox(height: 16),
                _detailRow('Contact Number', data?.contactNo ?? 'N/A', 'Alternate Contact Number', data?.userDetails?.alternateContactNo ?? 'N/A'),
                const SizedBox(height: 16),
                _detailRow('Pan Card', data?.userDetails?.panCardNo?.toUpperCase() ?? 'N/A', 'Aadhar Card', data?.userDetails?.aadharCardNo ?? 'N/A'),
                const SizedBox(height: 16),
                _detailRow('Blood Group', data?.userDetails?.bloodGroup ?? 'N/A', 'Shift Type', data?.userDetails?.shiftType?.toTitleCase() ?? 'N/A'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AccordionCard(
            title: 'Permanent Address',
            isExpanded: true,
            expanded: _isPermanentAddressExpanded,
            onTap: () => setState(() => _isPermanentAddressExpanded = !_isPermanentAddressExpanded),
            child: _buildAddressDetails(data?.userDetails?.permanentAddress),
          ),
          const SizedBox(height: 16),
          AccordionCard(
            title: 'Current Address',
            isExpanded: true,
            expanded: _isCurrentAddressExpanded,
            onTap: () => setState(() => _isCurrentAddressExpanded = !_isCurrentAddressExpanded),
            child: _buildAddressDetails(data?.userDetails?.currentAddress),
          ),
        ],
      ),
    );
  }



  Widget _buildAddressDetails(String? addressStr) {
    if (addressStr == null || addressStr.isEmpty || addressStr == 'N/A') {
      return Text('N/A', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textColor));
    }
    
    List<String> parts = addressStr.split('|');
    if (parts.length == 6) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailRow('Residency / House No.', parts[0].isEmpty ? 'N/A' : parts[0], 'Locality / Town / Village', parts[1].isEmpty ? 'N/A' : parts[1]),
          const SizedBox(height: 16),
          _detailRow('Pincode', parts[2].isEmpty ? 'N/A' : parts[2], 'City', parts[3].isEmpty ? 'N/A' : parts[3]),
          const SizedBox(height: 16),
          _detailRow('State', parts[4].isEmpty ? 'N/A' : parts[4], 'Country', parts[5].isEmpty ? 'N/A' : parts[5]),
        ],
      );
    }

    // Fallback display
    return Text(
      addressStr.toTitleCase(),
      style: GoogleFonts.outfit(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.textColor,
      ),
    );
  }

  Widget _buildEmploymentDetailsTab(UserProfileData? data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AccordionCard(
        title: 'Employment Details',
        isExpanded: true,
        expanded: _isEmploymentExpanded,
        onTap: () => setState(() => _isEmploymentExpanded = !_isEmploymentExpanded),
        child: Column(
          children: [
            _detailRow('Date of Joining', data?.userDetails?.dateOfJoining ?? 'N/A', 'City', data?.cities?.isNotEmpty == true ? data!.cities!.first.name : 'N/A'),
            const SizedBox(height: 16),
            _detailRow('Department', data?.departments?.isNotEmpty == true ? data!.departments!.first.name : 'N/A', 'Station', data?.stations?.isNotEmpty == true ? data!.stations!.first.name : 'N/A'),
            const SizedBox(height: 16),
            _detailRow('Role', data?.role?.name ?? 'N/A', 'Designation', data?.designation?.name ?? 'N/A'),
            const SizedBox(height: 16),
            _detailRow('Duty Shift', data?.userDetails?.shiftType?.toTitleCase() ?? 'N/A', '', ''),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceDetailsTab(UserProfileData? data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AccordionCard(
        title: 'Finance Details',
        isExpanded: true,
        expanded: _isFinanceExpanded,
        onTap: () => setState(() => _isFinanceExpanded = !_isFinanceExpanded),
        child: Column(
          children: [
            _detailRow('Bank Name', 'N/A', 'Account Number', 'N/A'),
            const SizedBox(height: 16),
            _detailRow('IFSC Code', 'N/A', 'Branch Name', 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String leftLabel, String leftValue, String rightLabel, String rightValue) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _detailItem(leftLabel, leftValue)),
        const SizedBox(width: 16),
        if (rightLabel.isNotEmpty)
          Expanded(child: _detailItem(rightLabel, rightValue))
        else
          const Spacer(),
      ],
    );
  }

  Widget _detailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustText(
          name: label,
          size: 1.4,
          color: AppColors.textColor.withOpacity(0.5),
          fontWeightName: FontWeight.w400,
        ),
        const SizedBox(height: 4),
        CustText(
          name: value,
          size: 1.5,
          color: AppColors.textColor,
          fontWeightName: FontWeight.w600,
        ),
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
