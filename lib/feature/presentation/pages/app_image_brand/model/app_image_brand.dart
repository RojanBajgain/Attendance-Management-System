import 'dart:convert';

AppBrand appBrandFromJson(String str) => AppBrand.fromJson(json.decode(str));
String appBrandToJson(AppBrand data) => json.encode(data.toJson());

class AppBrand {
  int totalPages;
  int currentPage;
  int count;
  int pageSize;
  List<Datum> data;

  AppBrand({
    this.totalPages = 0,
    this.currentPage = 0,
    this.count = 0,
    this.pageSize = 0,
    this.data = const [],
  });

  factory AppBrand.fromJson(Map<String, dynamic> json) => AppBrand(
        totalPages: json["total_pages"] ?? 0,
        currentPage: json["current_page"] ?? 0,
        count: json["count"] ?? 0,
        pageSize: json["page_size"] ?? 0,
        data: json["data"] != null
            ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
            : [],
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
  int id;
  String logo;
  String? favicon; // Make this nullable
  String themeColor;
  Organization? organization;

  Datum({
    this.id = 0,
    this.logo = '',
    this.favicon, // Remove default empty string
    this.themeColor = '',
    this.organization,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? 0,
        logo: json["logo"] ?? '',
        favicon: json["favicon"], // Don't provide default - let it be null
        themeColor: json["theme_color"] ?? '',
        organization: json["organization"] != null
            ? Organization.fromJson(json["organization"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "logo": logo,
        "favicon": favicon, // Can be null
        "theme_color": themeColor,
        "organization": organization?.toJson(),
      };
}

class Organization {
  String id;
  String title;
  String description;
  dynamic location;
  String apiKey;
  bool webEnabled;
  bool mobileEnabled;

  Organization({
    this.id = '',
    this.title = '',
    this.description = '',
    this.location = '',
    this.apiKey = '',
    this.webEnabled = false,
    this.mobileEnabled = false,
  });

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
        id: json["id"]?.toString() ?? '',
        title: json["title"] ?? '',
        description: json["description"] ?? '',
        location: json["location"],
        apiKey: json["api_key"] ?? '',
        webEnabled: json["web_enabled"] ?? false,
        mobileEnabled: json["mobile_enabled"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "location": location,
        "api_key": apiKey,
        "web_enabled": webEnabled,
        "mobile_enabled": mobileEnabled,
      };
}
