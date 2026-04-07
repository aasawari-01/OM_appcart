import 'package:om_appcart/utils/app_date_utils.dart';

class UserProfileResponse {
  final bool status;
  final String? message;
  final List<UserProfileData>? data;
  final int? totalRecords;

  UserProfileResponse({
    required this.status,
    this.message,
    this.data,
    this.totalRecords,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String?,
      data: (json['data'] is List)
          ? (json['data'] as List<dynamic>)
              .map((e) => UserProfileData.fromJson(e as Map<String, dynamic>))
              .toList()
          : (json['data'] != null
              ? [UserProfileData.fromJson(json['data'] as Map<String, dynamic>)]
              : null),
      totalRecords: json['totalRecords'] as int?,
    );
  }
}

class UserProfileData {
  final int id;
  final String firstName;
  final String lastName;
  final List<int> cityIDs;
  final List<int> departmentIDs;
  final List<int> stationIDs;
  final int roleID;
  final int designationID;
  final String emailID;
  final String? contactNo;
  final String? deviceToken;
  final String? profilePic;
  final String? thumbnailSmall;
  final String? thumbnailMedium;
  final String? thumbnailLarge;
  final bool isActive;
  final Map<String, dynamic>? permissions;
  final ThemeConfig? theme;
  final String uniqueCode;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final UserDetails? userDetails;
  final List<City>? cities;
  final List<Department>? departments;
  final Role? role;
  final Designation? designation;
  final List<Station>? stations;

