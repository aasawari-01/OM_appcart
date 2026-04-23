import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:om_appcart/constants/colors.dart';
import 'package:om_appcart/view/widgets/cust_text.dart';
import 'package:om_appcart/view/widgets/bp_gauge_widget.dart';

class MatchBreakdownSection extends StatelessWidget {
  final Map<String, dynamic> breakdown;
  final double overallScore;
  final int totalRecords;
  final int visibleItemsCount;
  final bool animate;

  const MatchBreakdownSection({
    Key? key,
    required this.breakdown,
    required this.overallScore,
    this.totalRecords = 1,
    this.visibleItemsCount = 6,
    this.animate = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int getPerc(String key) {
      if (totalRecords == 0) return 0;
      final value = breakdown[key];
      if (value is int) return ((value / totalRecords) * 100).toInt();
      if (value is double) return value.toInt();
      return 0;
    }

    final catPerc = getPerc('category');
    final colorPerc = getPerc('color');
    final stationPerc = getPerc('station');
    final datePerc = getPerc('date');
    final placePerc = getPerc('place');
    final descPerc = getPerc('description');

    return Column(
      children: [
        BpGaugeWidget(percentage: overallScore / 100),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFFCC80), width: 0.5),
          ),
          child: const CustText(
            name: 'Match is based on the parameters provided by user. User is responsible for final handover.',
            size: 1.1,
            color: Color(0xFF8D6E63),
          ),
        ),
        const SizedBox(height: 16),

        _buildAnimatedListItem(0, 'Category Match', '$catPerc%',
          catPerc >= 50 ? TablerIcons.circle_check_filled : Icons.cancel,
          catPerc >= 50 ? AppColors.green : AppColors.red),

        _buildAnimatedListItem(1, 'Color Match', '$colorPerc%',
          colorPerc >= 50 ? Icons.check_circle : Icons.cancel,
          colorPerc >= 50 ? AppColors.green : AppColors.red),

        _buildAnimatedListItem(2, 'Station Match', '$stationPerc%',
          stationPerc >= 50 ? Icons.check_circle : Icons.cancel,
          stationPerc >= 50 ? AppColors.green : AppColors.red),

        _buildAnimatedListItem(3, 'Date Match', '$datePerc%',
          datePerc >= 50 ? Icons.check_circle : Icons.watch_later,
          datePerc >= 50 ? AppColors.green : AppColors.orange),

        _buildAnimatedListItem(4, 'Place Match', '$placePerc%',
          placePerc >= 50 ? Icons.check_circle : Icons.watch_later,
          placePerc >= 50 ? AppColors.green : AppColors.orange),

        _buildAnimatedListItem(5, 'Description Match', '$descPerc%',
          descPerc >= 50 ? Icons.check_circle : Icons.watch_later,
          descPerc >= 50 ? AppColors.green : AppColors.orange),
      ],
    );
  }

  Widget _buildAnimatedListItem(int index, String title, String subtitle, IconData icon, Color iconColor) {
    bool isVisible = !animate || visibleItemsCount > index;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: isVisible ? 1.0 : 0.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Icon(icon, color: iconColor, size: 24),
                if (index < 5)
                  Expanded(
                    child: CustomPaint(
                      size: const Size(1, double.infinity),
                      painter: DashedLinePainter(),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustText(
                    name: title,
                    size: 1.2,
                    fontWeightName: FontWeight.bold,
                  ),
                  CustText(
                    name: subtitle,
                    size: 1.1,
                    color: iconColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
