// To parse this JSON data, do
//
//     final breakTime = breakTimeFromJson(jsonString);

import 'dart:convert';

List<BreakTime> breakTimeFromJson(String str) => List<BreakTime>.from(json.decode(str).map((x) => BreakTime.fromJson(x)));

String breakTimeToJson(List<BreakTime> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BreakTime {
    int? id;
    int? employee;
    DateTime? startTime;
    DateTime? resumeTime;
    double? totalBreakDuration;
    bool? isCompleted;

    BreakTime({
        this.id,
        this.employee,
        this.startTime,
        this.resumeTime,
        this.totalBreakDuration,
        this.isCompleted,
    });

    factory BreakTime.fromJson(Map<String, dynamic> json) => BreakTime(
        id: json["id"],
        employee: json["employee"],
        startTime: json["start_time"] == null ? null : DateTime.parse(json["start_time"]),
        resumeTime: json["resume_time"] == null ? null : DateTime.parse(json["resume_time"]),
        totalBreakDuration: json["total_break_duration"]?.toDouble(),
        isCompleted: json["is_completed"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "employee": employee,
        "start_time": startTime?.toIso8601String(),
        "resume_time": resumeTime?.toIso8601String(),
        "total_break_duration": totalBreakDuration,
        "is_completed": isCompleted,
    };
}
