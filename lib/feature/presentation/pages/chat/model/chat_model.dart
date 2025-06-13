class ChatModel {
  int? id;
  String? document;
  Sender? receiver;
  Sender? sender;
  Department? department;
  String? message;
  DateTime? timestamp;
  bool? hasRead;
  dynamic mediaUrl;

  ChatModel({
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

  ChatModel copyWith({
    int? id,
    String? document,
    Sender? receiver,
    Sender? sender,
    Department? department,
    String? message,
    DateTime? timestamp,
    bool? hasRead,
    dynamic mediaUrl,
  }) {
    return ChatModel(
      id: id ?? this.id,
      document: document ?? this.document,
      receiver: receiver ?? this.receiver,
      sender: sender ?? this.sender,
      department: department ?? this.department,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      hasRead: hasRead ?? this.hasRead,
      mediaUrl: mediaUrl ?? this.mediaUrl,
    );
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"],
        document: json["document"],
        receiver:
            json["receiver"] != null ? Sender.fromJson(json["receiver"]) : null,
        sender: json["sender"] != null ? Sender.fromJson(json["sender"]) : null,
        department: json["department"] != null
            ? Department.fromJson(json["department"])
            : null,
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
        "department": department?.toJson(),
        "message": message,
        "timestamp": timestamp?.toIso8601String(),
        "has_read": hasRead,
        "media_url": mediaUrl,
      };
}

class Department {
  int? id;
  String? name;

  Department({
    this.id,
    this.name,
  });

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Sender {
  int? id;
  String? user;
  bool? isActive;
  String? profileImage;

  Sender({
    this.id,
    this.user,
    this.isActive,
    this.profileImage,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
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
