import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/widgets/quick_actions_panel.dart';
import 'quick_actions_controller.dart';

class QuickActionsOverlay {
  static OverlayEntry? _entry;

  static void init() {
    Get.put(QuickActionsController(), permanent: true);
  }

  static void show() {
    if (_entry != null) return;
    final context = Get.overlayContext;
    if (context == null) return;

    _entry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: hide,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          QuickActionsPanel(onClose: hide),
        ],
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }

  /// Small handle at right edge to open the panel from anywhere.
  static Widget buildEdgeHandle() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: show,
        child: Container(
          margin: const EdgeInsets.only(right: 4),
          width: 16,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}

