class ProfileModel {
  int id;
  User? user;
  DateTime? dob;
  String? phoneNumber;
  Designation? designation;
  Designation? shift;
  Rank? rank;
  String? gender;
  String? profileImage;
  List<Document> documents;
  List<BankDetail> bankDetails;
  DateTime? joinedDate;
  bool isActive;
  String? role;
  String? resume;
  List<String> skills;
  String? employeeType;
  List<Address> addresses;
  Organization? organization;
  String? status;
  String? grossSalary;
  List<UserRecord> userRecords;
  String? username;
  String? email;

  ProfileModel({
    this.id = 0,
    this.user,
    this.dob,
    this.phoneNumber,
    this.designation,
    this.shift,
    this.rank,
    this.gender,
    this.profileImage,
    this.documents = const [],
    this.bankDetails = const [],
    this.joinedDate,
    this.isActive = false,
    this.role,
    this.resume,
    this.skills = const [],
    this.employeeType,
    this.addresses = const [],
    this.organization,
    this.status,
    this.grossSalary,
    this.userRecords = const [],
    this.username,
    this.email,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json["id"] ?? 0,
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
        dob: json["dob"] != null ? DateTime.tryParse(json["dob"]) : null,
        phoneNumber: json["phone_number"],
        designation: json["designation"] != null
            ? Designation.fromJson(json["designation"])
            : null,
        shift:
            json["shift"] != null ? Designation.fromJson(json["shift"]) : null,
        rank: json["rank"] != null ? Rank.fromJson(json["rank"]) : null,
        gender: json["gender"],
        profileImage: json["profile_image"],
        documents: json["documents"] != null
            ? List<Document>.from(
                json["documents"].map((x) => Document.fromJson(x)))
            : [],
        bankDetails: json["bank_details"] != null
            ? List<BankDetail>.from(
                json["bank_details"].map((x) => BankDetail.fromJson(x)))
            : [],
        joinedDate: json["joined_date"] != null
            ? DateTime.tryParse(json["joined_date"])
            : null,
        isActive: json["is_active"] ?? false,
        role: json["role"],
        resume: json["resume"],
        skills: json["skills"] != null ? List<String>.from(json["skills"]) : [],
        employeeType: json["employee_type"],
        addresses: json["addresses"] != null
            ? List<Address>.from(
                json["addresses"].map((x) => Address.fromJson(x)))
            : [],
        organization: json["organization"] != null
            ? Organization.fromJson(json["organization"])
            : null,
        status: json["status"],
        grossSalary: json["gross_salary"],
        userRecords: json["user_records"] != null
            ? List<UserRecord>.from(
                json["user_records"].map((x) => UserRecord.fromJson(x)))
            : [],
        username: json["username"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user?.toJson(),
        "dob": dob?.toIso8601String(),
        "phone_number": phoneNumber,
        "designation": designation?.toJson(),
        "shift": shift?.toJson(),
        "rank": rank?.toJson(),
        "gender": gender,
        "profile_image": profileImage,
        "documents": documents.map((x) => x.toJson()).toList(),
        "bank_details": bankDetails.map((x) => x.toJson()).toList(),
        "joined_date": joinedDate?.toIso8601String(),
        "is_active": isActive,
        "role": role,
        "resume": resume,
        "skills": skills,
        "employee_type": employeeType,
        "addresses": addresses.map((x) => x.toJson()).toList(),
        "organization": organization?.toJson(),
        "status": status,
        "gross_salary": grossSalary,
        "user_records": userRecords.map((x) => x.toJson()).toList(),
        "username": username,
        "email": email,
      };
}

class Organization {
  int id;
  String title;
  String description;
  String location;
  bool webEnabled;
  bool mobileEnabled;

  Organization({
    this.id = 0,
    this.title = '',
    this.description = '',
    this.location = '',
    this.webEnabled = false,
    this.mobileEnabled = false,
  });

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        location: json["location"],
        webEnabled: json["web_enabled"],
        mobileEnabled: json["mobile_enabled"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "location": location,
        "web_enabled": webEnabled,
        "mobile_enabled": mobileEnabled,
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
  String organization;
  int count;

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

class Document {
  int id;
  int profile;
  String type;
  String title;
  DateTime? issuedDate;
  String identifier;
  List<dynamic> files;
  String organization;

  Document({
    this.id = 0,
    this.profile = 0,
    this.type = '',
    this.title = '',
    this.issuedDate,
    this.identifier = '',
    this.files = const [],
    this.organization = '',
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        id: json["id"] ?? 0,
        profile: json["profile"] ?? 0,
        type: json["type"] ?? '',
        title: json["title"] ?? '',
        issuedDate: json["issued_date"] != null
            ? DateTime.tryParse(json["issued_date"])
            : null,
        identifier: json["identifier"] ?? '',
        files: json["files"] ?? [],
        organization: json["organization"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile": profile,
        "type": type,
        "title": title,
        "issued_date": issuedDate?.toIso8601String(),
        "identifier": identifier,
        "files": files,
        "organization": organization,
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
  String organization;

  BankDetail({
    this.id = 0,
    this.profile = 0,
    this.bankName = '',
    this.bankAccount = '',
    this.bankAccountName = '',
    this.bankBranch = '',
    this.isPayroll = false,
    this.organization = '',
  });

  factory BankDetail.fromJson(Map<String, dynamic> json) => BankDetail(
        id: json["id"] ?? 0,
        profile: json["profile"] ?? 0,
        bankName: json["bank_name"] ?? '',
        bankAccount: json["bank_account"] ?? '',
        bankAccountName: json["bank_account_name"] ?? '',
        bankBranch: json["bank_branch"] ?? '',
        isPayroll: json["is_payroll"] ?? false,
        organization: json["organization"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile": profile,
        "bank_name": bankName,
        "bank_account": bankAccount,
        "bank_account_name": bankAccountName,
        "bank_branch": bankBranch,
        "is_payroll": isPayroll,
        "organization": organization,
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
  Country? country;

  Address({
    this.id = 0,
    this.addressType = '',
    this.province = '',
    this.city = '',
    this.addressLineOne = '',
    this.addressLineTwo = '',
    this.postalCode = '',
    this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"] ?? 0,
        addressType: json["address_type"] ?? '',
        province: json["province"] ?? '',
        city: json["city"] ?? '',
        addressLineOne: json["address_line_one"] ?? '',
        addressLineTwo: json["address_line_two"] ?? '',
        postalCode: json["postal_code"] ?? '',
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

class UserRecord {
  int employeeNo;
  String name;
  String organization;

  UserRecord({
    this.employeeNo = 0,
    this.name = '',
    this.organization = '',
  });

  factory UserRecord.fromJson(Map<String, dynamic> json) => UserRecord(
        employeeNo: json["employee_no"] ?? 0,
        name: json["name"] ?? '',
        organization: json["organization"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "employee_no": employeeNo,
        "name": name,
        "organization": organization,
      };
}
