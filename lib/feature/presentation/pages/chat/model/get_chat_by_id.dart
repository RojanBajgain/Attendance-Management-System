import 'dart:convert';

class ChatByIdModel {
  int? id;
  String? document;
  Receiver? receiver;
  Receiver? sender;
  dynamic department;
  String? message;
  DateTime? timestamp;
  bool? hasRead;
  dynamic mediaUrl;

  ChatByIdModel({
    this.id,
    this.document,
    this.receiver,
    this.sender,
    this.department,
    this.message,
    this.timestamp,
    this.hasRead,
    this.mediaUrl,
  });

  factory ChatByIdModel.fromJson(Map<String, dynamic> json) => ChatByIdModel(
        id: json["id"],
        document: json["document"],
        receiver: json["receiver"] != null
            ? Receiver.fromJson(json["receiver"])
            : null,
        sender:
            json["sender"] != null ? Receiver.fromJson(json["sender"]) : null,
        department: json["department"],
        message: json["message"],
        timestamp: json["timestamp"] != null
            ? DateTime.parse(json["timestamp"])
            : null,
        hasRead: json["has_read"],
        mediaUrl: json["media_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "document": document,
        "receiver": receiver?.toJson(),
        "sender": sender?.toJson(),
        "department": department,
        "message": message,
        "timestamp": timestamp?.toIso8601String(),
        "has_read": hasRead,
        "media_url": mediaUrl,
      };
}

class Receiver {
  int? id;
  String? user;
  bool? isActive;
  String? profileImage;

  Receiver({
    this.id,
    this.user,
    this.isActive,
    this.profileImage,
  });

  factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
        id: json["id"],
        user: json["user"],
        isActive: json["is_active"],
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "is_active": isActive,
        "profile_image": profileImage,
      };
}
