class ClockOutModel {
  int id;
  int user;
  double? latitude;
  double? longitude;
  DateTime? clockInTime;
  DateTime? clockOutTime;

  ClockOutModel({
    this.id = 0,
    this.user = 0,
    this.latitude,
    this.longitude,
    this.clockInTime,
    this.clockOutTime,
  });

  // factory ClockOutModel.fromJson(Map<String, dynamic> json) => ClockOutModel(
  //       id: json["id"] ?? 0,
  //       user: json["user"] ?? 0,
  //       latitude: json["latitude"]?.toDouble(),
  //       longitude: json["longitude"]?.toDouble(),
  //       clockInTime: json["clock_in_time"] != null
  //           ? DateTime.tryParse(json["clock_in_time"])
  //           : null,
  //       clockOutTime: json["clock_out_time"] != null
  //           ? DateTime.tryParse(json["clock_out_time"])
  //           : null,
  //     );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "latitude": latitude,
        "longitude": longitude,
        "clock_in_time": clockInTime?.toIso8601String(),
        "clock_out_time": clockOutTime?.toIso8601String(),
      };
}
