import 'dart:convert';

class GetClockModel {
  DateTime? clockedInData;
  DateTime? clockedOutData;

  GetClockModel({
    this.clockedInData,
    this.clockedOutData,
  });

  factory GetClockModel.fromRawJson(String str) =>
      GetClockModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetClockModel.fromJson(Map<String, dynamic> json) => GetClockModel(
        clockedInData: json["clocked_in_data"] != null
            ? DateTime.parse(json["clocked_in_data"])
            : null,
        clockedOutData: json["clocked_out_data"] != null
            ? DateTime.parse(json["clocked_out_data"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "clocked_in_data": clockedInData?.toIso8601String(),
        "clocked_out_data": clockedOutData?.toIso8601String(),
      };
}
