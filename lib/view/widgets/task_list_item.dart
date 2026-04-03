import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'cust_text.dart';

class TaskListItem extends StatelessWidget {
  final Map<String, dynamic> task;
  final bool showUpdatedTime;
  final VoidCallback? onTap;

  const TaskListItem({
    Key? key,
    required this.task,
    this.showUpdatedTime = false,
    this.onTap,
  }) : super(key: key);

  Color _getPriorityFlagColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'very high':
        return const Color(0xFFDD3737);
      case 'high':
        return AppColors.orange;
      case 'medium':
        return AppColors.yellow;
      case 'low':
        return AppColors.blue;
      default:
        return AppColors.textColor4;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return const Color(0xFFFFE8E8);
      case 'reassigned':
        return const Color(0xFFE6F7FF);
      case 'in process':
        return const Color(0xFFFFF7E6);
      case 'pending':
        return const Color(0xFFFFF7E6);
      case 'closed':
        return const Color(0xFFE6FFEA);
      default:
        return const Color(0xFFF5F5F5);
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return const Color(0xFFDD3737);
      case 'reassigned':
        return AppColors.blue;
      case 'in process':
        return AppColors.orange;
      case 'pending':
        return AppColors.orange;
      case 'closed':
        return AppColors.green;
      default:
        return AppColors.textColor4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9E9E9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CustText(
                    name: task['id'] ?? '',
                    size:2.0,
                    fontWeightName: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: _getStatusBgColor(task['status'] ?? ''),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CustText(
                    name:  task['status'] ?? '',
                    size: 1.2,
                    color:  _getStatusTextColor(task['status'] ?? ''),
                    fontWeightName: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.flag,
                        size: 14,
                        color: _getPriorityFlagColor(task['priority'] ?? ''),
                      ),
                      const SizedBox(width: 4),
                      CustText(
                        name: task['priority'] ?? '',
                        size: 1.2,
                        color: AppColors.textColor4,
                        fontWeightName: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CustText(
                    name: task['type'] ?? '',
                    size: 1.2,
                    color: AppColors.textColor4,
                    fontWeightName: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustText(
                        name: showUpdatedTime ? 'Assigned Department' : 'Created By',
                        size: 1.2,
                        color: AppColors.textColor4,
                      ),
                      const SizedBox(height: 4),
                      CustText(
                        name: (showUpdatedTime ? task['department'] : task['createdBy']) ?? '',
                        size: 1.6,
                        fontWeightName: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustText(
                        name: showUpdatedTime ? 'Created On' : 'Due On',
                        size: 1.2,
                        color: AppColors.textColor4,
                      ),
                      const SizedBox(height: 4),
                      CustText(
                        name: (showUpdatedTime ? task['createdOn'] : task['dueOn']) ?? '',
                        size: 1.6,
                        fontWeightName: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CustText(
                        name: 'View Details',
                        size: 1.4,
                        color: AppColors.blue,
                        fontWeightName: FontWeight.w500,
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: AppColors.blue,
                      ),
                    ],
                  ),
                ),
                if (showUpdatedTime)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.history_outlined, size: 14, color: AppColors.textColor4),
                      const SizedBox(width: 4),
                      CustText(
                        name: 'Updated ${task['updatedAt'] ?? ''}',
                        size: 1.2,
                        color: AppColors.textColor4,
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

