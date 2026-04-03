import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../utils/responsive_helper.dart';
import '../../service/quick_actions_controller.dart';

class QuickActionsPanel extends StatelessWidget {
  final VoidCallback onClose;

  const QuickActionsPanel({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<QuickActionsController>();

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(
          right: ResponsiveHelper.spacing(context, 8),
          top: ResponsiveHelper.spacing(context, 8),
          bottom: ResponsiveHelper.spacing(context, 8),
        ),
        width: 72,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              ...ctrl.selectedActions.map(
                (a) => IconButton(
                  icon: Icon(a.icon, color: Colors.white, size: 24),
                  tooltip: a.label,
                  onPressed: () async {
                    onClose();
                    await Future.delayed(Duration.zero);
                    a.onTap();
                  },
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: onClose,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

