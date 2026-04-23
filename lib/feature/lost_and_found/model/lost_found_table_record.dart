import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../service/network_service/app_urls.dart';

class LostFoundResponse {
  final bool status;
  final String message;
  final List<LostFoundTableRecord> data;

  LostFoundResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LostFoundResponse.fromJson(Map<String, dynamic> json) => LostFoundResponse(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<LostFoundTableRecord>.from(
                json["data"].map((x) => LostFoundTableRecord.fromJson(x))),
      );
}

class LostFoundSingleResponse {
  final bool status;
  final String message;
  final LostFoundTableRecord? data;

  LostFoundSingleResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory LostFoundSingleResponse.fromJson(Map<String, dynamic> json) => LostFoundSingleResponse(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null ? null : LostFoundTableRecord.fromJson(json["data"]),
      );
}

class LostFoundTableRecord {
  final int id;
  final String docNumber;
  final String uniqueCode;
  final String registerAs;
  final int stationID;
  final DateTime? date;
  final String? passengerName;
  final String? contactNo;
  final String? articleLostPlace;
  final String? articleLost;
  final String? articleFound;
  final String? articleFoundPlace;
  final String? address;
  final String? internalNotes;
  final String? color;
  final String? category;
  final int? quantity;
  final String? estimateValue;
  final String? description;
  final int matchStatus;
  final Station? stations;
  final UserDetail? createdByDetail;
  final UserDetail? updatedByDetail;
  final bool isActive;
  final DateTime? createdAt;
  final String? remark;
  final double? matchPercentage;
  final LostFoundTableRecord? matches;
  final Map<String, dynamic>? breakdownPassCount;
  final List<FoundAttachment> foundAttachments;
  final List<History> history;
  
  // Verification fields
  final String? verifiedColor;
  final String? verifiedIdProof;
  final String? verifiedUniqueIdentification;
  final String? verifiedDescription;

  // Handover fields
  final DateTime? handoverDate;
  final String? handoverToName;
  final String? remarks;

  LostFoundTableRecord({
    required this.id,
    required this.docNumber,
    required this.uniqueCode,
    required this.registerAs,
    required this.stationID,
    this.date,
    this.passengerName,
    this.contactNo,
    this.articleLostPlace,
    this.articleLost,
    this.articleFound,
    this.articleFoundPlace,
    this.address,
    this.internalNotes,
    this.color,
    this.category,
    this.quantity,
    this.estimateValue,
    this.description,
    required this.matchStatus,
    this.stations,
    this.createdByDetail,
    this.updatedByDetail,
    required this.isActive,
    this.createdAt,
    this.remark,
    this.verifiedColor,
    this.verifiedIdProof,
    this.verifiedUniqueIdentification,
    this.verifiedDescription,
    this.handoverDate,
    this.handoverToName,
    this.remarks,
    this.matchPercentage,
    this.matches,
    this.breakdownPassCount,
    this.foundAttachments = const [],
    this.history= const []
  });

  bool get isFound => registerAs.toLowerCase() == 'found';
  
  String get displayArticleName => (isFound ? articleFound : articleLost) ?? 'N/A';
  String get displayArticlePlace => (isFound ? articleFoundPlace : articleLostPlace) ?? 'N/A';

  String get matchStatusText {
    switch (matchStatus) {
      case 1: return 'Opened';
      case 2: return 'Unmatched';
      case 3: return 'Match Found';
      case 4: return 'Verified';
      case 5: return 'Finalized';
      default: return 'Unknown';
    }
  }

  Color get matchStatusColor {
    switch (matchStatus) {
      case 1: return AppColors.blue;
      case 2: return AppColors.red;
      case 3: return AppColors.orange;
      case 4: return AppColors.green;
      case 5: return AppColors.green;
      default: return AppColors.grey;
    }
  }

