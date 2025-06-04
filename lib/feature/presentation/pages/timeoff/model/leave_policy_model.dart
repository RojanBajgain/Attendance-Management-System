import 'dart:convert';

LeavePolicyModel leavePolicyModelFromJson(String str) =>
    LeavePolicyModel.fromJson(json.decode(str));

String leavePolicyModelToJson(LeavePolicyModel data) =>
    json.encode(data.toJson());

class LeavePolicyModel {
  User? user;
  List<LeavePolicy>? leavePolicies;

  LeavePolicyModel({
    this.user,
    this.leavePolicies,
  });

  factory LeavePolicyModel.fromJson(Map<String, dynamic> json) =>
      LeavePolicyModel(
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
        leavePolicies: json["leave_policies"] != null
            ? List<LeavePolicy>.from(
                json["leave_policies"].map((x) => LeavePolicy.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "leave_policies": leavePolicies != null
            ? List<dynamic>.from(leavePolicies!.map((x) => x.toJson()))
            : [],
      };
}

class LeavePolicy {
  String? policyName;
  int? totalEntitlement;
  int? usedLeave;
  int? remainingLeave;

  LeavePolicy({
    this.policyName,
    this.totalEntitlement,
    this.usedLeave,
    this.remainingLeave,
  });

  factory LeavePolicy.fromJson(Map<String, dynamic> json) => LeavePolicy(
        policyName: json["policy_name"],
        totalEntitlement: json["total_entitlement"],
        usedLeave: json["used_leave"],
        remainingLeave: json["remaining_leave"],
      );

  Map<String, dynamic> toJson() => {
        "policy_name": policyName,
        "total_entitlement": totalEntitlement,
        "used_leave": usedLeave,
        "remaining_leave": remainingLeave,
      };
}

class User {
  int? id;
  String? fullName;
  String? organization;
  DateTime? joinedDate;

  User({
    this.id,
    this.fullName,
    this.organization,
    this.joinedDate,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullName: json["full_name"],
        organization: json["organization"],
        joinedDate: json["joined_date"] != null
            ? DateTime.tryParse(json["joined_date"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "organization": organization,
        "joined_date": joinedDate?.toIso8601String(),
      };
}
