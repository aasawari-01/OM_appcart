class FailureCategoryType {
  final String name;
  final String failureCategoryTypeCode;
  final bool isActive;
  final int id;

  FailureCategoryType({
    required this.name,
    required this.failureCategoryTypeCode,
    required this.isActive,
    required this.id,
  });

  factory FailureCategoryType.fromJson(Map<String, dynamic> json) => FailureCategoryType(
        name: json["name"] ?? "",
        failureCategoryTypeCode: json["failureCategoryTypeCode"] ?? "",
        isActive: json["isActive"] ?? false,
        id: json["id"] ?? 0,
      );
}

class FailureLocation {
  final String name;
  final bool isActive;
  final int id;

  FailureLocation({
    required this.name,
    required this.isActive,
    required this.id,
  });

  factory FailureLocation.fromJson(Map<String, dynamic> json) => FailureLocation(
        name: json["name"] ?? "",
        isActive: json["isActive"] ?? false,
        id: json["id"] ?? 0,
      );
}

class FailureFunctionLocation {
  final String name;
  final bool isActive;
  final int id;

  FailureFunctionLocation({
    required this.name,
    required this.isActive,
    required this.id,
  });

  factory FailureFunctionLocation.fromJson(Map<String, dynamic> json) => FailureFunctionLocation(
        name: json["name"] ?? "",
        isActive: json["isActive"] ?? false,
        id: json["id"] ?? 0,
      );
}

class FailureSubLocation {
  final String name;
  final int locationID;
  final bool isActive;
  final int id;

  FailureSubLocation({
    required this.name,
    required this.locationID,
    required this.isActive,
    required this.id,
  });

  factory FailureSubLocation.fromJson(Map<String, dynamic> json) => FailureSubLocation(
        name: json["name"] ?? "",
        locationID: json["locationID"] ?? 0,
        isActive: json["isActive"] ?? false,
        id: json["id"] ?? 0,
      );
}

// Response Wrappers
class FailureCategoryResponse {
  final bool status;
  final String message;
  final List<FailureCategoryType> data;

  FailureCategoryResponse({required this.status, required this.message, required this.data});

  factory FailureCategoryResponse.fromJson(Map<String, dynamic> json) => FailureCategoryResponse(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<FailureCategoryType>.from(json["data"].map((x) => FailureCategoryType.fromJson(x))),
      );
}

class FailureLocationResponse {
  final bool status;
  final String message;
  final List<FailureLocation> data;

  FailureLocationResponse({required this.status, required this.message, required this.data});

  factory FailureLocationResponse.fromJson(Map<String, dynamic> json) => FailureLocationResponse(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<FailureLocation>.from(json["data"].map((x) => FailureLocation.fromJson(x))),
      );
}

class FailureFunctionLocationResponse {
  final bool status;
  final String message;
  final List<FailureFunctionLocation> data;

  FailureFunctionLocationResponse({required this.status, required this.message, required this.data});

  factory FailureFunctionLocationResponse.fromJson(Map<String, dynamic> json) => FailureFunctionLocationResponse(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<FailureFunctionLocation>.from(json["data"].map((x) => FailureFunctionLocation.fromJson(x))),
      );
}

class FailureSubLocationResponse {
  final bool status;
  final String message;
  final List<FailureSubLocation> data;

  FailureSubLocationResponse({required this.status, required this.message, required this.data});

  factory FailureSubLocationResponse.fromJson(Map<String, dynamic> json) => FailureSubLocationResponse(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<FailureSubLocation>.from(json["data"].map((x) => FailureSubLocation.fromJson(x))),
      );
}

class ObjectPart {
  final String description;
  final String grpCode;
  final String code;
  final bool isActive;
  final int id;

  ObjectPart({
    required this.description,
    required this.grpCode,
    required this.code,
    required this.isActive,
    required this.id,
  });

  factory ObjectPart.fromJson(Map<String, dynamic> json) => ObjectPart(
        description: json["description"] ?? "",
        grpCode: json["grpCode"] ?? "",
        code: json["code"] ?? "",
        isActive: json["isActive"] ?? false,
        id: json["id"] ?? 0,
      );
}

class ObjectPartResponse {
  final bool status;
  final String message;
  final List<ObjectPart> data;

  ObjectPartResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ObjectPartResponse.fromJson(Map<String, dynamic> json) => ObjectPartResponse(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<ObjectPart>.from(json["data"].map((x) => ObjectPart.fromJson(x))),
      );
}

class Fault {
  final String description;
  final String grpCode;
  final String code;
  final bool isActive;
  final int id;

