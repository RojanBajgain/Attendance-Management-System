import 'dart:convert';

class TimesheetDetailModel {
  int? serialNo;
  String? name;
  DateTime? date;
  DateTime? entryTime;
  DateTime? exitTime;
  String? verifyMode;
  String? pictureUrl;
  int? employeeNo;
  int? totalHour;
  int? breakTime;
  int? overTime;
  String? designation;
  String? remarks;

  TimesheetDetailModel({
    this.serialNo = 0,
    this.name = '',
    this.date,
    this.entryTime,
    this.exitTime,
    this.verifyMode = '',
    this.pictureUrl = '',
    this.employeeNo = 0,
    this.totalHour = 0,
    this.breakTime = 0,
    this.overTime = 0,
    this.designation = '',
    this.remarks = '',
  });

  factory TimesheetDetailModel.fromRawJson(String str) =>
      TimesheetDetailModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TimesheetDetailModel.fromJson(Map<String, dynamic> json) =>
      TimesheetDetailModel(
        serialNo: json["serial_no"] ?? 0,
        name: json["name"] ?? '',
        date: DateTime.tryParse(json["date"] ?? '') ?? DateTime.now(),
        entryTime: DateTime.tryParse(json["entry_time"] ?? ''),
        exitTime: DateTime.tryParse(json["exit_time"] ?? ''),
        verifyMode: json["verify_mode"] ?? '',
        pictureUrl: json["picture_url"] ?? '',
        employeeNo: json["employee_no"] ?? 0,
        totalHour: json["total_hour"] ?? 0,
        breakTime: json["break_time"] ?? 0,
        overTime: json["over_time"] ?? 0,
        designation: json["designation"] ?? '',
        remarks: json["remarks"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "serial_no": serialNo,
        "name": name,
        "date": date?.toIso8601String(),
        "entry_time": entryTime?.toIso8601String(),
        "exit_time": exitTime?.toIso8601String(),
        "verify_mode": verifyMode,
        "picture_url": pictureUrl,
        "employee_no": employeeNo,
        "total_hour": totalHour,
        "break_time": breakTime,
        "over_time": overTime,
        "designation": designation,
        "remarks": remarks,
      };
}
