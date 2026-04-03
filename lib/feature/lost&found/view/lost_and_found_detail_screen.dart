import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:om_appcart/constants/colors.dart';
import '../../../view/widgets/accordion_card.dart';
import '../../../view/widgets/bp_gauge_widget.dart';
import '../../../view/widgets/cust_button.dart';
import '../../../view/widgets/cust_text.dart';
import '../../../view/widgets/custom_app_bar.dart';
import '../../../view/widgets/skeleton_loader.dart';
import 'finalize_found_lost_items_screen.dart';

import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../model/lost_found_table_record.dart';
import '../controller/lost_and_found_detail_controller.dart';
import '../../../utils/string_utils.dart';
import 'package:om_appcart/view/widgets/full_image_viewer.dart';

class LostAndFoundDetailScreen extends StatefulWidget {
  final LostFoundTableRecord record;

  const LostAndFoundDetailScreen({
    Key? key,
    required this.record,
  }) : super(key: key);

  @override
  State<LostAndFoundDetailScreen> createState() => _LostAndFoundDetailScreenState();
}

class _LostAndFoundDetailScreenState extends State<LostAndFoundDetailScreen> {
  late LostAndFoundDetailController controller;
  bool _showMatchResult = false;
  int _visibleItemsCount = 0;
  final ScrollController _scrollController = ScrollController();
  List<dynamic>? _selectedItems;
  bool _isMatchStatusExpanded = true;
  bool _isMatchedExpanded = true;
  bool _isBasicDetailsExpanded = true;
  bool _isItemDetailsExpanded = true;
  bool _isFoundAttachmentsExpanded = true;
  bool _isVerificationExpanded = true;
  bool _isHandoverExpanded = true;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      LostAndFoundDetailController(
        uniqueCode: widget.record.uniqueCode,
        initialRecord: widget.record,
      ),
      tag: widget.record.uniqueCode,
    );
    _populateMatchedItems();
  }

  void _populateMatchedItems() {
    if (widget.record.matches != null) {
      setState(() {
        _selectedItems = [
          // We can't easily convert record.matches (Model) to Map if we want to keep it simple,
          // so we'll just allow _selectedItems to hold dynamic objects.
        ];
        // Actually, let's just use the same logic as LostAndFoundScreen
        _selectedItems = [widget.record.matches! as dynamic];
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    Get.delete<LostAndFoundDetailController>(tag: widget.record.uniqueCode);
    super.dispose();
  }

  // Animation logic removed as per design request to show static cards in View mode.

  String _getMatchStatusText(int status) {
    switch (status) {
      case 1:
        return 'Opened';
      case 2:
        return 'Unmatched';
      case 3:
        return 'Match Found';
      case 4:
        return 'Verified';
      case 5:
        return 'Finalized';
      default:
        return 'Unknown';
    }
  }

  Color _getMatchStatusColor(int status) {
    switch (status) {
      case 1:
        return AppColors.blue;
      case 2:
        return AppColors.red;
      case 3:
        return AppColors.orange;
      case 4:
        return AppColors.green;
      case 5:
        return AppColors.green;
      default:
        return AppColors.grey;
    }
  }

  Color _getStatusColor(bool isActive) {
    return isActive ? AppColors.green : AppColors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Lost & Found Details',
        showDrawer: false,
        isForm: true,
        onLeadingPressed: () => Navigator.pop(context),
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
                const Text('Failed to load details'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: controller.fetchDetail,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Loading indicator at top if refreshing
              if (controller.isLoading.value)
                const LinearProgressIndicator(
                  minHeight: 2,
                  color: AppColors.blue,
                  backgroundColor: Colors.transparent,
                ),

              // Ticket ID and Status
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustText(
                        name: record.docNumber,
                        size: 1.6,
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
                        name: record.isActive ? 'Active' : 'In-Active',
                        size: 1.2,
                        color: record.isActive ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                        fontWeightName: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.dividerColor2, thickness: 1),

              // Summary Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _buildSummaryItem('Created On', record.date != null ? DateFormat('dd MM yyyy').format(record.date!) : 'N/A')),

                    const SizedBox(width: 8),
                    Expanded(child: _buildSummaryItem('Created By', record.createdByDetail?.fullName?.toTitleCase() ?? 'N/A')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildSummaryItem('Match Status', _getMatchStatusText(record.matchStatus), valueColor: _getMatchStatusColor(record.matchStatus))),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Content Body
              Container(
                width: double.infinity,
                color: const Color(0xFFF8F9FB),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: _buildOrderedSections(record),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  List<Widget> _buildOrderedSections(LostFoundTableRecord record) {
    bool isFound = record.registerAs == 'Found';
    List<Widget> sections = [];

    // 1. Basic Details
    sections.add(AccordionCard(
      title: 'Basic Details',
      isExpanded: true,
      expanded: _isBasicDetailsExpanded,
      onTap: () => setState(() => _isBasicDetailsExpanded = !_isBasicDetailsExpanded),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildDetailField('Registered As', record.registerAs.toTitleCase())),
              Expanded(child: _buildDetailField('Station', record.stations?.name?.toTitleCase() ?? 'N/A')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildDetailField('${record.registerAs.toTitleCase()} Date', record.date != null ? DateFormat('dd MM yyyy, hh:mm a').format(record.date!) : 'N/A')),

              Expanded(child: _buildDetailField(isFound ? 'What Article Found' : 'What Article Lost', isFound ? (record.articleFound?.toTitleCase() ?? 'N/A') : (record.articleLost?.toTitleCase() ?? 'N/A'))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildDetailField(isFound ? 'Place of Article Found' : 'Place of Article Lost', isFound ? (record.articleFoundPlace?.toTitleCase() ?? 'N/A') : (record.articleLostPlace?.toTitleCase() ?? 'N/A'))),
              Expanded(child: _buildDetailField('Internal Notes', record.internalNotes?.capitalizeFirstLetter() ?? 'No notes')),
            ],
          ),
        ],
      ),
    ));
    sections.add(const SizedBox(height: 16));

    // 2. Item Details
    sections.add(AccordionCard(
      title: 'Item Details',
      isExpanded: true,
      expanded: _isItemDetailsExpanded,
      onTap: () => setState(() => _isItemDetailsExpanded = !_isItemDetailsExpanded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildDetailField('Color', record.color?.toTitleCase() ?? 'N/A')),
              Expanded(child: _buildDetailField('Category', record.category?.toTitleCase() ?? 'N/A')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildDetailField('Quantity in No', record.quantity?.toString() ?? 'N/A')),
              Expanded(child: _buildDetailField('Estimated Value', '₹${record.estimateValue ?? '0.00'} /-')),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailField('Description', record.description?.capitalizeFirstLetter() ?? 'No description provided'),
        ],
      ),
    ));
    sections.add(const SizedBox(height: 16));

    if (isFound) {
      sections.add(AccordionCard(
        title: 'Found Attachments',
        isExpanded: true,
        expanded: _isFoundAttachmentsExpanded,
        onTap: () => setState(() => _isFoundAttachmentsExpanded = !_isFoundAttachmentsExpanded),
        child: Column(
          children: [
          if (record.foundAttachments.isEmpty)
            const CustText(name: 'No attachments found', size: 1.1, color: AppColors.textColor4)
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
              name: 'Uploaded on ${record.createdAt != null ? DateFormat('dd MM yyyy').format(record.createdAt!) : 'N/A'}',

              size: 1.1,
              color: AppColors.textColor4,
            ),
          ],
          ],
        ),
      ));
      sections.add(const SizedBox(height: 16));
    }

    // 4. After Match sections (matchStatus >= 3)
    if (record.matchStatus >= 3) {
      // 4.1. Match Status Section
      final itemsToShow = (_selectedItems != null && _selectedItems!.isNotEmpty) 
          ? _selectedItems 
          : (record.matches != null ? [record.matches!] : null);

      if (itemsToShow != null && itemsToShow.isNotEmpty) {
         sections.add(_buildMatchedSection(itemsToShow, record));
         sections.add(const SizedBox(height: 16));
      }

      // 4.2. Verification & Handover (Only for Lost, OR Found with Match)
      if (!isFound) {
        // Verification
        sections.add(AccordionCard(
          title: 'Verification',
          isExpanded: true,
          expanded: _isVerificationExpanded,
          onTap: () => setState(() => _isVerificationExpanded = !_isVerificationExpanded),
          child: Column(
            children: [
             _buildDetailField('Verified Color', record.verifiedColor?.toTitleCase() ?? (record.color?.toTitleCase() ?? 'N/A')),
             const SizedBox(height: 16),
             _buildDetailField('ID Proof', record.verifiedIdProof?.toTitleCase() ?? 'N/A'),
             const SizedBox(height: 16),
             _buildDetailField('Unique Identification', record.verifiedUniqueIdentification ?? 'N/A'),
          ],
        ),
      ));
        sections.add(const SizedBox(height: 16));

        // Handover
        sections.add(AccordionCard(
          title: 'Handover',
          isExpanded: true,
          expanded: _isHandoverExpanded,
          onTap: () => setState(() => _isHandoverExpanded = !_isHandoverExpanded),
          child: Column(
            children: [
            _buildDetailField('Handover To', record.handoverToName?.toTitleCase() ?? 'N/A'),
            const SizedBox(height: 16),
            _buildDetailField('Handover Date', record.handoverDate != null ? DateFormat('dd MM yyyy').format(record.handoverDate!) : 'N/A'),

            const SizedBox(height: 16),
            _buildDetailField('Remarks', record.remarks?.capitalizeFirstLetter() ?? 'N/A'),
          ],
        ),
      ));
        sections.add(const SizedBox(height: 16));
      }
    }

    // 5. History (Always at the end)
    sections.add(_buildHistorySection(record));
    sections.add(const SizedBox(height: 16));

    return sections;
  }

  Widget _buildHistorySection(LostFoundTableRecord record) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: CustText(
            name: 'Lost & Found History',
            size: 1.4,
            fontWeightName: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        ...record.history.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: CustText(
                              name: '#${item.id}',
                              size: 1.1,
                              fontWeightName: FontWeight.bold,
                              color: AppColors.textColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          CustText(
                            name: item.action.toTitleCase(),
                            size: 1.3,
                            fontWeightName: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: CustText(
                          name: item.status.toTitleCase(),
                          size: 1.0,
                          fontWeightName: FontWeight.bold,
                          color: const Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFF1F5F9), thickness: 1),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 18, color: AppColors.textColor4),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustText(
                          name: item.createdBy.toTitleCase(),
                          size: 1.2,
                          color: AppColors.black,
                          fontWeightName: FontWeight.w500,
                        ),
                      ),
                      const Icon(Icons.access_time, size: 16, color: AppColors.textColor4),
                      const SizedBox(width: 4),
                      CustText(
                        name: item.createdAt != null ? DateFormat('dd MM yyyy').format(item.createdAt!) : 'N/A',

                        size: 1.1,
                        color: AppColors.textColor4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.notes_outlined, size: 18, color: AppColors.textColor4),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustText(
                          name: 'Remark: ${item.remark.capitalizeFirstLetter()}',
                          size: 1.1,
                          color: AppColors.textColor4,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildAttachmentPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Icon(Icons.image_outlined, color: AppColors.textColor4),
    );
  }

  // Animations and interactive match content removed for View mode - using _buildOrderedSections instead.

  Widget _buildMatchedSection(List<dynamic> items, LostFoundTableRecord record) {
    return AccordionCard(
      title: 'Matched Result',
      isExpanded: true,
      expanded: _isMatchedExpanded,
      onTap: () {
        setState(() {
          _isMatchedExpanded = !_isMatchedExpanded;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          ...items.map((item) {
            final isModel = item is LostFoundTableRecord;
            
            // Extract display values carefully
            final String docNo = isModel 
                ? (item.docNumber.isNotEmpty ? item.docNumber : 'ID: ${item.id}')
                : (item['docNumber'] ?? item['ticketId'] ?? 'ID: ${item['id'] ?? item['found_id'] ?? 'N/A'}');
            
            final String article = isModel 
                ? (item.articleFound?.toTitleCase() ?? item.articleLost?.toTitleCase() ?? 'N/A') 
                : (item['articleFound']?.toString().toTitleCase() ?? item['articleLost']?.toString().toTitleCase() ?? 'N/A');
            
            final score = isModel ? (item.matchPercentage ?? 0.0) : (item['score'] ?? item['matchPercentage'] ?? 0.0);
            final percentageStr = '${score.toStringAsFixed(1)}%';
            
            final category = isModel ? (item.category ?? 'N/A') : (item['category'] ?? 'N/A');
            final place = isModel 
                ? (item.articleFoundPlace?.toTitleCase() ?? item.articleLostPlace?.toTitleCase() ?? 'N/A') 
                : (item['articleFoundPlace']?.toString().toTitleCase() ?? item['articleLostPlace']?.toString().toTitleCase() ?? item['foundPlace']?.toString().toTitleCase() ?? 'N/A');
            
            final color = isModel ? (item.color?.toTitleCase() ?? 'N/A') : (item['color']?.toString().toTitleCase() ?? 'N/A');
            final quantity = isModel ? (item.quantity?.toString() ?? '1') : (item['quantity']?.toString() ?? '1');
            final description = isModel ? (item.description?.capitalizeFirstLetter() ?? 'No description') : (item['description']?.toString().capitalizeFirstLetter() ?? 'No description');
            final registerAs = isModel ? (item.registerAs?.toTitleCase() ?? 'N/A') : (item['registerAs']?.toString().toTitleCase() ?? 'N/A');

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(TablerIcons.barcode, size: 18, color: AppColors.blue),
                              const SizedBox(width: 8),
                              Flexible(
                                child: CustText(
                                  name: docNo,
                                  size: 1.1,
                                  color: AppColors.black,
                                  fontWeightName: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildSmallTag(percentageStr, const Color(0xFFE8F5E9), const Color(0xFF4CAF50)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMatchInfoRow(TablerIcons.clipboard_list, 'Register As', registerAs),
                        const SizedBox(height: 10),
                        _buildMatchInfoRow(TablerIcons.package, 'Article', article),
                        const SizedBox(height: 10),
                        _buildMatchInfoRow(TablerIcons.map_pin, 'Place', place),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _buildMatchInfoRow(TablerIcons.palette, 'Color', color)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildMatchInfoRow(TablerIcons.category, 'Category', category)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildMatchInfoRow(TablerIcons.numbers, 'Quantity', quantity),
                        
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(color: Color(0xFFF1F5F9), thickness: 1),
                        ),
                        
                        const CustText(name: 'Description', size: 1.0, color: AppColors.textColor4, fontWeightName: FontWeight.w600),
                        const SizedBox(height: 6),
                        CustText(
                          name: description,
                          size: 1.1,
                          color: AppColors.black,
                          fontWeightName: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          
          const Divider(height: 32, thickness: 1, color: Color(0xFFF1F5F9)),
          
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: CustText(
              name: 'Match Breakdown',
              size: 1.2,
              fontWeightName: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: [
              _buildBreakdownItemTag(TablerIcons.category, 'Category', record.breakdownPassCount?['category'] ?? 0),
              _buildBreakdownItemTag(TablerIcons.palette, 'Color', record.breakdownPassCount?['color'] ?? 0),
              _buildBreakdownItemTag(TablerIcons.building_community, 'Station', record.breakdownPassCount?['station'] ?? 0),
              _buildBreakdownItemTag(TablerIcons.calendar, 'Date', record.breakdownPassCount?['date'] ?? 0),
              _buildBreakdownItemTag(TablerIcons.map_pin, 'Place', record.breakdownPassCount?['place'] ?? 0),
              _buildBreakdownItemTag(TablerIcons.notes, 'Description', record.breakdownPassCount?['description'] ?? 0),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMatchInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textColor4),
        const SizedBox(width: 8),
        CustText(name: '$label:', size: 1.1, color: AppColors.textColor4),
        const SizedBox(width: 8),
        Expanded(
          child: CustText(
            name: value, 
            size: 1.1, 
            color: AppColors.black, 
            fontWeightName: FontWeight.w600,
            overflow: TextOverflow.ellipsis,
          ),
        ),
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
            size: 1.0,
            color: isHighlyMatched ? AppColors.blue : AppColors.textColor,
            fontWeightName: isHighlyMatched ? FontWeight.bold : FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildSmallTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: CustText(
        name: text,
        size: 1.0,
        color: textColor,
        fontWeightName: FontWeight.w500,
      ),
    );
  }

  // The shouldRepaint method is typically part of a CustomPainter class, not a State class.
  // If it was intended for a CustomPainter, it should be moved there.
  // If it's not used, it should be removed. For now, it's commented out.
  // @override
  // bool shouldRepaint(CustomPainter oldDelegate) => false;

  Widget _buildSummaryItem(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustText(
          name: label,
          size: 1.2,
          color: AppColors.textColor4,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        CustText(
          name: value,
          size: 1.3,
          color: valueColor ?? AppColors.black,
          fontWeightName: FontWeight.bold,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }


  Widget _buildDetailField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustText(
          name: label,
          size: 1.2,
          color: AppColors.textColor4,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        CustText(
          name: value,
          size: 1.4,
          color: AppColors.black,
          fontWeightName: FontWeight.w500,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildSkeletonLoader() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SkeletonLoader.card(height: 40, width: double.infinity),
          const SizedBox(height: 20),
          SkeletonLoader.card(height: 200),
          const SizedBox(height: 20),
          SkeletonLoader.card(height: 200),
          const SizedBox(height: 20),
          SkeletonLoader.card(height: 100),
        ],
      ),
    );
  }
  //
  // void _showClaimDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Claim Item'),
  //       content: const Text('Are you sure you want to claim this item?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //             // Implement claim logic
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(content: Text('Claim submitted successfully!')),
  //             );
  //           },
  //           child: const Text('Confirm'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // void _showContactDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Contact Information'),
  //       content: const Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text('Email: lostfound@omappcart.com'),
  //           SizedBox(height: 8),
  //           Text('Phone: +91 1234567890'),
  //           SizedBox(height: 8),
  //           Text('Office: Room 101, Main Building'),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Close'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
