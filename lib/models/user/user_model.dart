// To parse this JSON data, do
//
//     final userDetails = userDetailsFromJson(jsonString);

import 'dart:convert';

UserDetails userDetailsFromJson(String str) =>
    UserDetails.fromJson(json.decode(str));

String userDetailsToJson(UserDetails data) => json.encode(data.toJson());

class UserDetails {
  int totalPages;
  int currentPage;
  int count;
  List<Datum> data;

  UserDetails({
    required this.totalPages,
    required this.currentPage,
    required this.count,
    required this.data,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        totalPages: json["total_pages"],
        currentPage: json["current_page"],
        count: json["count"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
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
  DateTime dob;
  String phoneNumber;
  int designation;
  int shift;
  int rank;
  String gender;
  String address;
  final String? profileImage;
  dynamic documents;
  List<dynamic> bankDetails;
  dynamic device;
  DateTime joinedDate;
  bool isActive;
  String role;
  String resume;
  List<String> skills;
  String employeeType;
  String username;
  String email;

  Datum({
    required this.id,
    required this.dob,
    required this.phoneNumber,
    required this.designation,
    required this.shift,
    required this.rank,
    required this.gender,
    required this.address,
    this.profileImage,
    this.documents,
    required this.bankDetails,
    this.device,
    required this.joinedDate,
    required this.isActive,
    required this.role,
    required this.resume,
    required this.skills,
    required this.employeeType,
    required this.username,
    required this.email,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        dob: DateTime.parse(json["dob"]),
        phoneNumber: json["phone_number"],
        designation: json["designation"],
        shift: json["shift"],
        rank: json["rank"],
        gender: json["gender"],
        address: json["address"],
        profileImage: json["profile_image"],
        documents: json["documents"],
        bankDetails: List<dynamic>.from(json["bank_details"].map((x) => x)),
        device: json["device"],
        joinedDate: DateTime.parse(json["joined_date"]),
        isActive: json["is_active"] ?? false,
        role: json["role"],
        resume: json["resume"],
        skills: List<String>.from(json["skills"].map((x) => x)),
        employeeType: json["employee_type"],
        username: json["username"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dob":
            "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        "phone_number": phoneNumber,
        "designation": designation,
        "shift": shift,
        "rank": rank,
        "gender": gender,
        "address": address,
        "profile_image": profileImage,
        "documents": documents,
        "bank_details": List<dynamic>.from(bankDetails.map((x) => x)),
        "device": device,
        "joined_date":
            "${joinedDate.year.toString().padLeft(4, '0')}-${joinedDate.month.toString().padLeft(2, '0')}-${joinedDate.day.toString().padLeft(2, '0')}",
        "is_active": isActive,
        "role": role,
        "resume": resume,
        "skills": List<dynamic>.from(skills.map((x) => x)),
        "employee_type": employeeType,
        "username": username,
        "email": email,
      };
}
