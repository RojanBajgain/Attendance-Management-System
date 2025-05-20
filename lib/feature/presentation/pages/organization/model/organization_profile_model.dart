import 'dart:convert';

class OrganizationProfileModel {
  Profile profile;

  OrganizationProfileModel({
    required this.profile,
  });

  factory OrganizationProfileModel.fromRawJson(String str) =>
      OrganizationProfileModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrganizationProfileModel.fromJson(Map<String, dynamic> json) =>
      OrganizationProfileModel(
        profile: Profile.fromJson(json["profile"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "profile": profile.toJson(),
      };
}

class Profile {
  int profileId;
  String fullName;
  String email;
  String role;
  String? profileImage;
  String designation;
  String employeeType;
  String organization;

  Profile({
    this.profileId = 0,
    this.fullName = '',
    this.email = '',
    this.role = '',
    this.profileImage,
    this.designation = '',
    this.employeeType = '',
    this.organization = '',
  });

  factory Profile.fromRawJson(String str) => Profile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        profileId: json["profile_id"] ?? 0,
        fullName: json["full_name"] ?? '',
        email: json["email"] ?? '',
        role: json["role"] ?? '',
        profileImage: json["profile_image"],
        designation: json["designation"] ?? '',
        employeeType: json["employee_type"] ?? '',
        organization: json["organization"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "profile_id": profileId,
        "full_name": fullName,
        "email": email,
        "role": role,
        "profile_image": profileImage,
        "designation": designation,
        "employee_type": employeeType,
        "organization": organization,
      };
}
