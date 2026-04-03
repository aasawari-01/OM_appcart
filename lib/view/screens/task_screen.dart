import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/task_toggle_bar.dart';
import '../widgets/task_list_item.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool isAssignedSelected = true;

  final List<Map<String, dynamic>> assignedTasks = [
    {
      'id': 'INS/02-2026/2110',
      'status': 'Open',
      'priority': 'Low',
      'type': 'Station Failure',
      'createdBy': 'Avinash Rate',
      'dueOn': 'Today, 02:00 PM',
    },
    {
      'id': 'INS/02-2026/2110',
      'status': 'Open',
      'priority': 'Medium',
      'type': 'Maintenance Failure',
      'createdBy': 'Avinash Rate',
      'dueOn': 'Today, 02:00 PM',
    },
    {
      'id': 'INS/02-2026/2110',
      'status': 'Open',
      'priority': 'Very High',
      'type': 'OCC Failure',
      'createdBy': 'Avinash Rate',
      'dueOn': 'Today, 02:00 PM',
    },
  ];

  final List<Map<String, dynamic>> createdTasks = [
    {
      'id': 'INS/02-2026/2110',
      'status': 'Reassigned',
      'priority': 'Low',
      'type': 'Inspection',
      'department': 'Civil',
      'createdOn': 'Today, 02:00 PM',
      'updatedAt': '2 min ago',
    },
    {
      'id': 'INS/02-2026/2110',
      'status': 'In Process',
      'priority': 'Very High',
      'type': 'Inspection',
      'department': 'Civil',
      'createdOn': 'Today, 02:00 PM',
      'updatedAt': '1 hr ago',
    },
    {
      'id': 'INS/02-2026/2110',
      'status': 'Pending',
      'priority': 'High',
      'type': 'Inspection',
      'department': 'Civil',
      'createdOn': 'Today, 02:00 PM',
      'updatedAt': '20/02/2026',
    },
    {
      'id': 'INS/02-2026/2110',
      'status': 'Closed',
      'priority': 'High',
      'type': 'Inspection',
      'department': 'Civil',
      'createdOn': 'Today, 02:00 PM',
      'updatedAt': '20/02/2026',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white1,
      appBar: CustomAppBar(
        title: "Tasks",
        showDrawer: true,
        onLeadingPressed: () => Scaffold.of(context).openDrawer(),
      ),
      body: Column(
        children: [
          TaskToggleBar(
            isAssignedSelected: isAssignedSelected,
            onToggle: (value) {
              setState(() {
                isAssignedSelected = value;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8),
              itemCount: isAssignedSelected ? assignedTasks.length : createdTasks.length,
              itemBuilder: (context, index) {
                final task = isAssignedSelected ? assignedTasks[index] : createdTasks[index];
                return TaskListItem(
                  task: task,
                  showUpdatedTime: !isAssignedSelected,
                  onTap: () {
                    // Navigate to details
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}