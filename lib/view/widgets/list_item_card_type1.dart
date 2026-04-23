import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'cust_text.dart';

/// Data model for a small tag (e.g. plan, department).
class TagData {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const TagData({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });
}

/// Data model for a detail column (label + value) shown at the bottom.
class DetailColumn {
  final String label;
  final String value;

  const DetailColumn({required this.label, required this.value});
}

/// Inspection-style list item card with:
/// - Left vertical color bar
/// - Top row: title + status tag
/// - Subtitle tags row
/// - Bottom detail columns
class ListItemCardType1 extends StatelessWidget {
  final String title;
  final String? statusText;
  final Color? statusColor;
  final List<TagData> subtitleTags;
  final List<DetailColumn> detailColumns;
  final Color leftBarColor;
  final VoidCallback? onTap;
  final Widget? footer;

  const ListItemCardType1({
    Key? key,
    required this.title,
     this.statusText,
     this.statusColor,
    this.subtitleTags = const [],
    this.detailColumns = const [],
    required this.leftBarColor,
    this.onTap,
    this.footer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.dividerColor2),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Left color bar
            Positioned(
              left: 0,
              top: 12,
              bottom: 12,
              child: Container(
                width: 5,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  color: leftBarColor,
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.only(left: 17, right: 12, top: 12, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Row 1: Title + Status Tag
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: CustText(
                          name: title,
                          size: 1.6,
                          color: Colors.black,
                          fontWeightName: FontWeight.bold,
                        ),
                      ),
                      statusText == ""
                          ? SizedBox()
                          : _buildTag(
                              text: statusText!,
                              backgroundColor: statusColor!.withOpacity(0.15),
                              textColor: statusColor!,
                            ),
                    ],
                  ),
                  // Row 2: Subtitle tags
                  if (subtitleTags.isNotEmpty)
                    Row(
                      children: subtitleTags
                          .map((tag) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: _buildTag(
                                  text: tag.text,
                                  backgroundColor: tag.backgroundColor,
                                  textColor: tag.textColor,
                                ),
                              ))
                          .toList(),
                    ),
                  // Row 3: Detail columns
                  if (detailColumns.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: detailColumns
                          .map((col) => Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustText.detailLabel(col.label),
                                    const SizedBox(height: 2),
                                    CustText.detailValue(col.value),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                  if (footer != null) ClipRect(child: footer!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag({
    required String text,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: CustText(
        name: text,
        size: 1.2,
        color: textColor,
        fontWeightName: FontWeight.w500,
      ),
    );
  }
}
