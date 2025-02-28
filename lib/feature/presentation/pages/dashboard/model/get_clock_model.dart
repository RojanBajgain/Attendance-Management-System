import 'dart:convert';

class GetClockModel {
  DateTime? clockedData;

  GetClockModel({
    this.clockedData,
  });

  factory GetClockModel.fromRawJson(String str) =>
      GetClockModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetClockModel.fromJson(Map<String, dynamic> json) => GetClockModel(
        clockedData: DateTime.parse(json["clocked_data"]),
      );

  Map<String, dynamic> toJson() => {
        "clocked_data": clockedData?.toIso8601String(),
      };
}
