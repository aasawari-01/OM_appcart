import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/user_profile_model.dart';
import '../model/master_model.dart';

class UserProfileCacheService {
  static const String _profileBoxName = 'user_profile_data';
  static const String _masterBoxName = 'master_data';

  static const String _profileKey = 'current_profile';
  static const String _citiesKey = 'cities';
  static const String _deptsKey = 'departments';
  static const String _rolesKey = 'roles';
  static const String _designationsKey = 'designations';

  Future<Box> _getProfileBox() async {
    return await Hive.openBox(_profileBoxName);
  }

  Future<Box> _getMasterBox() async {
    return await Hive.openBox(_masterBoxName);
  }

  // Profile Data
  Future<void> saveProfile(UserProfileData data) async {
    final box = await _getProfileBox();
    await box.put(_profileKey, jsonEncode(data.toJson()));
  }

  Future<UserProfileData?> getProfile() async {
    final box = await _getProfileBox();
    final String? data = box.get(_profileKey);
    if (data != null) {
      return UserProfileData.fromJson(jsonDecode(data));
    }
    return null;
  }

  // Master Data
  Future<void> saveCities(List<MasterCity> cities) async {
    final box = await _getMasterBox();
    final data = cities.map((e) => e.toJson()).toList();
    await box.put(_citiesKey, jsonEncode(data));
  }

  Future<List<MasterCity>?> getCities() async {
    final box = await _getMasterBox();
    final String? data = box.get(_citiesKey);
    if (data != null) {
      final List<dynamic> list = jsonDecode(data);
      return list.map((e) => MasterCity.fromJson(e)).toList();
    }
    return null;
  }

  Future<void> saveDepartments(List<MasterDepartmentType> depts) async {
    final box = await _getMasterBox();
    final data = depts.map((e) => e.toJson()).toList();
    await box.put(_deptsKey, jsonEncode(data));
  }

  Future<List<MasterDepartmentType>?> getDepartments() async {
    final box = await _getMasterBox();
    final String? data = box.get(_deptsKey);
    if (data != null) {
      final List<dynamic> list = jsonDecode(data);
      return list.map((e) => MasterDepartmentType.fromJson(e)).toList();
    }
    return null;
  }

  Future<void> saveRoles(List<MasterRole> roles) async {
    final box = await _getMasterBox();
    final data = roles.map((e) => e.toJson()).toList();
    await box.put(_rolesKey, jsonEncode(data));
  }

  Future<List<MasterRole>?> getRoles() async {
    final box = await _getMasterBox();
    final String? data = box.get(_rolesKey);
    if (data != null) {
      final List<dynamic> list = jsonDecode(data);
      return list.map((e) => MasterRole.fromJson(e)).toList();
    }
    return null;
  }

  Future<void> saveDesignations(List<MasterDesignation> designations) async {
    final box = await _getMasterBox();
    final data = designations.map((e) => e.toJson()).toList();
    await box.put(_designationsKey, jsonEncode(data));
  }

  Future<List<MasterDesignation>?> getDesignations() async {
    final box = await _getMasterBox();
    final String? data = box.get(_designationsKey);
    if (data != null) {
      final List<dynamic> list = jsonDecode(data);
      return list.map((e) => MasterDesignation.fromJson(e)).toList();
    }
    return null;
  }

  Future<void> clearCache() async {
    final profileBox = await _getProfileBox();
    final masterBox = await _getMasterBox();
    await profileBox.clear();
    await masterBox.clear();
  }
}
