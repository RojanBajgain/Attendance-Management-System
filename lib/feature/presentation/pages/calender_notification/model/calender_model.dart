import 'dart:convert';

List<EventCalenderModel> eventCalenderModelFromJson(String str) =>
    List<EventCalenderModel>.from(
        json.decode(str).map((x) => EventCalenderModel.fromJson(x)));

String eventCalenderModelToJson(List<EventCalenderModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EventCalenderModel {
  int id;
  String? name;
  DateTime? startDate;
  DateTime? endDate;
  String? type;
  String? user;
  String? title;
  String? remarks;
  String? description;
  String? createdBy;

  EventCalenderModel({
    this.id = 0,
    this.name,
    this.startDate,
    this.endDate,
    this.type,
    this.user,
    this.title,
    this.remarks,
    this.description,
    this.createdBy,
  });

  factory EventCalenderModel.fromJson(Map<String, dynamic> json) =>
      EventCalenderModel(
        id: json["id"] ?? 0,
        name: json["name"],
        startDate: json["start_date"] != null
            ? DateTime.tryParse(json["start_date"])
            : null,
        endDate: json["end_date"] != null
            ? DateTime.tryParse(json["end_date"])
            : null,
        type: json["type"],
        user: json["user"],
        title: json["title"],
        remarks: json["remarks"],
        description: json["description"],
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "type": type,
        "user": user,
        "title": title,
        "remarks": remarks,
        "description": description,
        "created_by": createdBy,
      };
}
