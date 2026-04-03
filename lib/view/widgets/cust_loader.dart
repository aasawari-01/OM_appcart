import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class CustLoader extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? color;

  const CustLoader({
    super.key,
    this.size = 24.0,
    this.strokeWidth = 3.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppColors.blue,
          ),
        ),
      ),
    );
  }
}
