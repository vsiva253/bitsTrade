// To parse this JSON data, do
//
//     final subscriptionHistory = subscriptionHistoryFromJson(jsonString);

import 'dart:convert';

SubscriptionHistory subscriptionHistoryFromJson(String str) => SubscriptionHistory.fromJson(json.decode(str));

String subscriptionHistoryToJson(SubscriptionHistory data) => json.encode(data.toJson());

class SubscriptionHistory {
    String? message;
    List<Datum>? data;
    Status? status;

    SubscriptionHistory({
        this.message,
        this.data,
        this.status,
    });

    factory SubscriptionHistory.fromJson(Map<String, dynamic> json) => SubscriptionHistory(
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status?.toJson(),
    };
}

class Datum {
    String? id;
    String? status;
    int? startDate;
    int? endDate;
    String? plan;
    String? trading;

    Datum({
        this.id,
        this.status,
        this.startDate,
        this.endDate,
        this.plan,
        this.trading,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        status: json["status"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        plan: json["plan"],
        trading: json["trading"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "start_date": startDate,
        "end_date": endDate,
        "plan": plan,
        "trading": trading,
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
