import 'dart:convert';

class LoginModel {
  String refresh;
  String access;
  List<Organization> organization;
  List<dynamic> profile;
  int? user;

  LoginModel({
    required this.refresh,
    required this.access,
    this.organization = const [],
    this.profile = const [],
    this.user,
  });

  factory LoginModel.fromRawJson(String str) =>
      LoginModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        refresh: json["refresh"],
        access: json["access"],
        organization: List<Organization>.from(
            json["organization"].map((x) => Organization.fromJson(x))),
        profile: List<dynamic>.from(json["profile"].map((x) => x)),
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
        "organization": List<dynamic>.from(organization.map((x) => x.toJson())),
        "profile": List<dynamic>.from(profile.map((x) => x)),
        "user": user,
      };
}

class Organization {
  String title;
  String apiKey;
  bool mobileEnabled;

  Organization({
    required this.title,
    required this.apiKey,
    required this.mobileEnabled,
  });

  factory Organization.fromRawJson(String str) =>
      Organization.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
        title: json["title"],
        apiKey: json["api_key"],
        mobileEnabled: json["mobile_enabled"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "api_key": apiKey,
        "mobile_enabled": mobileEnabled,
      };
}
