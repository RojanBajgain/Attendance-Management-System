import 'dart:convert';

class ProfileModel {
  int totalPages;
  int currentPage;
  int count;
  List<Datum> data;

  ProfileModel({
    this.totalPages = 1,
    this.currentPage = 1,
    this.count = 0,
    this.data = const [],
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        totalPages: json["total_pages"] ?? 1,
        currentPage: json["current_page"] ?? 1,
        count: json["count"] ?? 0,
        data: List<Datum>.from(
            (json["data"] ?? []).map((x) => Datum.fromJson(x))),
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
  User user;
  DateTime dob;
  String phoneNumber;
  Designation designation;
  Designation shift;
  Rank rank;
  String gender;
  String profileImage;
  List<Document> documents;
  List<BankDetail> bankDetails;
  Device? device;
  DateTime joinedDate;
  bool isActive;
  String role;
  String? resume;
  List<String> skills;
  String employeeType;
  List<Address> addresses;
  Organization organization;
  String status;
  String username;
  String email;

  Datum({
    this.id = 0,
    required this.user,
    required this.dob,
    this.phoneNumber = '',
    required this.designation,
    required this.shift,
    required this.rank,
    this.gender = '',
    this.profileImage = '',
    this.documents = const [],
    this.bankDetails = const [],
    this.device,
    required this.joinedDate,
    this.isActive = false,
    this.role = '',
    this.resume,
    this.skills = const [],
    this.employeeType = '',
    this.addresses = const [],
    required this.organization,
    this.status = '',
    this.username = '',
    this.email = '',
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? 0,
        user: User.fromJson(json["user"]),
        dob: DateTime.parse(json["dob"]),
        phoneNumber: json["phone_number"] ?? '',
        designation: Designation.fromJson(json["designation"]),
        shift: Designation.fromJson(json["shift"]),
        rank: Rank.fromJson(json["rank"]),
        gender: json["gender"] ?? '',
        profileImage: json["profile_image"] ?? '',
        documents: List<Document>.from(
            (json["documents"] ?? []).map((x) => Document.fromJson(x))),
        bankDetails: List<BankDetail>.from(
            (json["bank_details"] ?? []).map((x) => BankDetail.fromJson(x))),
        device: json["device"] != null ? Device.fromJson(json["device"]) : null,
        joinedDate: DateTime.parse(json["joined_date"]),
        isActive: json["is_active"] ?? false,
        role: json["role"] ?? '',
        resume: json["resume"],
        skills: List<String>.from((json["skills"] ?? [])),
        employeeType: json["employee_type"] ?? '',
        addresses: List<Address>.from(
            (json["addresses"] ?? []).map((x) => Address.fromJson(x))),
        organization: Organization.fromJson(json["organization"]),
        status: json["status"] ?? '',
        username: json["username"] ?? '',
        email: json["email"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "dob": dob.toIso8601String(),
        "phone_number": phoneNumber,
        "designation": designation.toJson(),
        "shift": shift.toJson(),
        "rank": rank.toJson(),
        "gender": gender,
        "profile_image": profileImage,
        "documents": documents.map((x) => x.toJson()).toList(),
        "bank_details": bankDetails.map((x) => x.toJson()).toList(),
        "device": device?.toJson(),
        "joined_date": joinedDate.toIso8601String(),
        "is_active": isActive,
        "role": role,
        "resume": resume,
        "skills": skills,
        "employee_type": employeeType,
        "addresses": addresses.map((x) => x.toJson()).toList(),
        "organization": organization.toJson(),
        "status": status,
        "username": username,
        "email": email,
      };
}

class User {
  int id;
  String fullName;
  String email;

  User({
    this.id = 0,
    this.fullName = '',
    this.email = '',
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? 0,
        fullName: json["full_name"] ?? '',
        email: json["email"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
      };
}

class Designation {
  int id;
  String name;

  Designation({
    this.id = 0,
    this.name = '',
  });

  factory Designation.fromJson(Map<String, dynamic> json) => Designation(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Rank {
  int id;
  String name;
  int organization;
  int count;

  Rank({
    this.id = 0,
    this.name = '',
    this.organization = 0,
    this.count = 0,
  });

  factory Rank.fromJson(Map<String, dynamic> json) => Rank(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        organization: json["organization"] ?? 0,
        count: json["count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "organization": organization,
        "count": count,
      };
}

class Organization {
  int id;
  String title;
  String description;

  Organization({
    this.id = 0,
    this.title = '',
    this.description = '',
  });

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
        id: json["id"] ?? 0,
        title: json["title"] ?? '',
        description: json["description"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
      };
}

class Document {
  int id;
  int profile;
  String type;
  String title;
  DateTime issuedDate;
  String identifier;
  List<FileElement> files;

  Document({
    this.id = 0,
    this.profile = 0,
    this.type = '',
    this.title = '',
    required this.issuedDate,
    this.identifier = '',
    this.files = const [],
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        id: json["id"] ?? 0,
        profile: json["profile"] ?? 0,
        type: json["type"] ?? '',
        title: json["title"] ?? '',
        issuedDate: DateTime.parse(json["issued_date"]),
        identifier: json["identifier"] ?? '',
        files: List<FileElement>.from(
            (json["files"] ?? []).map((x) => FileElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile": profile,
        "type": type,
        "title": title,
        "issued_date": issuedDate.toIso8601String(),
        "identifier": identifier,
        "files": files.map((x) => x.toJson()).toList(),
      };
}

class FileElement {
  int id;
  int document;
  String file;

  FileElement({
    this.id = 0,
    this.document = 0,
    this.file = '',
  });

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        id: json["id"] ?? 0,
        document: json["document"] ?? 0,
        file: json["file"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "document": document,
        "file": file,
      };
}

class BankDetail {
  int id;
  int profile;
  String bankName;
  String bankAccount;
  String bankAccountName;
  String bankBranch;
  bool isPayroll;

  BankDetail({
    this.id = 0,
    this.profile = 0,
    this.bankName = '',
    this.bankAccount = '',
    this.bankAccountName = '',
    this.bankBranch = '',
    this.isPayroll = false,
  });

  factory BankDetail.fromJson(Map<String, dynamic> json) => BankDetail(
        id: json["id"] ?? 0,
        profile: json["profile"] ?? 0,
        bankName: json["bank_name"] ?? '',
        bankAccount: json["bank_account"] ?? '',
        bankAccountName: json["bank_account_name"] ?? '',
        bankBranch: json["bank_branch"] ?? '',
        isPayroll: json["is_payroll"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile": profile,
        "bank_name": bankName,
        "bank_account": bankAccount,
        "bank_account_name": bankAccountName,
        "bank_branch": bankBranch,
        "is_payroll": isPayroll,
      };
}

class Device {
  int id;
  int profile;
  int deviceUserId;
  String fingerprintId;
  String portalPin;
  String appPin;

  Device({
    this.id = 0,
    this.profile = 0,
    this.deviceUserId = 0,
    this.fingerprintId = '',
    this.portalPin = '',
    this.appPin = '',
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        id: json["id"] ?? 0,
        profile: json["profile"] ?? 0,
        deviceUserId: json["device_user_id"] ?? 0,
        fingerprintId: json["fingerprint_id"] ?? '',
        portalPin: json["portal_pin"] ?? '',
        appPin: json["app_pin"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile": profile,
        "device_user_id": deviceUserId,
        "fingerprint_id": fingerprintId,
        "portal_pin": portalPin,
        "app_pin": appPin,
      };
}

class Address {
  int id;
  String addressType;
  String province;
  String city;
  String addressLineOne;
  String addressLineTwo;
  String postalCode;
  Country country;

  Address({
    this.id = 0,
    this.addressType = '',
    this.province = '',
    this.city = '',
    this.addressLineOne = '',
    this.addressLineTwo = '',
    this.postalCode = '',
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"] ?? 0,
        addressType: json["address_type"] ?? '',
        province: json["province"] ?? '',
        city: json["city"] ?? '',
        addressLineOne: json["address_line_one"] ?? '',
        addressLineTwo: json["address_line_two"] ?? '',
        postalCode: json["postal_code"] ?? '',
        country: Country.fromJson(json["country"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address_type": addressType,
        "province": province,
        "city": city,
        "address_line_one": addressLineOne,
        "address_line_two": addressLineTwo,
        "postal_code": postalCode,
        "country": country.toJson(),
      };
}

class Country {
  int id;
  String name;
  String code;

  Country({
    this.id = 0,
    this.name = '',
    this.code = '',
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        code: json["code"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
      };
}
