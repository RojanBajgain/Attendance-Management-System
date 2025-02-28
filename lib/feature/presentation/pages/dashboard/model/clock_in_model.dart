import 'dart:convert';

class ClockInModel {
  int id;
  int user;
  double? latitude;
  double? longitude;
  DateTime? clockInTime;
  dynamic clockOutTime;

  ClockInModel({
    this.id = 0,
    this.user = 0,
    this.latitude,
    this.longitude,
    this.clockInTime,
    this.clockOutTime,
  });

  // factory ClockInModel.fromJson(Map<String, dynamic> json) => ClockInModel(
  //       id: json["id"] ?? 0,
  //       user: json["user"] ?? 0,
  //       latitude: json["latitude"]?.toDouble(),
  //       longitude: json["longitude"]?.toDouble(),
  //       clockInTime: json["clock_in_time"] != null
  //           ? DateTime.tryParse(json["clock_in_time"])
  //           : null,
  //       clockOutTime: json["clock_out_time"],
  //     );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "latitude": latitude,
        "longitude": longitude,
        "clock_in_time": clockInTime?.toIso8601String(),
        "clock_out_time": clockOutTime,
      };
}
