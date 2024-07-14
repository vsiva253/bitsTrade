// To parse this JSON data, do
//
//     final parentPositionsModel = parentPositionsModelFromJson(jsonString);

import 'dart:convert';

ParentPositionsModel parentPositionsModelFromJson(String str) =>
    ParentPositionsModel.fromJson(json.decode(str));

String parentPositionsModelToJson(ParentPositionsModel data) =>
    json.encode(data.toJson());

class ParentPositionsModel {
  String? message;
  PositionsData? data; // Renamed from Data to PositionsData
  Status? status;

  ParentPositionsModel({
    this.message,
    this.data,
    this.status,
  });

  factory ParentPositionsModel.fromJson(Map<String, dynamic> json) =>
      ParentPositionsModel(
        message: json["message"],
        data: json["data"] == null
            ? null
            : PositionsData.fromJson(json["data"]), // Use PositionsData
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

class PositionsData { // Renamed class from Data
  List<Position>? positions;
  double? total;

  PositionsData({
    this.positions,
    this.total,
  });

  factory PositionsData.fromJson(Map<String, dynamic> json) => PositionsData(
        positions: json["positions"] == null
            ? []
            : List<Position>.from(
                json["positions"]!.map((x) => Position.fromJson(x))),
        total: json["total"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "positions": positions == null
            ? []
            : List<dynamic>.from(positions!.map((x) => x.toJson())),
        "total": total,
      };
}

class Position {
    String? instrument;
    String? orderType;
    int? quantity;
    double? avgPrice;
    double? ltp;
    double? pnl;

    Position({
        this.instrument,
        this.orderType,
        this.quantity,
        this.avgPrice,
        this.ltp,
        this.pnl,
    });

    factory Position.fromJson(Map<String, dynamic> json) => Position(
        instrument: json["instrument"],
        orderType: json["OrderType"],
        quantity: json["quantity"],
        avgPrice: json["avg_price"]?.toDouble(),
        ltp: json["ltp"]?.toDouble(),
        pnl: json["pnl"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "instrument": instrument,
        "OrderType": orderType,
        "quantity": quantity,
        "avg_price": avgPrice,
        "ltp": ltp,
        "pnl": pnl,
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
