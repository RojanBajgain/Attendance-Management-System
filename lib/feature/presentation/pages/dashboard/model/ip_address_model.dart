import 'dart:convert';

class IpAddressModel {
  String? ip;

  IpAddressModel({
    this.ip,
  });

  factory IpAddressModel.fromRawJson(String str) =>
      IpAddressModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IpAddressModel.fromJson(Map<String, dynamic> json) => IpAddressModel(
        ip: json["ip"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ip": ip,
      };
}
