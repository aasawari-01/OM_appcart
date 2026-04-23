import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/lost_found_table_record.dart';

class LostFoundCacheService {
  static const String _boxName = 'lost_found_cache';
  static const String _itemsKey = 'items';

  Future<void> saveItems(List<LostFoundTableRecord> items) async {
    final box = await Hive.openBox(_boxName);
    final List<String> encodedItems = items.map((item) => jsonEncode(item.toJson())).toList();
    await box.put(_itemsKey, encodedItems);
  }

  Future<List<LostFoundTableRecord>> getCachedItems() async {
    final box = await Hive.openBox(_boxName);
    final List<dynamic>? encodedItems = box.get(_itemsKey);
    
    if (encodedItems == null) return [];

    return encodedItems.map((item) {
      final decoded = jsonDecode(item as String);
      return LostFoundTableRecord.fromJson(decoded);
    }).toList();
  }

  Future<void> clearCache() async {
    final box = await Hive.openBox(_boxName);
    await box.clear();
  }
}
