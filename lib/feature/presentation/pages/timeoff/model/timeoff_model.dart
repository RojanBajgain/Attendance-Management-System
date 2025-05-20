import 'dart:convert';

class TimeoffModel {
  int totalPages;
  int currentPage;
  int count;
  List<Datum> data;

  TimeoffModel({
    this.totalPages = 1,
    this.currentPage = 1,
    this.count = 1,
    this.data = const [],
  });

  factory TimeoffModel.fromJson(Map<String, dynamic> json) => TimeoffModel(
        totalPages: json["total_pages"] ?? 1,
        currentPage: json["current_page"] ?? 1,
        count: json["count"] ?? 1,
        data: List<Datum>.from(
          (json["data"]?["data"] ?? []).map((x) => Datum.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "total_pages": totalPages,
        "current_page": currentPage,
        "count": count,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  int? user;
  Type? type;
  int days;
  DateTime? startDate;
  DateTime? endDate;
  String? reason;
  String? comments;
  String? status;
  String? approvedBy;
  String? timestamp;
  String? username;
  String? designation;

  Datum({
    this.id = 0,
    this.user = 0,
    this.type,
    this.days = 0,
    this.startDate,
    this.endDate,
    this.reason = '',
    this.comments = '',
    this.status = '',
    this.approvedBy = '',
    this.timestamp = '',
    this.username = '',
    this.designation = '',
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? 0,
        user: json["user"],
        type: json["type"] != null ? Type.fromJson(json["type"]) : null,
        days: json["days"] ?? 0,
        startDate: json["start_date"] != null
            ? DateTime.tryParse(json["start_date"])
            : null,
        endDate: json["end_date"] != null
            ? DateTime.tryParse(json["end_date"])
            : null,
        reason: json["reason"],
        comments: json["comments"],
        status: json["status"],
        approvedBy: json["approved_by"],
        timestamp: json["timestamp"],
        username: json["username"],
        designation: json["designation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "type": type?.toJson(),
        "days": days,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "reason": reason,
        "comments": comments,
        "status": status,
        "approved_by": approvedBy,
        "timestamp": timestamp,
        "username": username,
        "designation": designation,
      };
}

class Type {
  int? id;
  String? name;
  String? compensation;
  String? units;
  int? days;

  Type({
    this.id = 0,
    this.name = '',
    this.compensation = '',
    this.units = '',
    this.days = 0,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        id: json["id"] ?? 0,
        name: json["name"],
        compensation: json["compensation"],
        units: json["units"],
        days: json["days"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "compensation": compensation,
        "units": units,
        "days": days,
      };
}
