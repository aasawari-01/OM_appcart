import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/view/widgets/accordion_card.dart';
import 'package:om_appcart/view/widgets/cust_button.dart';
import 'package:om_appcart/view/widgets/cust_text.dart';
import '../../controller/lost_and_found_form_controller.dart';
import 'match_breakdown_section.dart';
import 'matched_item_card.dart';
import '../finalize_found_lost_items_screen.dart';

class LFMatchStatusStep extends StatelessWidget {
  final LostAndFoundFormController controller;
  final ScrollController scrollController;

  const LFMatchStatusStep({
    Key? key,
    required this.controller,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Obx(() {
            if (!controller.showMatchResult.value) {
              return AccordionCard(
                title: 'Match Status',

                child: CustButton(
                  name: 'Check Found Lost Items',
                  onSelected: (val) {
                    controller.showMatchResult.value = true;
                    _startMatchAnimation();
                  },
                  size: double.infinity,
                  color1: AppColors.blue,
                  borderRadius: 4,
                  sHeight: 45,
                  fontSize: 14,
                ),
              );
            } else {
              return Column(
                children: [
                  if (controller.selectedMatchItems.value == null || controller.selectedMatchItems.value!.isEmpty)
                    AccordionCard(
                      title: 'Match Status',
                      child: _buildMatchResultContent(),
                    ),
                  if (controller.selectedMatchItems.value != null && controller.selectedMatchItems.value!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    AccordionCard(
                      title: 'Matched',
                      child: Column(
                        children: controller.selectedMatchItems.value!.map((item) => MatchedItemCard(item: item)).toList(),
                      ),
                    ),
                  ],
                ],
              );
            }
          }),
        ],
      ),
    );
  }

  void _startMatchAnimation() async {
    await controller.startAutoMatch();
    
    bool hasMatches = (controller.autoMatchResult.value?['matches'] as List?)?.isNotEmpty ?? false;
    if (!hasMatches) return;

    await Future.delayed(const Duration(milliseconds: 1500));

    for (int i = 1; i <= 6; i++) {
      controller.visibleItemsCount.value = i;
      await Future.delayed(const Duration(milliseconds: 400));
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  Widget _buildMatchResultContent() {
    if (controller.isAutoMatching.value) {
      return const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()));
    }

    bool hasMatches = (controller.autoMatchResult.value?['matches'] as List?)?.isNotEmpty ?? false;
    if (!hasMatches && controller.autoMatchResult.value != null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CustText(
            name: 'No match found.',
            size: 1.4,
            fontWeightName: FontWeight.bold,
            color: AppColors.red,
          ),
        ),
      );
    }

    if (controller.autoMatchResult.value == null) return const SizedBox.shrink();

    return Column(
      children: [
        MatchBreakdownSection(
          breakdown: controller.autoMatchResult.value?['breakdownPassCount'] ?? {},
          overallScore: (controller.autoMatchResult.value?['overallAverageScore'] ?? 0).toDouble(),
          totalRecords: controller.autoMatchResult.value?['totalRecords'] ?? 1,
          visibleItemsCount: controller.visibleItemsCount.value,
          animate: true,
        ),
        if (controller.visibleItemsCount.value >= 6) ...[
          const SizedBox(height: 24),
          CustButton(
            name: 'Finalize Match',
            onSelected: (val) async {
              final result = await Get.to(
                () => const FinalizeFoundLostItemsScreen(),
                arguments: {
                  'lostID': controller.initialRecord!.id,
                  'matchData': controller.autoMatchResult.value?['matches'] ?? [],
                },
              );

              if (result != null && result is Map<String, dynamic>) {
                controller.selectedMatchItems.value = [result];
              }
            },
            size: 150,
            color1: AppColors.blue,
            borderRadius: 4,
            sHeight: 45,
            fontSize: 14,
          ),
        ],
      ],
    );
  }
}
