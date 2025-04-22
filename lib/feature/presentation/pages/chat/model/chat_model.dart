import 'dart:convert';

class ChatModel {
  int id;
  dynamic document;
  Receiver? receiver;
  Receiver? sender;
  dynamic department;
  String? message;
  DateTime? timestamp;
  bool? hasRead;
  dynamic mediaUrl;

  ChatModel({
    this.id = 0,
    this.document,
    this.receiver,
    this.sender,
    this.department,
    this.message,
    this.timestamp,
    this.hasRead,
    this.mediaUrl,
  });

  factory ChatModel.fromRawJson(String str) =>
      ChatModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"] ?? 0,
        document: json["document"],
        receiver: json["receiver"] != null
            ? Receiver.fromJson(json["receiver"])
            : null,
        sender:
            json["sender"] != null ? Receiver.fromJson(json["sender"]) : null,
        department: json["department"],
        message: json["message"],
        timestamp: json["timestamp"] != null
            ? DateTime.tryParse(json["timestamp"])
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
  int id;
  String? user;
  bool? isActive;
  String? profileImage;

  Receiver({
    this.id = 0,
    this.user,
    this.isActive,
    this.profileImage,
  });

  factory Receiver.fromRawJson(String str) =>
      Receiver.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
        id: json["id"] ?? 0,
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
