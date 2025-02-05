import 'dart:convert';

class ProfileModel {
  int totalPages;
  int currentPage;
  int count;
  List<Datum> data;

  ProfileModel({
    this.totalPages = 1,
    this.currentPage = 1,
    this.count = 1,
    this.data = const [],
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        totalPages: json["total_pages"] ?? 1,
        currentPage: json["current_page"] ?? 1,
        count: json["count"] ?? 1,
        data: List<Datum>.from(
          (json["data"] ?? []).map((x) => Datum.fromJson(x)),
        ),
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
  bool role;
  String resume;
  List<String>? skills;
  String employeeType;
  List<Address>? addresses;
  String username;
  String email;

  Datum({
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
    this.role = false,
    this.resume = '',
    this.skills,
    this.employeeType = '',
    this.addresses,
    this.username = '',
    this.email = '',
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
        role: json["role"] ?? false,
        resume: json["resume"] ?? '',
        skills: json["skills"] != null
            ? List<String>.from(json["skills"].map((x) => x))
            : null,
        employeeType: json["employee_type"] ?? '',
        addresses: json["addresses"] != null
            ? List<Address>.from(
                json["addresses"].map((x) => Address.fromJson(x)))
            : null,
        username: json["username"] ?? '',
        email: json["email"] ?? '',
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
        "documents": documents != null
            ? List<dynamic>.from(documents!.map((x) => x.toJson()))
            : null,
        "bank_details": bankDetails != null
            ? List<dynamic>.from(bankDetails!.map((x) => x.toJson()))
            : null,
        "device": device,
        "joined_date": joinedDate?.toIso8601String(),
        "is_active": isActive,
        "role": role,
        "resume": resume,
        "skills":
            skills != null ? List<dynamic>.from(skills!.map((x) => x)) : null,
        "employee_type": employeeType,
        "addresses": addresses != null
            ? List<dynamic>.from(addresses!.map((x) => x.toJson()))
            : null,
        "username": username,
        "email": email,
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
  Designation? country;

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

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        addressType: json["address_type"],
        province: json["province"],
        city: json["city"],
        addressLineOne: json["address_line_one"],
        addressLineTwo: json["address_line_two"],
        postalCode: json["postal_code"],
        country: json["country"] != null
            ? Designation.fromJson(json["country"])
            : null,
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

class Designation {
  int? id;
  String? name;

  Designation({
    this.id,
    this.name,
  });

  factory Designation.fromRawJson(String str) =>
      Designation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Designation.fromJson(Map<String, dynamic> json) => Designation(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
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

  BankDetail({
    this.id,
    this.user,
    this.bankName,
    this.bankAccount,
    this.bankAccountName,
    this.bankBranch,
    this.isPayroll,
  });

  factory BankDetail.fromRawJson(String str) =>
      BankDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BankDetail.fromJson(Map<String, dynamic> json) => BankDetail(
        id: json["id"],
        user: json["user"],
        bankName: json["bank_name"],
        bankAccount: json["bank_account"],
        bankAccountName: json["bank_account_name"],
        bankBranch: json["bank_branch"],
        isPayroll: json["is_payroll"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "bank_name": bankName,
        "bank_account": bankAccount,
        "bank_account_name": bankAccountName,
        "bank_branch": bankBranch,
        "is_payroll": isPayroll,
      };
}

class Device {
  int? id;
  int? user;
  int? deviceUserId;
  String? fingerprintId;
  String? portalPin;
  String? appPin;

  Device({
    this.id,
    this.user,
    this.deviceUserId,
    this.fingerprintId,
    this.portalPin,
    this.appPin,
  });

  factory Device.fromRawJson(String str) => Device.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        id: json["id"],
        user: json["user"],
        deviceUserId: json["device_user_id"],
        fingerprintId: json["fingerprint_id"],
        portalPin: json["portal_pin"],
        appPin: json["app_pin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "device_user_id": deviceUserId,
        "fingerprint_id": fingerprintId,
        "portal_pin": portalPin,
        "app_pin": appPin,
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

  Document({
    this.id,
    this.profile,
    this.type,
    this.title,
    this.issuedDate,
    this.identifier,
    this.files,
  });

  factory Document.fromRawJson(String str) =>
      Document.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile": profile,
        "type": type,
        "title": title,
        "issued_date": issuedDate?.toIso8601String(),
        "identifier": identifier,
        "files": files != null
            ? List<dynamic>.from(files!.map((x) => x.toJson()))
            : null,
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

  factory FileElement.fromRawJson(String str) =>
      FileElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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
