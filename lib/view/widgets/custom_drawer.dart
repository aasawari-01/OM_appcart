import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../../feature/lost&found/view/lost_and_found_list_screen.dart';
import '../../feature/user_profile/view/profile_view.dart';
import '../../utils/responsive_helper.dart';
import '../screens/home_screen.dart';
import '../screens/assets_list_screen.dart';
import '../screens/assurance_register_list_screen.dart';
import '../screens/axle_counter_reset_list_screen.dart';
import '../screens/cash_check_details_register_list_screen.dart';
import '../screens/complaint_feedback_list_screen.dart';
import '../screens/deep_cleaning_list_screen.dart';
import '../screens/divyang_list_screen.dart';
import '../screens/failure_list_screen.dart';
import '../screens/first_aid_register_list_screen.dart';
import '../screens/gate_pass_detail_list.dart';
import '../screens/inspection_list_screen.dart';
import '../../feature/auth_login/view/login_view.dart';
import '../screens/manual_ticket_details_list_screen.dart';
import '../screens/penalty_details_list_screen.dart';
import '../screens/private_number_book_list_screen.dart';
import '../screens/service_deficiency_register_form.dart';
import '../screens/shift_abstract_register_list_screen.dart';
import '../screens/station_diary_screen.dart';
import '../screens/station_failure_list_screen.dart';
import '../screens/station_instruction_register_list_screen.dart';
import '../screens/tom_shift_login_list_screen.dart';
import '../../service/quick_actions_controller.dart';
import 'package:om_appcart/service/auth_manager.dart';
import 'cust_text.dart';
import '../screens/settings.dart';
import '../../feature/user_profile/controller/user_profile_controller.dart';
import '../../service/network_service/app_urls.dart';
import '../../utils/string_utils.dart';
import 'package:om_appcart/view/widgets/full_image_viewer.dart';
import 'package:om_appcart/view/widgets/custom_confirmation_dialog.dart';

