import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/screens/create_failure_screen.dart';
// TODO: import other target screens as needed, e.g. failure list, dashboard, etc.

class QuickActionDefinition {
  final String id;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  QuickActionDefinition({
    required this.id,
    required this.label,
    required this.icon,
    required this.onTap,
  });
}

/// Central registry of all possible quick actions.
List<QuickActionDefinition> buildAllQuickActions() {
  return [
    QuickActionDefinition(
      id: 'create_failure',
      label: 'Create Failure',
      icon: Icons.error_outline,
      onTap: () => Get.to(() => const CreateFailureScreen()),
    ),
    // Add more actions here if needed.
  ];
}

