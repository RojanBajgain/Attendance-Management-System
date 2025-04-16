import 'dart:convert';

class DashboardTimesheet {
  Day? day;
  Day? thisWeek;
  Day? month;

  DashboardTimesheet({
    this.day,
    this.thisWeek,
    this.month,
  });

  factory DashboardTimesheet.fromJson(Map<String, dynamic> json) =>
      DashboardTimesheet(
        day: Day.fromJson(json["day"]),
        thisWeek: Day.fromJson(json["this_week"]),
        month: Day.fromJson(json["month"]),
      );

  // Map<String, dynamic> toJson() => {
  //       "day": day.toJson(),
  //       "this_week": thisWeek.toJson(),
  //       "month": month.toJson(),
  //     };
}

class Day {
  dynamic totalHour;
  dynamic overTime;
  dynamic percentage;

  Day({
    this.totalHour = 0,
    this.overTime = 0,
    this.percentage = 0,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        totalHour: json["total_hour"] ?? 0.0,
        overTime: json["over_time"] ?? 0.0,
        percentage: json["percentage"] ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "total_hour": totalHour,
        "over_time": overTime,
        "percentage": percentage,
      };
}
