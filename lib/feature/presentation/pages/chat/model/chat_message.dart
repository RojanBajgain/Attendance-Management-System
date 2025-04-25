// chat_message_model.dart
class ChatMessage {
  final int id;
  final int sender;
  final int receiver;
  final String message;
  final DateTime timestamp;
  final bool hasRead;
  final String? mediaUrl;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.message,
    required this.timestamp,
    required this.hasRead,
    this.mediaUrl,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      sender: json['sender'] is int ? json['sender'] : json['sender']['id'],
      receiver:
          json['receiver'] is int ? json['receiver'] : json['receiver']['id'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      hasRead: json['has_read'] ?? false,
      mediaUrl: json['media_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'has_read': hasRead,
      'media_url': mediaUrl,
    };
  }
}
