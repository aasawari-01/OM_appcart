import 'package:flutter/material.dart';

class CustSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;

  const CustSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor = const Color(0xFF27AE60),
    this.inactiveColor = const Color(0xFFD2D2D2),
    this.thumbColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: 45,
        height: 25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: value ? activeColor : inactiveColor,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: value ? 22.5 : 2.5,
              top: 2.5,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: thumbColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: value 
                  ? Icon(
                      Icons.check, 
                      size: 16, 
                      color: activeColor,
                    )
                  : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
