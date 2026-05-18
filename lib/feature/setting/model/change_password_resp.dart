class ChangePasswordResponse {
  final bool? status;
  final String? message;
  final dynamic data;
  final dynamic totalRecords;

  ChangePasswordResponse({
    this.status,
    this.message,
    this.data,
    this.totalRecords,
  });

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'],
      totalRecords: json['totalRecords'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
      'totalRecords': totalRecords,
    };
  }
}