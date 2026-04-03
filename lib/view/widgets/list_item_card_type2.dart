import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'cust_text.dart';

/// Data model for a single field in a card column.
/// When [isTag] is true, the value is rendered as a colored tag container.
class CardFieldItem {
  final String label;
  final String value;
  final bool isTag;
  final Color? tagBgColor;
  final Color? tagTextColor;

  const CardFieldItem({
    required this.label,
    required this.value,
    this.isTag = false,
    this.tagBgColor,
    this.tagTextColor,
  });
}

/// Two-column list item card with:
/// - White card with border
/// - Two side-by-side columns of label/value pairs
/// - Optional more_vert menu button (top-right)
/// - Optional tag-style rendering for individual fields
class ListItemCardType2 extends StatelessWidget {
  final List<CardFieldItem> leftColumnItems;
  final List<CardFieldItem> rightColumnItems;
  final VoidCallback? onTap;
  final VoidCallback? onMenuPressed;
  final bool useSpacerBetweenColumns;

  const ListItemCardType2({
    Key? key,
    required this.leftColumnItems,
    required this.rightColumnItems,
    this.onTap,
    this.onMenuPressed,
    this.useSpacerBetweenColumns = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardContent = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildFieldWidgets(leftColumnItems),
            ),
          ),
          if (useSpacerBetweenColumns)
            const Spacer()
          else
            const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildFieldWidgets(rightColumnItems),
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.dividerColor2),
        ),
        child: onMenuPressed != null
            ? Stack(
                children: [
                  cardContent,
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.more_vert,
                          color: AppColors.textColor4),
                      onPressed: onMenuPressed,
                    ),
                  ),
                ],
              )
            : cardContent,
      ),
    );
  }

  List<Widget> _buildFieldWidgets(List<CardFieldItem> items) {
    final List<Widget> widgets = [];
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      if (i > 0) widgets.add(const SizedBox(height: 4));

      // Label
      widgets.add(
        CustText(name: item.label, size: 1.3, color: AppColors.textColor4),
      );

      // Value — either as tag or plain text
      if (item.isTag && item.tagBgColor != null && item.tagTextColor != null) {
        widgets.add(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: item.tagBgColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: CustText(
              name: item.value,
              size: 1.3,
              color: item.tagTextColor!,
            ),
          ),
        );
      } else {
        widgets.add(
          CustText(
            name: item.value,
            size: 1.4,
            color: AppColors.black,
            fontWeightName: FontWeight.w600,
          ),
        );
      }
    }
    return widgets;
  }
}
