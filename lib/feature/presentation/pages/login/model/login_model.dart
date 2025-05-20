import 'dart:convert';

class LoginModel {
  String refresh;
  String access;
  List<Organization> organization;
  int? user;

  LoginModel({
    required this.refresh,
    required this.access,
    this.organization = const [],
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
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
        "organization": List<dynamic>.from(organization.map((x) => x.toJson())),
        "user": user,
      };
}

class Organization {
  String title;
  String apiKey;

  Organization({
    required this.title,
    required this.apiKey,
  });

  factory Organization.fromRawJson(String str) =>
      Organization.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
        title: json["title"],
        apiKey: json["api_key"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "api_key": apiKey,
      };
}
