// To parse this JSON data, do
//
//     final getFundsModel = getFundsModelFromJson(jsonString);

import 'dart:convert';



GetFundsModel getFundsModelFromJson(String str) =>
    GetFundsModel.fromJson(json.decode(str));

String getFundsModelToJson(GetFundsModel data) => json.encode(data.toJson());

class GetFundsModel {
  String? message;
  FundsData? data; // Renamed from Data to FundsData
  Status? status;

  GetFundsModel({
    this.message,
    this.data,
    this.status,
  });

  factory GetFundsModel.fromJson(Map<String, dynamic> json) => GetFundsModel(
        message: json["message"],
        data: json["data"] == null
            ? null
            : FundsData.fromJson(json["data"]), // Using FundsData
        status: json["status"] == null
            ? null
            : Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
        "status": status?.toJson(),
      };
}

class FundsData {
  // Renamed class from Data
  double? totalBalance;
  double? usedMargin;
  String? realizedPl;
  double? availableMargin;

  FundsData({
    this.totalBalance,
    this.usedMargin,
    this.realizedPl,
    this.availableMargin,
  });

  factory FundsData.fromJson(Map<String, dynamic> json) => FundsData(
        totalBalance: json["total_balance"]?.toDouble(),
        usedMargin: json["used_margin"]?.toDouble(),
        realizedPl: json["realized_pl"].toString(),
        availableMargin: json["available_margin"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "total_balance": totalBalance,
        "used_margin": usedMargin,
        "realized_pl": realizedPl,
        "available_margin": availableMargin,
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
