import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/constants/app_constants.dart';
import '../../../constants/strings.dart';
import '../../../utils/responsive_helper.dart';
import '../../../view/widgets/accordion_card.dart';
import '../../../view/widgets/cust_button.dart';
import '../../../view/widgets/cust_text.dart';
import '../../../view/widgets/custom_app_bar.dart';
import '../../../view/widgets/skeleton_loader.dart';
import 'widgets/matched_item_card.dart';
import 'widgets/detail_history_section.dart';

import '../../../utils/app_date_utils.dart';
import 'package:get/get.dart';
import '../model/lost_found_table_record.dart';
import '../controller/lost_and_found_detail_controller.dart';
import '../../../utils/string_utils.dart';
import 'package:om_appcart/view/widgets/full_image_viewer.dart';
import 'package:om_appcart/utils/network_utils.dart';
import 'package:om_appcart/view/widgets/custom_dialog.dart';
import 'lost_and_found_screen.dart';

class LostAndFoundDetailScreen extends GetView<LostAndFoundDetailController> {
  final LostFoundTableRecord? record; // Optional if navigated by code
  
  const LostAndFoundDetailScreen({
    Key? key,
    this.record,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<LostAndFoundDetailController>()) {
      Get.put(LostAndFoundDetailController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppStrings.lostAndFoundDetails,
        showDrawer: false,
        isForm: true,
        onLeadingPressed: () => Get.back(),
        actions: [
          IconButton(
            icon: const Icon(TablerIcons.edit, color: AppColors.white1),
            onPressed: () async {
              final currentRecord = controller.record.value;
              if (currentRecord == null) return;
              
              bool isOnline = await NetworkUtils.checkConnectivity();
              if (!isOnline) {
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      AppStrings.needInternetToEdit,
                      onOk: () => Navigator.pop(context),
                    ),
                  );
                }
                return;
              }
              Get.to(
                () => const LostAndFoundScreen(),
                arguments: {'mode': 'edit', 'record': currentRecord}
              );
            },
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.record.value == null) {
          return _buildSkeletonLoader();
        }

        final record = controller.record.value;
        if (record == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(AppStrings.failedToLoadDetails),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: controller.fetchDetail,
                  child: const Text(AppStrings.retry),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.isLoading.value)
                const LinearProgressIndicator(
                  minHeight: 2,
                  color: AppColors.blue,
                  backgroundColor: Colors.transparent,
                ),

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppConstants.horizontalPadding, 
                  AppConstants.screenPadding, 
                  AppConstants.horizontalPadding, 
                  8
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustText(
                        name: record.docNumber,
                        size: AppConstants.sectionHeaderSize,
                        color: AppColors.black,
                        fontWeightName: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: record.isActive ? const Color(0xFFE8F5E9) : const Color(0xFFFEEBEE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustText(
                        name: record.isActive ? AppStrings.statusActive : AppStrings.statusInActive,
                        size: 1.2,
                        color: record.isActive ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                        fontWeightName: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.dividerColor2, thickness: 1),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalPadding, 
                  vertical: 12
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryItem('Created On', record.date != null ? AppDateUtils.formatDate(record.date!) : AppStrings.notAvailable),
                    const SizedBox(width: 8),
                    _buildSummaryItem('Created By', record.createdByDetail?.fullName.toTitle() ?? AppStrings.notAvailable),
                    const SizedBox(width: 8),
                    _buildSummaryItem(AppStrings.matchStatus, record.matchStatusText, valueColor: record.matchStatusColor),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                color: const Color(0xFFF8F9FB),
                padding: const EdgeInsets.all(AppConstants.screenPadding),
                child: Column(
                  children: _buildOrderedSections(context, record),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  List<Widget> _buildOrderedSections(BuildContext context, LostFoundTableRecord record) {
    bool isFound = record.isFound;
    List<Widget> sections = [];

    sections.add(AccordionCard(
      title: AppStrings.basicDetails,
      child: Column(
        children: [
          _buildDetailRow(
            _buildDetailField(context, AppStrings.registeredAs, record.registerAs.toTitle()),
            _buildDetailField(context, AppStrings.station, record.stations?.name.toTitle() ?? AppStrings.notAvailable),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            _buildDetailField(context, '${record.registerAs.toTitle()} ${AppStrings.date}', record.date != null ? AppDateUtils.formatDateTime(record.date!) : AppStrings.notAvailable),
            _buildDetailField(context, isFound ? AppStrings.whatArticleFound : AppStrings.whatArticleLost, record.displayArticleName.toTitle()),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            _buildDetailField(context, isFound ? AppStrings.placeOfArticleFound : AppStrings.placeOfArticleLost, record.displayArticlePlace.toTitle()),
            _buildDetailField(context, AppStrings.internalNotes, record.internalNotes?.capitalizefirst() ?? AppStrings.noNotes),
          ),
        ],
      ),
    ));
    sections.add(const SizedBox(height: 16));

    sections.add(AccordionCard(
      title: AppStrings.itemDetails,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            _buildDetailField(context, AppStrings.color, record.color?.toTitle() ?? AppStrings.notAvailable),
            _buildDetailField(context, AppStrings.category, record.category?.toTitle() ?? AppStrings.notAvailable),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            _buildDetailField(context, AppStrings.quantityInNo, record.quantity?.toString() ?? AppStrings.notAvailable),
            _buildDetailField(context, AppStrings.estimatedValue, '₹${record.estimateValue ?? '0.00'} /-'),
          ),
          const SizedBox(height: 16),
          _buildDetailField(context, AppStrings.description, record.description?.capitalizefirst() ?? AppStrings.noDescriptionProvided),
        ],
      ),
    ));
    sections.add(const SizedBox(height: 16));

    if (isFound) {
      sections.add(AccordionCard(
        title: AppStrings.foundAttachments,
        child: Column(
          children: [
          if (record.foundAttachments.isEmpty)
            const CustText(name: AppStrings.noAttachmentsFound, size: 1.1, color: AppColors.textColor4)
          else ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: record.foundAttachments.map((attachment) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => FullImageViewer.show(
                        context,
                        imageUrl: attachment.filePath,
                        heroTag: 'attachment_${attachment.id}',
                      ),
                      child: Hero(
                        tag: 'attachment_${attachment.id}',
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            image: DecorationImage(
                              image: NetworkImage(attachment.filePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            CustText(
              name: '${AppStrings.uploadedOn} ${record.createdAt != null ? AppDateUtils.formatDate(record.createdAt!) : AppStrings.notAvailable}',
              size: 1.1,
              color: AppColors.textColor4,
            ),
          ],
          ],
        ),
      ));
      sections.add(const SizedBox(height: 16));
    }

    if (record.matchStatus >= 3) {
      if (record.matches != null) {
         sections.add(AccordionCard(
            title: AppStrings.matchedResult,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                MatchedItemCard(item: record.matches!),
                const Divider(height: 32, thickness: 1, color: Color(0xFFF1F5F9)),
                CustText.sectionHeader(AppStrings.matchBreakdown),
                const SizedBox(height: AppConstants.sectionSpacing,),
                Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: [
                    _buildBreakdownItemTag(TablerIcons.category, AppStrings.category, record.breakdownPassCount?['category'] ?? 0),
                    _buildBreakdownItemTag(TablerIcons.palette, AppStrings.color, record.breakdownPassCount?['color'] ?? 0),
                    _buildBreakdownItemTag(TablerIcons.building_community, AppStrings.station, record.breakdownPassCount?['station'] ?? 0),
                    _buildBreakdownItemTag(TablerIcons.calendar, AppStrings.date, record.breakdownPassCount?['date'] ?? 0),
                    _buildBreakdownItemTag(TablerIcons.map_pin, AppStrings.place, record.breakdownPassCount?['place'] ?? 0),
                    _buildBreakdownItemTag(TablerIcons.notes, AppStrings.description, record.breakdownPassCount?['description'] ?? 0),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ));
         sections.add(const SizedBox(height: 16));
      }

      if (!isFound) {
        sections.add(AccordionCard(
          title: AppStrings.verification,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             _buildDetailField(context, AppStrings.verifiedColor, record.verifiedColor?.toTitle() ?? (record.color?.toTitle() ?? AppStrings.notAvailable)),
             const SizedBox(height: 16),
             _buildDetailField(context, AppStrings.idProof, record.verifiedIdProof?.toTitle() ?? AppStrings.notAvailable),
             const SizedBox(height: 16),
             _buildDetailField(context, AppStrings.uniqueIdentification, record.verifiedUniqueIdentification ?? AppStrings.notAvailable),
          ],
        ),
      ));
        sections.add(const SizedBox(height: 16));

        sections.add(AccordionCard(
          title: AppStrings.handover,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            _buildDetailField(context, AppStrings.handoverTo, record.handoverToName?.toTitle() ?? AppStrings.notAvailable),
            const SizedBox(height: 16),
            _buildDetailField(context, AppStrings.handoverDate, record.handoverDate != null ? AppDateUtils.formatDate(record.handoverDate!) : AppStrings.notAvailable),
            const SizedBox(height: 16),
            _buildDetailField(context, AppStrings.remarks, record.remarks?.capitalizefirst() ?? AppStrings.notAvailable),
          ],
        ),
      ));
        sections.add(const SizedBox(height: 16));
      }
    }

    sections.add(DetailHistorySection(history: record.history));
    sections.add(const SizedBox(height: 16));

    return sections;
  }

  Widget _buildDetailRow(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 8),
        Expanded(child: right),
      ],
    );
  }

  Widget _buildBreakdownItemTag(IconData icon, String label, dynamic value) {
    final int score = value is int ? value : (double.tryParse(value.toString())?.toInt() ?? 0);
    final bool isHighlyMatched = score >= 20;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isHighlyMatched ? const Color(0xFFE3F2FD) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isHighlyMatched ? const Color(0xFFBBDEFB) : const Color(0xFFF1F5F9),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: isHighlyMatched ? AppColors.blue : AppColors.textColor4),
          const SizedBox(width: 6),
          CustText(
            name: '$label: $score%',
            size: AppConstants.detailLabelSize,
            color: isHighlyMatched ? AppColors.blue : AppColors.textColor,
            fontWeightName: isHighlyMatched ? FontWeight.bold : FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustText.detailLabel(label),
        const SizedBox(height: AppConstants.labelSpacing),
        CustText.detailValue(value, color: valueColor, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _buildDetailField(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustText.detailLabel(label),
        SizedBox(height: ResponsiveHelper.spacing(context, AppConstants.labelSpacing)),
        CustText.detailValue(value)
      ],
    );
  }

  Widget _buildSkeletonLoader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SkeletonLoader.card(height: 40, width: double.infinity),
          const SizedBox(height: 20),
          SkeletonLoader.card(height: 200, width: double.infinity),
          const SizedBox(height: 20),
          SkeletonLoader.card(height: 200, width: double.infinity),
        ],
      ),
    );
  }
}
