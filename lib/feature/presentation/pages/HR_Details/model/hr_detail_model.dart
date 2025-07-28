class OrganizationStaffModel {
  int id;
  String fullName;
  String phoneNumber;
  String designation;
  String profileImage;
  String employeeType;
  String role;
  String email;
  DateTime? joinedDate;

  OrganizationStaffModel({
    this.id = 0,
    this.fullName = '',
    this.phoneNumber = '',
    this.designation = '',
    this.profileImage = '',
    this.employeeType = '',
    this.role = '',
    this.email = '',
    this.joinedDate,
  });

  factory OrganizationStaffModel.fromJson(Map<String, dynamic> json) =>
      OrganizationStaffModel(
        id: json["id"] ?? 0,
        fullName: json["full_name"] ?? '',
        phoneNumber: json["phone_number"] ?? '',
        designation: json["designation"] ?? '',
        profileImage: json["profile_image"] ?? '',
        employeeType: json["employee_type"] ?? '',
        role: json["role"] ?? '',
        email: json["email"] ?? '',
        joinedDate: json["joined_date"] != null
            ? DateTime.tryParse(json["joined_date"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "phone_number": phoneNumber,
        "designation": designation,
        "profile_image": profileImage,
        "employee_type": employeeType,
        "role": role,
        "email": email,
        "joined_date": joinedDate?.toIso8601String(),
      };
}
