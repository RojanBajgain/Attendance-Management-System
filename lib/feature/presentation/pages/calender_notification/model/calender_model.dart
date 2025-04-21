import 'dart:convert';

class EventCalenderModel {
  int id;
  String? name;
  DateTime? startDate;
  DateTime? endDate;
  EventType? type;
  String? description;
  String? createdBy;

  EventCalenderModel({
    this.id = 0,
    this.name,
    this.startDate,
    this.endDate,
    this.type,
    this.description,
    this.createdBy,
  });

  factory EventCalenderModel.fromJson(Map<String, dynamic> json) =>
      EventCalenderModel(
        id: json["id"] ?? 0,
        name: json["name"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        type: eventTypeValues.map[json["type"]],
        description: json["description"],
        createdBy: json["created_by"],
      );
}

enum EventType { EVENT, HOLIDAY, NOTICE }

final eventTypeValues = EnumValues({
  "event": EventType.EVENT,
  "holiday": EventType.HOLIDAY,
  "notice": EventType.NOTICE,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
