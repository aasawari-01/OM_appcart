import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'cust_text.dart';

class TaskToggleBar extends StatelessWidget {
  final bool isAssignedSelected;
  final Function(bool) onToggle;

  const TaskToggleBar({
    Key? key,
    required this.isAssignedSelected,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _toggleItem(
              title: "Assigned",
              isSelected: isAssignedSelected,
              onTap: () => onToggle(true),
            ),
          ),
          Expanded(
            child: _toggleItem(
              title: "Created",
              isSelected: !isAssignedSelected,
              onTap: () => onToggle(false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: CustText(
          name: title,
          size: 1.6,
          color: isSelected ? Colors.white : AppColors.textColor4,
          fontWeightName: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
