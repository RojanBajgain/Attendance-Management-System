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
  String gender;
  String role;
  String? profileImage;
  String designation;
  int designationId;
  String employeeType;
  String organization;
  int organizationId;

  Profile({
    this.profileId = 0,
    this.fullName = '',
    this.email = '',
    this.gender = '',
    this.role = '',
    this.profileImage,
    this.designation = '',
    this.designationId = 0,
    this.employeeType = '',
    this.organization = '',
    this.organizationId = 0,
  });

  factory Profile.fromRawJson(String str) => Profile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        profileId: json["profile_id"] ?? 0,
        fullName: json["full_name"] ?? '',
        email: json["email"] ?? '',
        gender: json["gender"] ?? '',
        role: json["role"] ?? '',
        profileImage: json["profile_image"],
        designation: json["designation"] ?? '',
        designationId: json["designation_id"] ?? 0,
        employeeType: json["employee_type"] ?? '',
        organization: json["organization"] ?? '',
        organizationId: json["organization_id"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "profile_id": profileId,
        "full_name": fullName,
        "email": email,
        "gender": gender,
        "role": role,
        "profile_image": profileImage,
        "designation": designation,
        "designation_id": designationId,
        "employee_type": employeeType,
        "organization": organization,
        "organization_id": organizationId,
      };
}
