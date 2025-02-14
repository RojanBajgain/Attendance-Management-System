import 'dart:convert';

class LoginModel {
  final String refresh;
  final String access;
  final User? user;

  LoginModel({
    required this.refresh,
    required this.access,
    this.user,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        refresh: json["refresh"] as String,
        access: json["access"] as String,
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
        "user": user?.toJson(),
      };
}

class User {
  final int userId;
  final int profileId;
  final String fullName;
  final String? email;
  final String role;
  final String? profileImage;
  final String? designation;
  final String? employeeType;

  User({
    required this.userId,
    required this.profileId,
    required this.fullName,
    this.email,
    required this.role,
    this.profileImage,
    this.designation,
    this.employeeType,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"] ?? 0,
        profileId: json["profile_id"] ?? 0,
        fullName: json["full_name"] ?? "",
        email: json["email"] as String?,
        role: json["role"] ?? "",
        profileImage: json["profile_image"] as String?,
        designation: json["designation"] as String?,
        employeeType: json["employee_type"] as String?,
      );

  factory User.empty() => User(
        userId: 0,
        profileId: 0,
        fullName: "",
        email: null,
        role: "",
        profileImage: null,
        designation: null,
        employeeType: null,
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "profile_id": profileId,
        "full_name": fullName,
        "email": email,
        "role": role,
        "profile_image": profileImage,
        "designation": designation,
        "employee_type": employeeType,
      };
}
