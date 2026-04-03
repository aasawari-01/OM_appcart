import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'quick_actions_registry.dart';

class QuickActionsController extends GetxController {
  static const _prefsKey = 'quick_actions_ids';

  final List<QuickActionDefinition> allActions = buildAllQuickActions();
  final selectedActionIds = <String>[].obs;

  List<QuickActionDefinition> get selectedActions =>
      allActions.where((a) => selectedActionIds.contains(a.id)).toList();

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    selectedActionIds.assignAll(prefs.getStringList(_prefsKey) ?? <String>[]);
  }

  Future<void> toggleAction(String id) async {
    if (selectedActionIds.contains(id)) {
      selectedActionIds.remove(id);
    } else {
      selectedActionIds.add(id);
    }
    selectedActionIds.refresh();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, selectedActionIds);
  }

  /// Called from drawer: pin/unpin a menu item as a quick action.
  Future<void> pinOrUnpinMenuItem({
    required String id,
    required String label,
    required IconData icon,
    required Widget Function() screenBuilder,
  }) async {
    // Register definition if not present yet.
    final exists = allActions.any((a) => a.id == id);
    if (!exists) {
      allActions.add(
        QuickActionDefinition(
          id: id,
          label: label,
          icon: icon,
          onTap: () => Get.to(() => screenBuilder(), preventDuplicates: false),
        ),
      );
    }

    await toggleAction(id);
  }
}


