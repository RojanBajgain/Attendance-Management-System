import 'dart:convert';

class PayrollDetailModel {
  int id;
  int user;
  String? modeOfPayment;
  DateTime? dateOfPayment;
  String? payPeriod;
  dynamic chequeNo;
  double? totalSalary;
  int tax;
  String? reimbursement;
  String? unpaidDeduction;
  int netTotal;
  String? status;
  String? username;
  dynamic panNumber;
  String? designation;
  String? shift;
  String? bank;
  String? bankAccountNumber;
  String? accountName;

  PayrollDetailModel({
    this.id = 0,
    this.user = 0,
    this.modeOfPayment,
    this.dateOfPayment,
    this.payPeriod,
    this.chequeNo,
    this.totalSalary,
    this.tax = 0,
    this.reimbursement,
    this.unpaidDeduction,
    this.netTotal = 0,
    this.status,
    this.username,
    this.panNumber,
    this.designation,
    this.shift,
    this.bank,
    this.bankAccountNumber,
    this.accountName,
  });

  factory PayrollDetailModel.fromJson(Map<String, dynamic> json) =>
      PayrollDetailModel(
        id: json["id"] ?? 0,
        user: json["user"] ?? 0,
        modeOfPayment: json["mode_of_payment"],
        dateOfPayment: json["date_of_payment"] != null
            ? DateTime.tryParse(json["date_of_payment"])
            : null,
        payPeriod: json["pay_period"],
        chequeNo: json["cheque_no"],
        totalSalary: json["total_salary"] != null
            ? double.tryParse(json["total_salary"].toString()) ?? 0.0
            : 0.0,
        tax: json["tax"] != null
            ? double.tryParse(json["tax"].toString())?.toInt() ?? 0
            : 0,
        reimbursement: json["reimbursement"],
        unpaidDeduction: json["unpaid_deduction"],
        netTotal: json["net_total"] != null
            ? double.tryParse(json["net_total"].toString())?.toInt() ?? 0
            : 0,
        status: json["status"],
        username: json["username"],
        panNumber: json["pan_number"],
        designation: json["designation"],
        shift: json["shift"],
        bank: json["bank"],
        bankAccountNumber: json["bank_account_number"],
        accountName: json["account_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "mode_of_payment": modeOfPayment,
        "date_of_payment": dateOfPayment?.toIso8601String(),
        "pay_period": payPeriod,
        "cheque_no": chequeNo,
        "total_salary": totalSalary,
        "tax": tax,
        "reimbursement": reimbursement,
        "unpaid_deduction": unpaidDeduction,
        "net_total": netTotal,
        "status": status,
        "username": username,
        "pan_number": panNumber,
        "designation": designation,
        "shift": shift,
        "bank": bank,
        "bank_account_number": bankAccountNumber,
        "account_name": accountName,
      };
}
