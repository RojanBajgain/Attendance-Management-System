import 'dart:convert';

class ProfileDetailModel {
  int id;
  DateTime? dob;
  String phoneNumber;
  Designation? designation;
  Designation? shift;
  Designation? rank;
  String gender;
  String profileImage;
  List<Document>? documents;
  List<BankDetail>? bankDetails;
  Device? device;
  DateTime? joinedDate;
  bool isActive;
  String role;
  String resume;
  List<String>? skills;
  String employeeType;
  List<Address>? addresses;
  Organization? organization;
  String status;
  String username;
  String email;
  User? user;

  ProfileDetailModel({
    this.id = 0,
    this.dob,
    this.phoneNumber = '',
    this.designation,
    this.shift,
    this.rank,
    this.gender = '',
    this.profileImage = '',
    this.documents,
    this.bankDetails,
    this.device,
    this.joinedDate,
    this.isActive = false,
    this.role = '',
    this.resume = '',
    this.skills,
    this.employeeType = '',
    this.addresses,
    this.organization,
    this.status = '',
    this.username = '',
    this.email = '',
    this.user,
  });

  factory ProfileDetailModel.fromJson(Map<String, dynamic> json) =>
      ProfileDetailModel(
        id: json["id"] ?? 0,
        dob: json["dob"] != null ? DateTime.tryParse(json["dob"]) : null,
        phoneNumber: json["phone_number"] ?? '',
        designation: json["designation"] != null
            ? Designation.fromJson(json["designation"])
            : null,
        shift:
            json["shift"] != null ? Designation.fromJson(json["shift"]) : null,
        rank: json["rank"] != null ? Designation.fromJson(json["rank"]) : null,
        gender: json["gender"] ?? '',
        profileImage: json["profile_image"] ?? '',
        documents: json["documents"] != null
            ? List<Document>.from(
                json["documents"].map((x) => Document.fromJson(x)))
            : null,
        bankDetails: json["bank_details"] != null
            ? List<BankDetail>.from(
                json["bank_details"].map((x) => BankDetail.fromJson(x)))
            : null,
        device: json["device"] != null ? Device.fromJson(json["device"]) : null,
        joinedDate: json["joined_date"] != null
            ? DateTime.tryParse(json["joined_date"])
            : null,
        isActive: json["is_active"] ?? false,
        role: json["role"] ?? '',
        resume: json["resume"] ?? '',
        skills: json["skills"] != null
            ? List<String>.from(json["skills"].map((x) => x))
            : null,
        employeeType: json["employee_type"] ?? '',
        addresses: json["addresses"] != null
            ? List<Address>.from(
                json["addresses"].map((x) => Address.fromJson(x)))
            : null,
        organization: json["organization"] != null
            ? Organization.fromJson(json["organization"])
            : null,
        status: json["status"] ?? '',
        username: json["username"] ?? '',
        email: json["email"] ?? '',
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dob": dob?.toIso8601String(),
        "phone_number": phoneNumber,
        "designation": designation?.toJson(),
        "shift": shift?.toJson(),
        "rank": rank?.toJson(),
        "gender": gender,
        "profile_image": profileImage,
        "documents": documents?.map((x) => x.toJson()).toList(),
        "bank_details": bankDetails?.map((x) => x.toJson()).toList(),
        "device": device?.toJson(),
        "joined_date": joinedDate?.toIso8601String(),
        "is_active": isActive,
        "role": role,
        "resume": resume,
        "skills": skills,
        "employee_type": employeeType,
        "addresses": addresses?.map((x) => x.toJson()).toList(),
        "organization": organization?.toJson(),
        "status": status,
        "username": username,
        "email": email,
        "user": user?.toJson(),
      };
}

class Address {
  int? id;
  String? addressType;
  String? province;
  String? city;
  String? addressLineOne;
  String? addressLineTwo;
  String? postalCode;
  Country? country;