  UserProfileData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.cityIDs,
    required this.departmentIDs,
    required this.stationIDs,
    required this.roleID,
    required this.designationID,
    required this.emailID,
    this.contactNo,
    this.deviceToken,
    this.profilePic,
    this.thumbnailSmall,
    this.thumbnailMedium,
    this.thumbnailLarge,
    required this.isActive,
    this.permissions,
    this.theme,
    required this.uniqueCode,
    this.updatedAt,
    this.createdAt,
    this.userDetails,
    this.cities,
    this.departments,
    this.role,
    this.designation,
    this.stations,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      id: json['id'] as int? ?? 0,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      cityIDs: (json['cityIDs'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
      departmentIDs: (json['departmentIDs'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
      stationIDs: (json['stationIDs'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
      roleID: json['roleID'] as int? ?? 0,
      designationID: json['designationID'] as int? ?? 0,
      emailID: json['emailID'] as String? ?? '',
      contactNo: json['contactNo'] as String?,
      deviceToken: json['deviceToken'] as String?,
      profilePic: json['profilePic'].toString() == "{}" ? null : json['profilePic'] as String?,
      thumbnailSmall: json['thumbnailSmall'].toString() == "{}" ? null : json['thumbnailSmall'] as String?,
      thumbnailMedium: json['thumbnailMedium'].toString() == "{}" ? null : json['thumbnailMedium'] as String?,
      thumbnailLarge: json['thumbnailLarge'].toString() == "{}" ? null : json['thumbnailLarge'] as String?,
      isActive: json['isActive'] as bool? ?? false,
      permissions: json['permissions'] as Map<String, dynamic>?,
      theme: json['theme'] == null ? null : ThemeConfig.fromJson(json['theme'] as Map<String, dynamic>),
      uniqueCode: json['uniqueCode'] as String? ?? '',
      updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] as String),
      createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
      userDetails: (json['userDetail'] ?? json['user_details']) == null ? null : UserDetails.fromJson((json['userDetail'] ?? json['user_details']) as Map<String, dynamic>),
      cities: (json['cities'] as List<dynamic>?)?.map((e) => City.fromJson(e as Map<String, dynamic>)).toList(),
      departments: (json['departments'] as List<dynamic>?)?.map((e) => Department.fromJson(e as Map<String, dynamic>)).toList(),
      role: json['role'] == null ? null : Role.fromJson(json['role'] as Map<String, dynamic>),
      designation: json['designation'] == null ? null : Designation.fromJson(json['designation'] as Map<String, dynamic>),
      stations: (json['stations'] as List<dynamic>?)?.map((e) => Station.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'cityIDs': cityIDs,
      'departmentIDs': departmentIDs,
      'stationIDs': stationIDs,
      'roleID': roleID,
      'designationID': designationID,
      'emailID': emailID,
      'contactNo': contactNo,
      'deviceToken': deviceToken,
      'profilePic': profilePic,
      'thumbnailSmall': thumbnailSmall,
      'thumbnailMedium': thumbnailMedium,
      'thumbnailLarge': thumbnailLarge,
      'isActive': isActive,
      'permissions': permissions,
      'theme': theme?.toJson(),
      'uniqueCode': uniqueCode,
      'updatedAt': updatedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'userDetail': userDetails?.toJson(),
      'cities': cities?.map((e) => e.toJson()).toList(),
      'departments': departments?.map((e) => e.toJson()).toList(),
      'role': role?.toJson(),
      'designation': designation?.toJson(),
      'stations': stations?.map((e) => e.toJson()).toList(),
    };
  }
}

class UserDetails {
  final String? dateOfBirth;
  final String? dateOfJoining;
  final String? employeeID;
  final String? birthPlace;
  final String? bloodGroup;
  final String? currentAddress;
  final String? permanentAddress;
  final String? alternateContactNo;
  final String? gender;
  final String? aadharCardNo;
  final String? panCardNo;
  final String? shiftType;

  UserDetails({
    this.dateOfBirth,
    this.dateOfJoining,
    this.employeeID,
    this.birthPlace,
    this.bloodGroup,
    this.currentAddress,
    this.permanentAddress,
    this.alternateContactNo,
    this.gender,
    this.aadharCardNo,
    this.panCardNo,
    this.shiftType,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      dateOfBirth: AppDateUtils.parseFromServer(json['dateOfBirth'] as String?),
      dateOfJoining: AppDateUtils.parseFromServer(json['dateOfJoining'] as String?),
      employeeID: json['employeeID'] as String?,
      birthPlace: json['birthPlace'] as String?,
      bloodGroup: json['bloodGroup'] as String?,
      currentAddress: json['currentAddress'] as String?,
      permanentAddress: json['permanentAddress'] as String?,
      alternateContactNo: json['alternateContactNo'] as String?,
      gender: json['gender'] as String?,
      aadharCardNo: json['aadharCardNo'] as String?,
      panCardNo: json['panCardNo'] as String?,
      shiftType: json['shiftType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateOfBirth': dateOfBirth,
      'dateOfJoining': dateOfJoining,
      'employeeID': employeeID,
      'birthPlace': birthPlace,
      'bloodGroup': bloodGroup,
      'currentAddress': currentAddress,
      'permanentAddress': permanentAddress,
      'alternateContactNo': alternateContactNo,
      'gender': gender,
      'aadharCardNo': aadharCardNo,
      'panCardNo': panCardNo,
      'shiftType': shiftType,
    };
  }
}

class City {
  final String name;
  final String cityCode;
  final bool isActive;
  final int id;

  City({required this.name, required this.cityCode, required this.isActive, required this.id});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] as String? ?? '',
      cityCode: json['cityCode'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      id: json['id'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cityCode': cityCode,
      'isActive': isActive,
      'id': id,
    };
  }
}

class Department {
  final String name;
  final String departmentCode;
  final bool isActive;
  final int id;

  Department({required this.name, required this.departmentCode, required this.isActive, required this.id});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      name: json['name'] as String? ?? '',
      departmentCode: json['departmentCode'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      id: json['id'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'departmentCode': departmentCode,
      'isActive': isActive,
      'id': id,
    };
  }
}

class Role {
  final String name;
  final String roleCode;
  final bool isActive;
  final int id;

  Role({required this.name, required this.roleCode, required this.isActive, required this.id});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      name: json['name'] as String? ?? '',
      roleCode: json['roleCode'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      id: json['id'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'roleCode': roleCode,
      'isActive': isActive,
      'id': id,
    };
  }
}

class Designation {
  final String name;
  final String designationCode;
  final bool isActive;
  final int id;

  Designation({required this.name, required this.designationCode, required this.isActive, required this.id});

  factory Designation.fromJson(Map<String, dynamic> json) {
    return Designation(
      name: json['name'] as String? ?? '',
      designationCode: json['designationCode'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      id: json['id'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'designationCode': designationCode,
      'isActive': isActive,
      'id': id,
    };
  }
}

class Station {
  final String name;
  final String stationCode;
  final int cityID;
  final bool isActive;
  final int id;

  Station({required this.name, required this.stationCode, required this.cityID, required this.isActive, required this.id});

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      name: json['name'] as String? ?? '',
      stationCode: json['stationCode'] as String? ?? '',
      cityID: json['cityID'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? false,
      id: json['id'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'stationCode': stationCode,
      'cityID': cityID,
      'isActive': isActive,
      'id': id,
    };
  }
}

class ThemeConfig {
  final String? name;
  final String? code;
  final String? image;

  ThemeConfig({this.name, this.code, this.image});

  factory ThemeConfig.fromJson(Map<String, dynamic> json) {
    return ThemeConfig(
      name: json['name'] as String?,
      code: json['code'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'image': image,
    };
  }
}
