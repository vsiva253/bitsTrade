// To parse this JSON data, do
//
//     final parentData = parentDataFromJson(jsonString);

import 'dart:convert';

ParentData parentDataFromJson(String str) => ParentData.fromJson(json.decode(str));

String parentDataToJson(ParentData data) => json.encode(data.toJson());

class ParentData {
  String? message;
  Data? data;
  Status? status;

  ParentData({
    this.message,
    this.data,
    this.status,
  });

  factory ParentData.fromJson(Map<String, dynamic> json) => ParentData(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
        "status": status?.toJson(),
      };
}

class Data {
  String? id;
  String? broker;
  String? userId;
  String? loginPassword;
  String? totpScanKey;
  String? apiKey;
  String? apiSecret;
  String? nameTag;
  bool? withApi;
  bool? loginStatus;
  String? redirectUrl;
  String? pin;
  String? mobile; // Add the 'mobile' field

  Data({
    this.id,
    this.broker,
    this.userId,
    this.loginPassword,
    this.totpScanKey,
    this.apiKey,
    this.apiSecret,
    this.nameTag,
    this.withApi,
    this.loginStatus,
    this.redirectUrl,
    this.pin,
    this.mobile,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        broker: json["broker"],
        userId: json["user_id"],
        loginPassword: json["login_password"],
        totpScanKey: json["totp_scan_key"],
        apiKey: json["api_key"],
        apiSecret: json["api_secret"],
        nameTag: json["name_tag"],
        withApi: json["with_api"],
        loginStatus: json["login_status"], // Deserialize 'login_status'
        redirectUrl: json["redirect_url"], // Deserialize 'redirect_url'
        pin: json["pin"], // Deserialize 'pin'
        mobile: json["mobile"], // Deserialize 'mobile'
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "broker": broker,
        "user_id": userId,
        "login_password": loginPassword,
        "totp_scan_key": totpScanKey,
        "api_key": apiKey,
        "api_secret": apiSecret,
        "name_tag": nameTag,
        "with_api": withApi,
        "login_status": loginStatus, // Serialize 'login_status'
        "redirect_url": redirectUrl, // Serialize 'redirect_url'
        "pin": pin, // Serialize 'pin'
        "mobile": mobile, // Serialize 'mobile'
      };
}

class Status {
  String? type;
  String? message;

  Status({
    this.type,
    this.message,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        type: json["type"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "message": message,
      };
}