import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import '../../../utils/app_date_utils.dart';
import 'package:om_appcart/constants/colors.dart';
import '../../../view/widgets/cust_fab.dart';
import '../../../view/widgets/cust_loader.dart';
import '../controller/lost_and_found_list_controller.dart';
import '../../../view/widgets/custom_app_bar.dart';
import '../../../view/widgets/list_item_card_type1.dart';
import 'lost_and_found_screen.dart';
import 'lost_and_found_detail_screen.dart';
import '../../../view/widgets/cust_text.dart';
import '../../../view/widgets/skeleton_loader.dart';
import 'package:flutter/rendering.dart';
import 'package:om_appcart/utils/network_utils.dart';
import 'package:om_appcart/view/widgets/custom_dialog.dart';
import '../../../utils/string_utils.dart';
import 'package:om_appcart/view/widgets/custom_confirmation_dialog.dart';

class LostAndFoundListScreen extends StatefulWidget {
  const LostAndFoundListScreen({Key? key}) : super(key: key);

  @override
  State<LostAndFoundListScreen> createState() => _LostAndFoundListScreenState();
}

class _LostAndFoundListScreenState extends State<LostAndFoundListScreen> {
  final LostAndFoundListController controller = Get.put(LostAndFoundListController());
  final ScrollController _scrollController = ScrollController();
  bool _isFabExtended = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      controller.loadMoreItems();
    }
  }

  Color _getStatusColor(bool isActive) {
    return isActive ? AppColors.barColor4 : AppColors.grey;
  }

  String _getMatchStatusText(int status) {
    switch (status) {
      case 1:
        return 'Open';
      case 2:
        return 'Unmatched';
      case 3:
        return 'Matched';
      case 4:
        return 'Verified';
      case 5:
        return 'Closed';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Lost & Found List',
        showDrawer: false,
        isForm: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 5,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SkeletonLoader.card(height: 120),
            ),
          );
        }

        if (controller.errorMessage.isNotEmpty && controller.lostFoundItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off, size: 64, color: AppColors.grey),
                const SizedBox(height: 16),
                const Text('Something went wrong', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: controller.refreshItems,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.lostFoundItems.isEmpty) {
          return const Center(child: Text('No records found'));
        }

        return Column(
          children: [
            Obx(() => controller.isOfflineMode.value
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    color: AppColors.orange.withOpacity(0.9),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off, color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Offline Mode - Showing Cached Data',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink()),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => controller.refreshItems(),
                child: NotificationListener<UserScrollNotification>(
                  onNotification: (notification) {
                    if (notification.direction == ScrollDirection.forward) {
                      if (!_isFabExtended) setState(() => _isFabExtended = true);
                    } else if (notification.direction == ScrollDirection.reverse) {
                      if (_isFabExtended) setState(() => _isFabExtended = false);
                    }
                    return true;
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    itemCount: controller.lostFoundItems.length + (controller.hasMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.lostFoundItems.length) {
                        return controller.hasMore.value
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: CustLoader(),
                              )
                            : const SizedBox.shrink();
                      }

                      final data = controller.lostFoundItems[index];
                      return Dismissible(
                        key: ValueKey(data.id),
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
                        confirmDismiss: (direction) async {
                          // Check connectivity before delete
                          bool isOnline = await NetworkUtils.checkConnectivity();
                          if (!isOnline) {
                            if (!mounted) return false;
                            showDialog(
                              context: context,
                              builder: (context) => CustomDialog(
                                'You need an active internet connection to delete records.',
                                onOk: () => Navigator.pop(context),
                              ),
                            );
                            return false;
                          }
                          return await _showDeleteConfirmation(context);
                        },
                        onDismissed: (direction) async {
                          HapticFeedback.mediumImpact();
                          final success = await controller.deleteItem(data.id);
                          if (!success) {
                            controller.refreshItems();
                          }
                        },

                        child: ListItemCardType1(
                          title: data.docNumber,
                          statusText: data.isActive ? 'Active' : 'In-Active',
                          statusColor: _getStatusColor(data.isActive),
                          leftBarColor: _getStatusColor(data.isActive),
                          subtitleTags: [
                            TagData(
                              text: data.registerAs.toTitleCase(),
                              backgroundColor: AppColors.blue.withOpacity(0.05),
                              textColor: AppColors.textColor,
                            ),
                          ],
                          detailColumns: [
                            DetailColumn(label: 'Station', value: data.stations?.name?.toTitleCase() ?? 'N/A'),
                            DetailColumn(label: 'Match Status', value: _getMatchStatusText(data.matchStatus)),
                            DetailColumn(
                              label: 'Date',
                              value: data.date != null ? AppDateUtils.formatDate(data.date!) : 'N/A',
                            ),
                          ],
                          onTap: () {
                            controller.toggleExpansion(data.id);
                          },
                          footer: Obx(() {
                            final isExpanded = controller.expandedItemId.value == data.id;
                            return AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              alignment: Alignment.topCenter,
                              child: Container(
                                constraints: isExpanded ? const BoxConstraints() : const BoxConstraints(maxHeight: 0),
                                clipBehavior: Clip.hardEdge,
                                decoration: const BoxDecoration(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      _buildActionButton(
                                        context: context,
                                        label: 'View',
                                        icon: Icons.visibility_outlined,
                                        color: AppColors.blue,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LostAndFoundDetailScreen(
                                                record: data,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 12),
                                      _buildActionButton(
                                        context: context,
                                        label: 'Edit',
                                        icon: Icons.edit_outlined,
                                        color: AppColors.orange,
                                        onTap: () async {
                                          // Check connectivity before edit
                                          bool isOnline = await NetworkUtils.checkConnectivity();
                                          if (!isOnline) {
                                            if (!mounted) return;
                                            showDialog(
                                              context: context,
                                              builder: (context) => CustomDialog(
                                                'You need an active internet connection to edit records.',
                                                onOk: () => Navigator.pop(context),
                                              ),
                                            );
                                            return;
                                          }
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LostAndFoundScreen(
                                                mode: 'edit',
                                                record: data,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustFab(
        label: 'Add Request',
        icon: Icons.add,
        isExtended: _isFabExtended,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LostAndFoundScreen()),
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(4),
          color: color.withOpacity(0.05),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            CustText(
              name: label,
              size: 1.2,
              color: color,
              fontWeightName: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    bool confirm = false;
    await CustomConfirmationDialog.show(
      title: 'Confirm Delete',
      message: 'Are you sure you want to delete this record? This action cannot be undone.',
      confirmText: 'Delete',
      confirmColor: Colors.red,
      icon: Icons.delete_forever,
      onConfirm: () => confirm = true,
      onCancel: () => confirm = false,
    );
    return confirm;
  }
}
