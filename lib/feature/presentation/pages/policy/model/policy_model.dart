import 'dart:convert';

class PolicyModel {
  int totalPages;
  int currentPage;
  int count;
  List<Datum> data;

  PolicyModel({
    this.totalPages = 0,
    this.currentPage = 0,
    this.count = 0,
    this.data = const [],
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) => PolicyModel(
        totalPages: json["total_pages"] ?? 0,
        currentPage: json["current_page"] ?? 0,
        count: json["count"] ?? 0,
        data: json["data"] != null
            ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "total_pages": totalPages,
        "current_page": currentPage,
        "count": count,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  String? name;
  String? compensation;
  String? units;
  int days;

  Datum({
    this.id = 0,
    this.name,
    this.compensation,
    this.units,
    this.days = 0,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? 0,
        name: json["name"],
        compensation: json["compensation"],
        units: json["units"],
        days: json["days"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "compensation": compensation,
        "units": units,
        "days": days,
      };
}