  factory LostFoundTableRecord.fromJson(Map<String, dynamic> json) => LostFoundTableRecord(
        id: json["id"],
        docNumber: json["docNumber"] ?? "",
        uniqueCode: json["uniqueCode"] ?? "",
        registerAs: json["registerAs"] ?? "",
        stationID: json["stationID"] ?? 0,
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        passengerName: json["passengerName"],
        contactNo: json["contactNo"],
        articleLostPlace: json["articleLostPlace"],
        articleLost: json["articleLost"],
        articleFound: json["articleFound"],
        articleFoundPlace: json["articleFoundPlace"],
        address: json["address"],
        internalNotes: json["internalNotes"],
        color: json["color"],
        category: json["category"],
        quantity: json["quantity"],
        estimateValue: json["estimateValue"]?.toString(),
        description: json["description"],
        matchStatus: json["matchStatus"] ?? 0,
        stations: json["stations"] == null ? null : Station.fromJson(json["stations"]),
        createdByDetail: json["createdByDetail"] == null
            ? null
            : UserDetail.fromJson(json["createdByDetail"]),
        updatedByDetail: json["updatedByDetail"] == null
            ? null
            : UserDetail.fromJson(json["updatedByDetail"]),
        isActive: json["isActive"] ?? true,
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        remark: json["remark"],
        verifiedColor: json["verifiedColor"],
        verifiedIdProof: json["verifiedIdProof"],
        verifiedUniqueIdentification: json["verifiedUniqueIdentification"],
        verifiedDescription: json["verifiedDescription"],
        handoverDate: json["handoverDate"] == null ? null : DateTime.parse(json["handoverDate"]),
        handoverToName: json["handoverToName"],
        remarks: json["remarks"],
        matchPercentage: json["matchPercentage"] != null 
            ? (json["matchPercentage"] as num).toDouble() 
            : (json["score"] != null ? (json["score"] as num).toDouble() : null),
        matches: json["matches"] == null ? null : LostFoundTableRecord.fromJson(json["matches"]),
        breakdownPassCount: json["breakdownPassCount"] ?? json["breakdown"],
        foundAttachments: json["foundAttachments"] != null
            ? List<FoundAttachment>.from(
                json["foundAttachments"].map((x) => FoundAttachment.fromJson(x)))
            : (json["files"] != null
                ? List<FoundAttachment>.from(
                    json["files"].map((x) => FoundAttachment.fromPath(x)))
                : []),
        history:json["history"] != null
            ? List<History>.from(
            json["history"].map((x) => History.fromJson(x)))
            :[]
  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "docNumber": docNumber,
        "uniqueCode": uniqueCode,
        "registerAs": registerAs,
        "stationID": stationID,
        "date": date?.toIso8601String(),
        "passengerName": passengerName,
        "contactNo": contactNo,
        "articleLostPlace": articleLostPlace,
        "articleLost": articleLost,
        "articleFound": articleFound,
        "articleFoundPlace": articleFoundPlace,
        "address": address,
        "internalNotes": internalNotes,
        "color": color,
        "category": category,
        "quantity": quantity,
        "estimateValue": estimateValue,
        "description": description,
        "matchStatus": matchStatus,
        "stations": stations?.toJson(),
        "createdByDetail": createdByDetail?.toJson(),
        "updatedByDetail": updatedByDetail?.toJson(),
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "remark": remark,
        "verifiedColor": verifiedColor,
        "verifiedIdProof": verifiedIdProof,
        "verifiedUniqueIdentification": verifiedUniqueIdentification,
        "verifiedDescription": verifiedDescription,
        "handoverDate": handoverDate?.toIso8601String(),
        "handoverToName": handoverToName,
        "remarks": remarks,
        "matchPercentage": matchPercentage,
        "matches": matches?.toJson(),
        "breakdownPassCount": breakdownPassCount,
        "foundAttachments": foundAttachments.map((x) => x.toJson()).toList(),
        "history": history.map((x) => x.toJson()).toList(),
      };
}

class FoundAttachment {
  final int id;
  final String fileName;
  final String filePath; // Full URL
  final String originalPath; // Relative path from server
  final String? fileSize;
  final String? fileType;

  FoundAttachment({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.originalPath,
    this.fileSize,
    this.fileType,
  });

  factory FoundAttachment.fromJson(Map<String, dynamic> json) => FoundAttachment(
        id: json["id"],
        fileName: json["fileName"] ?? "",
        filePath: json["filePath"] ?? "",
        originalPath: json["filePath"] ?? "",
        fileSize: json["fileSize"],
        fileType: json["fileType"],
      );

  factory FoundAttachment.fromPath(String path) => FoundAttachment(
        id: 0,
        fileName: path.split('/').last,
        filePath: AppUrls.baseUrl + path,
        originalPath: path,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fileName": fileName,
        "filePath": filePath,
        "originalPath": originalPath,
        "fileSize": fileSize,
        "fileType": fileType,
      };
}

class Station {
  final int id;
  final String name;
  final String stationCode;

  Station({
    required this.id,
    required this.name,
    required this.stationCode,
  });

  factory Station.fromJson(Map<String, dynamic> json) => Station(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        stationCode: json["stationCode"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "stationCode": stationCode,
      };
}

class History {
  final int id;
  final String action;
  final String status;
  final String remark;
  final DateTime? createdAt;
  final String createdBy;

  History({
    required this.id,
    required this.action,
    required this.status,
    required this.remark,
    required this.createdAt,
    this.createdBy="",
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
    id: json["id"] ?? 0,
    action: json["action"] ?? "",
    status: json["status"] ?? "",
    remark: json["remark"] ?? "",
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    createdBy: json["createdByDetail"] != null
        ? ((json["createdByDetail"]?["firstName"] ?? "") + " " + (json["createdByDetail"]?["lastName"] ?? ""))
        : ""
  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "action": action,
        "status": status,
        "remark": remark,
        "createdAt": createdAt?.toIso8601String(),
        "createdByDetail": {
          "firstName": createdBy.split(' ').first,
          "lastName": createdBy.split(' ').length > 1 ? createdBy.split(' ').last : '',
        },
      };
}

class UserDetail {
  final int id;
  final String firstName;
  final String lastName;

  UserDetail({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        id: json["id"] ?? 0,
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
      };

  String get fullName => "$firstName $lastName";
}
