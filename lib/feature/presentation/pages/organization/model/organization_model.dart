import 'dart:convert';

class OrganizationModel {
  int? totalPages;
  int? currentPage;
  int? count;
  List<Datum> data;

  OrganizationModel({
    this.totalPages = 0,
    this.currentPage = 0,
    this.count = 1,
    required this.data,
  });

  factory OrganizationModel.fromRawJson(String str) =>
      OrganizationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      OrganizationModel(
        totalPages: json["total_pages"],
        currentPage: json["current_page"],
        count: json["count"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  // New factory to handle list from login response
  factory OrganizationModel.fromLoginResponse(List<dynamic> organizations) =>
      OrganizationModel(
        count: organizations.length,
        data: organizations.map((org) => Datum.fromJson(org)).toList(),
      );

  Map<String, dynamic> toJson() => {
        "total_pages": totalPages,
        "current_page": currentPage,
        "count": count,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String title;
  String? apiKey; // Added apiKey field

  Datum({
    this.title = '',
    this.apiKey,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        title: json["title"],
        apiKey: json["api_key"], // Map api_key to apiKey
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "api_key": apiKey,
      };
}
