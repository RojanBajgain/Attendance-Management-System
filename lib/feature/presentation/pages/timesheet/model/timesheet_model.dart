import 'dart:convert';

class TimesheetModel {
  int totalPages;
  int currentPage;
  int count;
  int pageSize;
  List<Datum> data;

  TimesheetModel({
    this.totalPages = 1,
    this.currentPage = 1,
    this.count = 1,
    this.pageSize = 10,
    this.data = const [],
  });

  factory TimesheetModel.fromJson(Map<String, dynamic> json) => TimesheetModel(
        totalPages: json["total_pages"],
        currentPage: json["current_page"],
        count: json["count"],
        pageSize: json["page_size"] ?? 10,
        data: List<Datum>.from(
          (json["data"] ?? []).map((x) => Datum.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "total_pages": totalPages,
        "current_page": currentPage,
        "count": count,
        "page_size": pageSize,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  dynamic id;
  dynamic serialNo;
  int? employeeNo;
  String? name;
  DateTime? date;
  DateTime? entryTime;
  DateTime? exitTime;
  String? verifyMode;
  String? pictureUrl;
  String? totalHour;
  dynamic breakTime;
  String? overTime;
  String? designation;
  String? entryRemarks;
  String? exitRemarks;

  Datum({
    this.id = 0,
    this.serialNo,
    this.name = '',
    this.date,
    this.entryTime,
    this.exitTime,
    this.verifyMode,
    this.pictureUrl = '',
    this.employeeNo = 0,
    this.totalHour = '0',
    this.breakTime = 0,
    this.overTime = '0',
    this.designation = '',
    this.entryRemarks = '',
    this.exitRemarks = '',
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        serialNo: json["serial_no"] == null
            ? null
            : json["serial_no"] is String
                ? int.tryParse(json["serial_no"])
                : json["serial_no"],
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
        totalHour: json["total_hour"]?.toString(),
        breakTime: json["break_time"],
        overTime: json["over_time"]?.toString(),
        designation: json["designation"],
        entryRemarks: json["entry_remarks"],
        exitRemarks: json["exit_remarks"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
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
        "entry_remarks": entryRemarks,
        "exit_remarks": exitRemarks,
      };
}
