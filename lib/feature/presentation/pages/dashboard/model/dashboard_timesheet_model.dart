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
        day: json["day"] != null ? Day.fromJson(json["day"]) : null,
        thisWeek:
            json["this_week"] != null ? Day.fromJson(json["this_week"]) : null,
        month: json["month"] != null ? Day.fromJson(json["month"]) : null,
      );
}

class Day {
  double totalHour;
  double overTime;
  double percentage;

  Day({
    this.totalHour = 0.0,
    this.overTime = 0.0,
    this.percentage = 0.0,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        totalHour: (json["total_hour"] as num?)?.toDouble() ?? 0.0,
        overTime: (json["over_time"] as num?)?.toDouble() ?? 0.0,
        percentage: (json["percentage"] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "total_hour": totalHour,
        "over_time": overTime,
        "percentage": percentage,
      };
}