  Address({
    this.id,
    this.addressType,
    this.province,
    this.city,
    this.addressLineOne,
    this.addressLineTwo,
    this.postalCode,
    this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        addressType: json["address_type"],
        province: json["province"],
        city: json["city"],
        addressLineOne: json["address_line_one"],
        addressLineTwo: json["address_line_two"],
        postalCode: json["postal_code"],
        country:
            json["country"] != null ? Country.fromJson(json["country"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address_type": addressType,
        "province": province,
        "city": city,
        "address_line_one": addressLineOne,
        "address_line_two": addressLineTwo,
        "postal_code": postalCode,
        "country": country?.toJson(),
      };
}

class BankDetail {
  int? id;
  int? user;
  String? bankName;
  String? bankAccount;
  String? bankAccountName;
  String? bankBranch;
  bool? isPayroll;
  String? organization;

  BankDetail({
    this.id,
    this.user,
    this.bankName,
    this.bankAccount,
    this.bankAccountName,
    this.bankBranch,
    this.isPayroll,
    this.organization = '',
  });

  factory BankDetail.fromJson(Map<String, dynamic> json) => BankDetail(
        id: json["id"],
        user: json["user"],
        bankName: json["bank_name"],
        bankAccount: json["bank_account"],
        bankAccountName: json["bank_account_name"],
        bankBranch: json["bank_branch"],
        isPayroll: json["is_payroll"],
        organization: json["organization"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "bank_name": bankName,
        "bank_account": bankAccount,
        "bank_account_name": bankAccountName,
        "bank_branch": bankBranch,
        "is_payroll": isPayroll,
        "organization": organization,
      };
}

class Designation {
  int? id;
  String? name;

  Designation({this.id, this.name});

  factory Designation.fromJson(Map<String, dynamic> json) => Designation(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Device {
  int? id;
  int? user;
  int? deviceUserId;
  String? fingerprintId;
  String? portalPin;
  String? appPin;
  String? organization;

  Device({
    this.id,
    this.user,
    this.deviceUserId,
    this.fingerprintId,
    this.portalPin,
    this.appPin,
    this.organization = '',
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        id: json["id"],
        user: json["user"],
        deviceUserId: json["device_user_id"] is int
            ? json["device_user_id"]
            : int.tryParse(json["device_user_id"]?.toString() ?? '0') ?? 0,
        fingerprintId: json["fingerprint_id"],
        portalPin: json["portal_pin"],
        appPin: json["app_pin"],
        organization: json["organization"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "device_user_id": deviceUserId,
        "fingerprint_id": fingerprintId,
        "portal_pin": portalPin,
        "app_pin": appPin,
        "organization": organization,
      };
}

class Document {
  int? id;
  int? profile;
  String? type;
  String? title;
  DateTime? issuedDate;
  dynamic identifier;
  List<FileElement>? files;
  String? organization;

  Document({
    this.id,
    this.profile,
    this.type,
    this.title,
    this.issuedDate,
    this.identifier,
    this.files,
    this.organization = '',
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        id: json["id"],
        profile: json["profile"],
        type: json["type"],
        title: json["title"],
        issuedDate: json["issued_date"] != null
            ? DateTime.tryParse(json["issued_date"])
            : null,
        identifier: json["identifier"],
        files: json["files"] != null
            ? List<FileElement>.from(
                json["files"].map((x) => FileElement.fromJson(x)))
            : null,
        organization: json["organization"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile": profile,
        "type": type,
        "title": title,
        "issued_date": issuedDate?.toIso8601String(),
        "identifier": identifier,
        "files": files?.map((x) => x.toJson()).toList(),
        "organization": organization,
      };
}

class FileElement {
  int? id;
  int? document;
  String? file;

  FileElement({
    this.id,
    this.document,
    this.file,
  });

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        id: json["id"],
        document: json["document"],
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "document": document,
        "file": file,
      };
}

class Country {
  int? id;
  String? name;
  String? code;

  Country({
    this.id,
    this.name,
    this.code,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        name: json["name"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
      };
}

class Organization {
  int? id;
  String? title;
  String? description;

  Organization({this.id, this.title, this.description});

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
        id: json["id"],
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
      };
}

class Rank {
  int? id;
  String? name;
  String? organization;
  int? count;

  Rank({
    this.id = 0,
    this.name = '',
    this.organization = '',
    this.count = 0,
  });

  factory Rank.fromJson(Map<String, dynamic> json) => Rank(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        organization: json["organization"] ?? '',
        count: json["count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "organization": organization,
        "count": count,
      };
}

class User {
  int? id;
  String? fullName;
  String? email;

  User({this.id, this.fullName, this.email});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
      };
}