  Fault({
    required this.description,
    required this.grpCode,
    required this.code,
    required this.isActive,
    required this.id,
  });

  factory Fault.fromJson(Map<String, dynamic> json) => Fault(
        description: json["description"] ?? "",
        grpCode: json["grpCode"] ?? "",
        code: json["code"] ?? "",
        isActive: json["isActive"] ?? false,
        id: json["id"] ?? 0,
      );
}

class FaultResponse {
  final bool status;
  final String message;
  final List<Fault> data;

  FaultResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FaultResponse.fromJson(Map<String, dynamic> json) => FaultResponse(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<Fault>.from(json["data"].map((x) => Fault.fromJson(x))),
      );
}

class RootCause {
  final String description;
  final String grpCode;
  final String code;
  final bool isActive;
  final int id;

  RootCause({
    required this.description,
    required this.grpCode,
    required this.code,
    required this.isActive,
    required this.id,
  });

  factory RootCause.fromJson(Map<String, dynamic> json) => RootCause(
        description: json["description"] ?? "",
        grpCode: json["grpCode"] ?? "",
        code: json["code"] ?? "",
        isActive: json["isActive"] ?? false,
        id: json["id"] ?? 0,
      );
}

class RootCauseResponse {
  final bool status;
  final String message;
  final List<RootCause> data;

  RootCauseResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RootCauseResponse.fromJson(Map<String, dynamic> json) => RootCauseResponse(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<RootCause>.from(json["data"].map((x) => RootCause.fromJson(x))),
      );
}

class FailureMaterial {
  final String name;
  final String type;
  final String description;
  final String grpCode;
  final String code;
  final bool isActive;
  final int id;

  FailureMaterial({
    required this.name,
    required this.type,
    required this.description,
    required this.grpCode,
    required this.code,
    required this.isActive,
    required this.id,
  });

  factory FailureMaterial.fromJson(Map<String, dynamic> json) => FailureMaterial(
        name: json["name"] ?? "",
        type: json["type"] ?? "",
        description: json["description"] ?? "",
        grpCode: json["grpCode"] ?? "",
        code: json["code"] ?? "",
        isActive: json["isActive"] ?? false,
        id: json["id"] ?? 0,
      );
}

class FailureMaterialResponse {
  final bool status;
  final String message;
  final List<FailureMaterial> data;

  FailureMaterialResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FailureMaterialResponse.fromJson(Map<String, dynamic> json) => FailureMaterialResponse(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<FailureMaterial>.from(json["data"].map((x) => FailureMaterial.fromJson(x))),
      );
}

class FailureActionTaken {
  final String description;
  final String grpCode;
  final String code;
  final bool isActive;
  final int id;

  FailureActionTaken({
    required this.description,
    required this.grpCode,
    required this.code,
    required this.isActive,
    required this.id,
  });

  factory FailureActionTaken.fromJson(Map<String, dynamic> json) => FailureActionTaken(
        description: json["description"] ?? "",
        grpCode: json["grpCode"] ?? "",
        code: json["code"] ?? "",
        isActive: json["isActive"] ?? false,
        id: json["id"] ?? 0,
      );
}

class FailureActionTakenResponse {
  final bool status;
  final String message;
  final List<FailureActionTaken> data;

  FailureActionTakenResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FailureActionTakenResponse.fromJson(Map<String, dynamic> json) =>
      FailureActionTakenResponse(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<FailureActionTaken>.from(
                json["data"].map((x) => FailureActionTaken.fromJson(x))),
      );
}

class StoreLocation {
  final int cityID;
  final String description;
  final String grpCode;
  final String code;
  final bool isActive;
  final int id;

  StoreLocation({
    required this.cityID,
    required this.description,
    required this.grpCode,
    required this.code,
    required this.isActive,
    required this.id,
  });

  factory StoreLocation.fromJson(Map<String, dynamic> json) => StoreLocation(
        cityID: json["cityID"] ?? 0,
        description: json["description"] ?? "",
        grpCode: json["grpCode"] ?? "",
        code: json["code"] ?? "",
        isActive: json["isActive"] ?? false,
        id: json["id"] ?? 0,
      );
}

class StoreLocationResponse {
  final bool status;
  final String message;
  final List<StoreLocation> data;

  StoreLocationResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory StoreLocationResponse.fromJson(Map<String, dynamic> json) => StoreLocationResponse(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<StoreLocation>.from(json["data"].map((x) => StoreLocation.fromJson(x))),
      );
}
