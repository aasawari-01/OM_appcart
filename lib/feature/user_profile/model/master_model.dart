class MasterCity {
  final String name;
  final String cityCode;
  final bool isActive;
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int isDeleted;

  MasterCity({
    required this.name,
    required this.cityCode,
    required this.isActive,
    required this.id,
    this.createdAt,
    this.updatedAt,
    required this.isDeleted,
  });

  factory MasterCity.fromJson(Map<String, dynamic> json) {
    return MasterCity(
      name: json['name'] as String? ?? '',
      cityCode: json['cityCode'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      id: json['id'] as int? ?? 0,
      createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] as String),
      isDeleted: json['isDeleted'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cityCode': cityCode,
      'isActive': isActive,
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }
}

class MasterDepartmentType {
  final String name;
  final bool isActive;
  final String departmentTypeCode;
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int isDeleted;

  MasterDepartmentType({
    required this.name,
    required this.isActive,
    required this.departmentTypeCode,
    required this.id,
    this.createdAt,
    this.updatedAt,
    required this.isDeleted,
  });

  factory MasterDepartmentType.fromJson(Map<String, dynamic> json) {
    return MasterDepartmentType(
      name: json['name'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      departmentTypeCode: json['departmentTypeCode'] as String? ?? '',
      id: json['id'] as int? ?? 0,
      createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] as String),
      isDeleted: json['isDeleted'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isActive': isActive,
      'departmentTypeCode': departmentTypeCode,
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }
}

class MasterRole {
  final String name;
  final String roleCode;
  final bool isActive;
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int isDeleted;

  MasterRole({
    required this.name,
    required this.roleCode,
    required this.isActive,
    required this.id,
    this.createdAt,
    this.updatedAt,
    required this.isDeleted,
  });

  factory MasterRole.fromJson(Map<String, dynamic> json) {
    return MasterRole(
      name: json['name'] as String? ?? '',
      roleCode: json['roleCode'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      id: json['id'] as int? ?? 0,
      createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] as String),
      isDeleted: json['isDeleted'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'roleCode': roleCode,
      'isActive': isActive,
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }
}

class MasterDesignation {
  final String name;
  final String designationCode;
  final bool isActive;
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int isDeleted;

  MasterDesignation({
    required this.name,
    required this.designationCode,
    required this.isActive,
    required this.id,
    this.createdAt,
    this.updatedAt,
    required this.isDeleted,
  });

  factory MasterDesignation.fromJson(Map<String, dynamic> json) {
    return MasterDesignation(
      name: json['name'] as String? ?? '',
      designationCode: json['designationCode'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      id: json['id'] as int? ?? 0,
      createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] as String),
      isDeleted: json['isDeleted'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'designationCode': designationCode,
      'isActive': isActive,
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }
}

class CityResponse {
  final bool status;
  final String? message;
  final List<MasterCity> data;
  final int totalRecords;

  CityResponse({
    required this.status,
    this.message,
    required this.data,
    required this.totalRecords,
  });

  factory CityResponse.fromJson(Map<String, dynamic> json) {
    return CityResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => MasterCity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalRecords: json['totalRecords'] as int? ?? 0,
    );
  }
}

class DepartmentTypeResponse {
  final bool status;
  final String? message;
  final List<MasterDepartmentType> data;
  final int totalRecords;

  DepartmentTypeResponse({
    required this.status,
    this.message,
    required this.data,
    required this.totalRecords,
  });

  factory DepartmentTypeResponse.fromJson(Map<String, dynamic> json) {
    return DepartmentTypeResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => MasterDepartmentType.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalRecords: json['totalRecords'] as int? ?? 0,
    );
  }
}

class RoleResponse {
  final bool status;
  final String? message;
  final List<MasterRole> data;
  final int totalRecords;

  RoleResponse({
    required this.status,
    this.message,
    required this.data,
    required this.totalRecords,
  });

  factory RoleResponse.fromJson(Map<String, dynamic> json) {
    return RoleResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => MasterRole.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalRecords: json['totalRecords'] as int? ?? 0,
    );
  }
}

class DesignationResponse {
  final bool status;
  final String? message;
  final List<MasterDesignation> data;
  final int totalRecords;

  DesignationResponse({
    required this.status,
    this.message,
    required this.data,
    required this.totalRecords,
  });

  factory DesignationResponse.fromJson(Map<String, dynamic> json) {
    return DesignationResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => MasterDesignation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalRecords: json['totalRecords'] as int? ?? 0,
    );
  }
}