class CustomDrawer extends StatefulWidget {
  final String? selectedMenu;
  const CustomDrawer({Key? key, this.selectedMenu}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class MenuItem {
  final String title;
  final String key;
  final String? iconPath;
  final Widget? screen;
  final List<MenuItem>? children;
  final bool isSubSection;

  MenuItem({
    required this.title,
    required this.key,
    this.iconPath,
    this.screen,
    this.children,
    this.isSubSection = false,
  });
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? _selectedMenu;
  String? _expandedSectionKey;
  String? _expandedSubSectionKey;
  Set<String> _openSections = {};
  Set<String> _openSubSections = {};
  
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  late List<MenuItem> _menuItems;

  @override
  void initState() {
    super.initState();
    _selectedMenu = widget.selectedMenu;
    _expandedSectionKey = null;
    _expandedSubSectionKey = null;
    _openSections.clear();
    _openSubSections.clear();
    _initializeMenuItems();
  }

  void _initializeMenuItems() {
    _menuItems = [
      MenuItem(
        title: 'Failure',
        key: 'failure',
        iconPath: 'assets/images/drawer/failure.png',
        children: [
          MenuItem(title: 'Station Failure', key: 'station_failure', screen: StationFailureListScreen()),
        ],
      ),
      MenuItem(
        title: 'Maintenance',
        key: 'maintenance',
        iconPath: 'assets/images/drawer/maintainance.png',
        children: [
          MenuItem(title: 'Inspection', key: 'inspection', screen: const InspectionListScreen()),
          // MenuItem(title: 'Report', key: 'report', screen: null),
          MenuItem(title: 'Failure List',key: 'failure_list', screen: FailureListScreen()),
        ],
      ),
      MenuItem(
        title: 'Operations',
        key: 'operations',
        iconPath: 'assets/images/drawer/operation.png',
        children: [
          MenuItem(
            title: 'Station Operations',
            key: 'station_operation',
            isSubSection: true,
            children: [
              MenuItem(title: 'Asset Register', key: 'asset_register', screen: const AssetsListScreen()),
              MenuItem(title: 'Assurance Register', key: 'assurance_register', screen: const AssuranceRegisterListScreen()),
              MenuItem(title: 'Axle Counter Reset Register', key: 'axle_counter_reset', screen: const AxleCounterResetListScreen()),
              MenuItem(title: 'Cash Check Details Register', key: 'cash_check_details', screen: const CashCheckDetailsRegisterListScreen()),
              MenuItem(title: 'Deep Cleaning Register', key: 'deep_cleaning', screen: const DeepCleaningListScreen()),
              MenuItem(title: 'Divyang List', key: 'divyang_list', screen: const DivyangListScreen()),
              MenuItem(title: 'First Aid', key: 'first_aid', screen: const FirstAidRegisterListScreen()),
              MenuItem(title: 'Gate Pass Details', key: 'gate_pass_details', screen: const GatePassDetailsList()),
              MenuItem(title: 'Manual Ticket Details', key: 'manual_ticket_details', screen: const ManualTicketDetailsListScreen()),
              MenuItem(title: 'Penalty Details', key: 'penalty_details', screen: const PenaltyDetailsListScreen()),
              MenuItem(title: 'Private Number Book', key: 'private_number_book', screen: const PrivateNumberBookListScreen()),
              MenuItem(title: 'Service Deficiency Register Form', key: 'service_deficiency_register_form', screen: const ServiceDeficiencyRegisterForm()),
              MenuItem(title: 'Shift Abstract Register Inbox', key: 'shift_abstract_inbox', screen: const ShiftAbstractRegisterListScreen()),
              MenuItem(title: 'Station Diary', key: 'station_diary', screen: StationDiaryScreen()),
              MenuItem(title: 'Station Failure', key: 'station_failure', screen: StationFailureListScreen()),
              MenuItem(title: 'Station Instruction Register', key: 'station_instruction', screen: const StationInstructionRegisterListScreen()),
              MenuItem(title: 'TOM Shift Login', key: 'tom_shift_login', screen: const TomShiftLoginListScreen()),
            ],
          ),
          MenuItem(
            title: 'CRM',
            key: 'crm_subsection',
            isSubSection: true,
            children: [
              MenuItem(title: 'Complaint & Feedback Register', key: 'crm_complaint_feedback', screen: ComplaintFeedbackListScreen()),
              MenuItem(title: 'Lost And Found', key: 'lost&found', screen: LostAndFoundListScreen()),
            ],
          ),
        ],
      ),

      MenuItem(
        title: 'Settings',
        key: 'settings',
        iconPath: 'assets/images/drawer/setting.png',
        screen:  Settings(),
        children: []
      ),
      // MenuItem(
      //   title: 'Log Out',
      //   key: 'logout',
      //   iconPath: 'assets/images/drawer/logout.png',
      //   screen: LoginView(),
      //   children: []
      // ),
    ];
  }

  void _handleSectionExpansion(String sectionKey, bool isSubSection) {
    if (_searchText.isNotEmpty) return; 

    setState(() {
      if (isSubSection) {
        if (_expandedSubSectionKey == sectionKey) {
          _expandedSubSectionKey = null;
          _openSubSections.remove(sectionKey);
        } else {
          _expandedSubSectionKey = sectionKey;
          _openSubSections.clear();
          _openSubSections.add(sectionKey);
        }
      } else {
        if (_expandedSectionKey == sectionKey) {
          _expandedSectionKey = null;
          _openSections.remove(sectionKey);
        } else {
          _expandedSectionKey = sectionKey;
          _openSections.clear();
          _openSections.add(sectionKey);
        }
      }
    });
  }

  void _onMenuTap(String menu, Widget screen) {
    setState(() {
      _selectedMenu = menu;
    });
    Future.delayed(const Duration(milliseconds: 120), () {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    });
  }
  
  List<MenuItem> _filterItems(List<MenuItem> items, String query) {
    List<MenuItem> filtered = [];
    for (var item in items) {
      if (item.children != null) {
        var matchingChildren = _filterItems(item.children!, query);
        if (item.title.toLowerCase().contains(query.toLowerCase()) || matchingChildren.isNotEmpty) {
           filtered.add(MenuItem(
             title: item.title,
             key: item.key,
             iconPath: item.iconPath,
             children: matchingChildren.isEmpty && item.title.toLowerCase().contains(query.toLowerCase()) 
                 ? item.children
                 : matchingChildren,
             isSubSection: item.isSubSection,
             screen: item.screen
           ));
        }
      } else {
        // Leaf node
        if (item.title.toLowerCase().contains(query.toLowerCase())) {
          filtered.add(item);
        }
      }
    }
    return filtered;
  }
  
  List<MenuItem> _filterItemsIncludingChildren(List<MenuItem> items, String query) {
    if (query.isEmpty) return items;
    
    List<MenuItem> result = [];
    for (var item in items) {
      bool selfMatch = item.title.toLowerCase().contains(query.toLowerCase());
      if (selfMatch) {
         result.add(item);
      } else if (item.children != null) {
         var filteredChildren = _filterItemsIncludingChildren(item.children!, query);
         if (filteredChildren.isNotEmpty) {
             result.add(MenuItem(
               title: item.title,
               key: item.key,
               screen: item.screen,
               iconPath: item.iconPath,
               isSubSection: item.isSubSection,
               children: filteredChildren
             ));
         }
      }
    }
    return result;
  }

  List<Widget> _buildMenuWidgets(List<MenuItem> items) {
    return items.map((item) {
      if (item.children != null) {
        return _drawerSection(
          sectionKey: item.key,
          title: item.title,
          iconPath: item.iconPath,
          children: _buildMenuWidgets(item.children!),
          isSubSection: item.isSubSection,
          screen: item.screen
        );
      } else {
        return _drawerItem(item.title, item.key, item.screen, item.iconPath);
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayItems = _filterItemsIncludingChildren(_menuItems, _searchText);

    return Drawer(
      width: ResponsiveHelper.isTablet(context) ? 320 : 280,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 16, right: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(image:  AssetImage("assets/images/drawer/drawer_background.png"))
            ),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() {
                    final userController = Get.find<UserProfileController>();
                    final user = userController.profileData.value;
                    final profilePicUrl = user?.profilePic;
                    
                    ImageProvider profileImage;
                    if (profilePicUrl != null && profilePicUrl.isNotEmpty) {
                      profileImage = NetworkImage(profilePicUrl.startsWith('http') ? profilePicUrl : "${AppUrls.baseUrl}$profilePicUrl");
                    } else {
                      profileImage = const AssetImage('assets/images/drawer/profile_pic.png');
                    }

                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () => FullImageViewer.show(context, imageProvider: profileImage, heroTag: 'profile_pic_drawer'),
                          child: Hero(
                            tag: 'profile_pic_drawer',
                            child: CircleAvatar(
                              radius: 28,
                              backgroundImage: profileImage,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustText(
                                name: "${(user?.firstName ?? 'User').capitalizeFirstLetter()} ${user?.lastName ?? ''}".trim(),
                                size: 1.8,
                                fontWeightName: FontWeight.w700,
                                color: AppColors.textColor,
                              ),
                              CustText(
                                name: user?.role?.name ?? 'Loading...',
                                size: 1.5,
                                color: AppColors.textColor.withOpacity(0.6),
                                fontWeightName: FontWeight.w400,
                              ),
                              InkWell(
                                onTap: () {
                                   Navigator.pop(context); // Close drawer
                                   Get.to(() => const ProfileView());
                                },
                                child: CustText(
                                  name: 'View Profile',
                                  size: 1.5,
                                  color: AppColors.blue,
                                  fontWeightName: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                GestureDetector(
                    onTap: () async {
                      await CustomConfirmationDialog.show(
                        title: 'Confirm Logout',
                        message: 'Are you sure you want to log out?',
                        confirmText: 'Logout',
                        confirmColor: AppColors.red,
                        icon: TablerIcons.logout,
                        onConfirm: () async {
                          // Clear profile data on logout
                          if (Get.isRegistered<UserProfileController>()) {
                            Get.find<UserProfileController>().clearProfile();
                          }
                          await AuthManager().logout();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginView()),
                              (route) => false,
                            );
                          }
                        },
                      );
                    },
                    child: Image.asset("assets/images/drawer/logout.png", color: AppColors.red, height: ResponsiveHelper.height(context, 28)))
              ],
            ),
          ),
          // Search Bar
      Container(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        color: AppColors.white1,
        child: TextField(
          controller: _searchController,
          style: GoogleFonts.outfit(
            color: AppColors.textColor,
            fontSize: 12,
          ),
          onChanged: (val) {
            setState(() {
              _searchText = val;
            });
          },
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: GoogleFonts.outfit(
              color: AppColors.textColor.withOpacity(0.5),
              fontSize: 12,
            ),

            prefixIcon: Icon(
              Icons.search,
              color: AppColors.textColor,
              size: 18,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 36,
              minHeight: 36,
            ),

            // ✅ CLEAR ICON
            suffixIcon: _searchText.isNotEmpty
                ? GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() {
                  _searchText = '';
                });
              },
              child: Icon(
                Icons.close,
                size: 18,
                color: AppColors.textColor.withOpacity(0.6),
              ),
            )
                : null,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 36,
              minHeight: 36,
            ),

            filled: true,
            fillColor: const Color(0xFFF7F7F7),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 12,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.black),
            ),
          ),
        ),
      ),
      Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: _buildMenuWidgets(displayItems),
            ),
          ),
          Padding(
            padding:EdgeInsets.only(bottom: 16,left: 16,right: 16),
            child: CustText(
              name: 'Version 1.0.0',
              size: 1.2,
              color: AppColors.textColor.withOpacity(0.5),
              fontWeightName: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerSection({
    required String sectionKey,
    required String title,
    String? iconPath,
    required List<Widget> children,
    Widget? screen,
    bool isSubSection = false,
  }) {
    // Auto-expand if searching and this section has content (which it does if it was returned by filter)
    bool shouldExpand = _searchText.isNotEmpty || 
      (isSubSection ? _openSubSections.contains(sectionKey) : _openSections.contains(sectionKey));

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Column(
        children: [
          const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5),),
          ExpansionTile(
            key: Key(sectionKey + (_searchText.isNotEmpty ? '_search' : '')),
            tilePadding: EdgeInsets.only(left: isSubSection ? 48 : 24, right: 16, top: 0, bottom: 0),
            leading: (iconPath != null && !isSubSection)
              ? Image.asset(iconPath, width: 24, height: 24)
              : null,
            title: CustText(
              name: title,
              size: isSubSection ? 1.6 : 1.6,
              color: AppColors.textColor,
              fontWeightName: isSubSection ? FontWeight.w500 : FontWeight.w600,
            ),
            trailing: children.isEmpty
                ? const SizedBox.shrink()
                : null,
            initiallyExpanded: shouldExpand,
            shape: const Border(), // Remove border when expanded
            collapsedShape: const Border(), // Remove border when collapsed
            onExpansionChanged: (expanded) {
              print("tapped");
              if(children.isEmpty){
                print("tapped");
                _onMenuTap(sectionKey!, screen!);
              }else {
                if (_searchText.isNotEmpty)
                  return; // Ignore collapse/expand during search interaction for simplicity

                if (expanded) {
                  _handleSectionExpansion(sectionKey, isSubSection);
                } else {
                  setState(() {
                    if (isSubSection) {
                      _expandedSubSectionKey = null;
                      _openSubSections.remove(sectionKey);
                    } else {
                      _expandedSectionKey = null;
                      _openSections.remove(sectionKey);
                    }
                  });
                }
              }
            },
            children: children,
            iconColor: AppColors.textColor,
            collapsedIconColor: AppColors.textColor,
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(String name, String key, Widget? screen, String? iconPath) {
    return Column(
      children: [
        if(iconPath!=null)
        const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
        ListTile(
          tileColor: iconPath == null?AppColors.subMenuColor: AppColors.white1,
          contentPadding: EdgeInsets.only(left: iconPath != null ? 24 : 48, right: 16),
          dense: true, // Reduce vertical padding
          visualDensity: VisualDensity.compact, // Further reduce height
          leading: iconPath != null 
              ? Image.asset(iconPath, width: 24, height: 24)
              : null,
          title: CustText(
            name: name,
            size: 1.5,
            color: _selectedMenu == key ? AppColors.blue : AppColors.textColor.withOpacity(0.8), // Highlight selected
            fontWeightName: _selectedMenu == key ? FontWeight.w600 : FontWeight.w400,
          ),
          onTap: () {
            if (key == 'logout') {
               AuthManager().logout().then((_) {
                 if (context.mounted) {
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginView()));
                 }
               });
               return;
            }

            if(screen==null){
              // Just close drawer if no screen (e.g. placeholder)
              Navigator.pop(context);
            }else {
              _onMenuTap(key, screen!);
            }
            },
          onLongPress: screen == null ? null : () => _showPinMenu(name, key, screen!),
          selected: _selectedMenu == key,
          selectedTileColor: AppColors.blue.withOpacity(0.05), // Light blue background for selected
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
      ],
    );
  }

  void _showPinMenu(String title, String key, Widget screen) {
    final ctrl = Get.find<QuickActionsController>();
    final isPinned = ctrl.selectedActionIds.contains(key);

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return ListTile(
          leading: Icon(
            isPinned ? Icons.push_pin_outlined : Icons.push_pin,
            color: AppColors.textColor,
          ),
          title: Text(
            isPinned ? 'Unpin from Quick Actions' : 'Pin to Quick Actions',
            style: TextStyle(color: AppColors.textColor),
          ),
          onTap: () async {
            Navigator.pop(ctx);
            await ctrl.pinOrUnpinMenuItem(
              id: key,
              label: title,
              icon: Icons.circle, // you can customize per menu later
              screenBuilder: () => screen,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isPinned
                      ? 'Removed from quick actions'
                      : 'Added to quick actions',
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        );
      },
    );
  }
}