import 'dart:convert';

class TimesheetModel {
  int totalPages;
  int currentPage;
  int count;
  List<Datum> data;

  TimesheetModel({
    this.totalPages = 1,
    this.currentPage = 1,
    this.count = 1,
    this.data = const [],
  });

  factory TimesheetModel.fromJson(Map<String, dynamic> json) => TimesheetModel(
        totalPages: json["total_pages"],
        currentPage: json["current_page"],
        count: json["count"],
        data: List<Datum>.from(
          (json["data"] ?? []).map((x) => Datum.fromJson(x)),
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
  int serialNo;
  String? name;
  DateTime? date;
  DateTime? entryTime;
  DateTime? exitTime;
  String? verifyMode;
  String? pictureUrl;
  int employeeNo;
  int? totalHour;
  int? breakTime;
  int? overTime;
  String? designation;
  String? remarks;

  Datum({
    this.serialNo = 0,
    this.name = '',
    this.date,
    this.entryTime,
    this.exitTime,
    this.verifyMode,
    this.pictureUrl = '',
    this.employeeNo = 0,
    this.totalHour = 0,
    this.breakTime = 0,
    this.overTime = 0,
    this.designation = '',
    this.remarks = '',
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        serialNo: json["serial_no"],
        name: json["name"],
        date: json["date"] != null ? DateTime.tryParse(json["date"]) : null,
        entryTime: json["entry_time"] != null
            ? DateTime.tryParse(json["entry_time"])
            : null,
        exitTime: json["exit_time"] != null
            ? DateTime.tryParse(json["exit_time"])
            : null,
        verifyMode: json["verify_mode"],
        pictureUrl: json["picture_url"],
        employeeNo: json["employee_no"],
        totalHour: json["total_hour"],
        breakTime: json["break_time"],
        overTime: json["over_time"],
        designation: json["designation"],
        remarks: json["remarks"],
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
