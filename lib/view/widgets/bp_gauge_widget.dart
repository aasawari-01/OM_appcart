import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../constants/colors.dart';
import 'cust_text.dart';

class BpGaugeWidget extends StatefulWidget {
  final double percentage; // 0.0 to 1.0

  const BpGaugeWidget({
    super.key,
    required this.percentage,
  });

  @override
  State<BpGaugeWidget> createState() => _BpGaugeWidgetState();
}

class _BpGaugeWidgetState extends State<BpGaugeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _needleAnimation;
  double _lastAngle = -180.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _setupAnimation();
    _animationController.forward();
  }

  @override
  void didUpdateWidget(BpGaugeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _setupAnimation();
      _animationController.forward(from: 0);
    }
  }

  void _setupAnimation() {
    final targetAngle = _calculateTargetAngle(widget.percentage);
    _needleAnimation = Tween<double>(
      begin: _lastAngle,
      end: targetAngle,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _lastAngle = targetAngle;
      }
    }));
  }

  double _calculateTargetAngle(double percentage) {
    // 0% is at -180 degrees, 100% is at 0 degrees
    return -180.0 + (percentage * 180.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(double.infinity, 150),
                painter: BpGaugePainter(
                  needleAngle: _needleAnimation.value,
                ),
              );
            },
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFCFBE4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF0E68C), width: 0.5),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${(widget.percentage * 100).toInt()}% ',
                      style: const TextStyle(
                        color: Color(0xFFC4B400),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const TextSpan(
                      text: 'Match Found',
                      style: TextStyle(
                        color: Color(0xFFC4B400),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class BpGaugePainter extends CustomPainter {
  final double needleAngle;

  BpGaugePainter({
    required this.needleAngle,
  });

  final List<Color> colors = [
    const Color(0xFFef4444), // Red
    const Color(0xFFfb923c), // Orange
    const Color(0xFFfbbf24), // Yellow
    const Color(0xFF22C55E), // Green
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.85);
    final outerRadius = size.width * 0.40;
    final innerRadius = size.width * 0.28;

    _drawSections(canvas, center, innerRadius, outerRadius);
    _drawNeedle(canvas, center, outerRadius);
  }

  void _drawSections(Canvas canvas, Offset center, double innerR, double outerR) {
    const double startAngle = -180.0;
    const double totalSweep = 180.0;
    final double segmentSweep = totalSweep / colors.length;

    for (int i = 0; i < colors.length; i++) {
      final start = _degreesToRadians(startAngle + (i * segmentSweep));
      final sweep = _degreesToRadians(segmentSweep);

      final path = Path();
      path.arcTo(Rect.fromCircle(center: center, radius: outerR), start, sweep, true);
      path.arcTo(Rect.fromCircle(center: center, radius: innerR), start + sweep, -sweep, false);
      path.close();

      final paint = Paint()..color = colors[i]..style = PaintingStyle.fill;
      canvas.drawPath(path, paint);
    }
  }

  void _drawNeedle(Canvas canvas, Offset center, double radius) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(_degreesToRadians(needleAngle + 90));

    double needleLength = radius * 0.7;

    final needlePath = Path()
      ..moveTo(0, -needleLength)
      ..lineTo(4, 0)
      ..lineTo(-4, 0)
      ..close();

    final paint = Paint()
      ..color = const Color(0xFF1f2937)
      ..style = PaintingStyle.fill;

    canvas.drawPath(needlePath, paint);
    canvas.restore();

    // Center cap
    canvas.drawCircle(center, 10, Paint()..color = const Color(0xFF1f2937));
    canvas.drawCircle(center, 8, Paint()..color = Colors.white.withOpacity(0.5)..style = PaintingStyle.stroke..strokeWidth = 1);
    canvas.drawCircle(center, 4, Paint()..color = Colors.white);
  }

  double _degreesToRadians(double degrees) => degrees * math.pi / 180;

  @override
  bool shouldRepaint(BpGaugePainter oldDelegate) =>
      oldDelegate.needleAngle != needleAngle;
}
