import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/rendering.dart';

import '../../../constants/app_constants.dart';
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
import 'package:om_appcart/utils/network_utils.dart';
import 'package:om_appcart/view/widgets/custom_dialog.dart';
import '../../../utils/string_utils.dart';
import '../../../utils/responsive_helper.dart';
import 'package:om_appcart/constants/strings.dart';
import 'package:om_appcart/view/widgets/custom_confirmation_dialog.dart';

class LostAndFoundListScreen extends GetView<LostAndFoundListController> {
  const LostAndFoundListScreen({Key? key}) : super(key: key);

  Color _getStatusColor(bool isActive) {
    return isActive ? AppColors.barColor4 : AppColors.grey;
  }

  String _getMatchStatusText(int status) {
    switch (status) {
      case 1: return AppStrings.statusOpen;
      case 2: return AppStrings.statusUnmatched;
      case 3: return AppStrings.statusMatched;
      case 4: return AppStrings.statusVerified;
      case 5: return AppStrings.statusClosed;
      default: return AppStrings.statusUnknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    if (!Get.isRegistered<LostAndFoundListController>()) {
      Get.put(LostAndFoundListController());
    }

    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.lostAndFoundList,
        showDrawer: false,
        isForm: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return ListView.builder(
            padding: EdgeInsets.all(ResponsiveHelper.spacing(context, AppConstants.screenPadding)),
            itemCount: 5,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(bottom: ResponsiveHelper.spacing(context, 12)),
              child: SkeletonLoader.card(height: ResponsiveHelper.height(context, 120)),
            ),
          );
        }

        if (controller.errorMessage.isNotEmpty && controller.lostFoundItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_off, size: ResponsiveHelper.width(context, 64), color: AppColors.grey),
                SizedBox(height: ResponsiveHelper.spacing(context, 16)),
                Text(controller.errorMessage.value, 
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: ResponsiveHelper.width(context, 16), fontWeight: FontWeight.bold)),
                SizedBox(height: ResponsiveHelper.spacing(context, 10)),
                ElevatedButton(
                  onPressed: controller.refreshItems,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.spacing(context, 24), 
                      vertical: ResponsiveHelper.spacing(context, 12)
                    ),
                  ),
                  child: const Text(AppStrings.retry),
                ),
              ],
            ),
          );
        }

        if (controller.lostFoundItems.isEmpty) {
          return const Center(child: Text(AppStrings.noRecordsFound));
        }

        return Column(
          children: [
            if (controller.isOfflineMode.value)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.spacing(context, 8)),
                color: AppColors.orange.withOpacity(0.9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, color: Colors.white, size: ResponsiveHelper.width(context, 16)),
                    SizedBox(width: ResponsiveHelper.width(context, 8)),
                    Text(
                      AppStrings.offlineModeCached,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: ResponsiveHelper.width(context, 12)),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => controller.refreshItems(),
                child: ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.spacing(context, AppConstants.horizontalPadding), 
                    vertical: ResponsiveHelper.spacing(context, AppConstants.verticalPadding)
                  ),
                  itemCount: controller.lostFoundItems.length + (controller.hasMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.lostFoundItems.length) {
                      return controller.hasMore.value
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.spacing(context, 20)),
                              child: const CustLoader(),
                            )
                          : const SizedBox.shrink();
                    }

                    final data = controller.lostFoundItems[index];
                    return Dismissible(
                      key: ValueKey(data.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: EdgeInsets.only(bottom: ResponsiveHelper.spacing(context, 12)),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.spacing(context, 20)),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        bool isOnline = await NetworkUtils.checkConnectivity();
                        if (!isOnline) {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => CustomDialog(
                                AppStrings.needInternetToDelete,
                                onOk: () => Navigator.pop(context),
                              ),
                            );
                          }
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
                        statusText: data.isActive ? AppStrings.statusActive : AppStrings.statusInActive,
                        statusColor: _getStatusColor(data.isActive),
                        leftBarColor: _getStatusColor(data.isActive),
                        subtitleTags: [
                          TagData(
                            text: data.registerAs.toTitle(),
                            backgroundColor: AppColors.blue.withOpacity(0.05),
                            textColor: AppColors.textColor,
                          ),
                        ],
                        detailColumns: [
                          DetailColumn(label: AppStrings.station, value: data.stations?.name?.toTitle() ?? AppStrings.notAvailable),
                          DetailColumn(label: AppStrings.matchStatus, value: _getMatchStatusText(data.matchStatus)),
                          DetailColumn(
                            label: AppStrings.date,
                            value: data.date != null ? AppDateUtils.formatDate(data.date!) : AppStrings.notAvailable,
                          ),
                        ],
                        onTap: () => Get.to(
                          () => LostAndFoundDetailScreen(record: data),
                          arguments: {'uniqueCode': data.uniqueCode, 'record': data}
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(() => CustFab(
        label: AppStrings.addRequest,
        icon: Icons.add,
        isExtended: controller.isFabExtended.value,
        onPressed: () => Get.to(() => const LostAndFoundScreen(), arguments: {'mode': 'add'}),
      )),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    bool confirm = false;
    await CustomConfirmationDialog.show(
      title: AppStrings.confirmDelete,
      message: AppStrings.confirmDeleteMessage,
      confirmText: AppStrings.delete,
      confirmColor: Colors.red,
      icon: Icons.delete_forever,
      onConfirm: () => confirm = true,
      onCancel: () => confirm = false,
    );
    return confirm;
  }
}
