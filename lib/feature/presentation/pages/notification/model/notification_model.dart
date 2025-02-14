import 'dart:convert';

class NotificationModel {
  int totalPages;
  int currentPage;
  int count;
  List<Datum> data;

  NotificationModel({
    this.totalPages = 0,
    this.currentPage = 0,
    this.count = 0,
    this.data = const [],
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        totalPages: json["total_pages"] ?? 0,
        currentPage: json["current_page"] ?? 0,
        count: json["count"] ?? 0,
        data: json["data"] != null
            ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
            : [],
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
  bool? isRead;
  String? title;
  String? description;
  bool? forAdmin;
  DateTime? timestamp;
  int user;
  String? type;

  Datum({
    this.id = 0,
    this.isRead,
    this.title,
    this.description,
    this.forAdmin,
    this.timestamp,
    this.user = 0,
    this.type,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? 0,
        isRead: json["is_read"],
        title: json["title"],
        description: json["description"],
        forAdmin: json["for_admin"],
        timestamp: json["timestamp"] != null
            ? DateTime.tryParse(json["timestamp"])
            : null,
        user: json["user"] ?? 0,
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_read": isRead,
        "title": title,
        "description": description,
        "for_admin": forAdmin,
        "timestamp": timestamp?.toIso8601String(),
        "user": user,
        "type": type,
      };
}
