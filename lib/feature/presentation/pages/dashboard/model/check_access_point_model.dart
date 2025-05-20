import 'dart:convert';

class CheckAccessPointModel {
  int totalPages;
  int currentPage;
  int count;
  List<AccessPointDatum> data;

  CheckAccessPointModel({
    this.totalPages = 0,
    this.currentPage = 0,
    this.count = 0,
    this.data = const [],
  });

  factory CheckAccessPointModel.fromRawJson(String str) =>
      CheckAccessPointModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CheckAccessPointModel.fromJson(Map<String, dynamic> json) =>
      CheckAccessPointModel(
        totalPages: json["total_pages"] ?? 0,
        currentPage: json["current_page"] ?? 0,
        count: json["count"] ?? 0,
        data: json["data"] != null
            ? List<AccessPointDatum>.from(
                json["data"].map((x) => AccessPointDatum.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "total_pages": totalPages,
        "current_page": currentPage,
        "count": count,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class AccessPointDatum {
  int id;
  bool ipAddress;
  bool geoLocation;
  List<String> allowedIps;
  double? latitude;
  double? longitude;

  AccessPointDatum({
    this.id = 0,
    this.ipAddress = false,
    this.geoLocation = false,
    this.allowedIps = const [],
    this.latitude,
    this.longitude,
  });

  factory AccessPointDatum.fromJson(Map<String, dynamic> json) =>
      AccessPointDatum(
        id: json["id"] ?? 0,
        ipAddress: json["ip_address"] ?? false,
        geoLocation: json["geo_location"] ?? false,
        allowedIps: json["allowed_ips"] != null
            ? List<String>.from(json["allowed_ips"])
            : [],
        latitude: (json["latitude"] as num?)?.toDouble(),
        longitude: (json["longitude"] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ip_address": ipAddress,
        "geo_location": geoLocation,
        "allowed_ips": allowedIps,
        "latitude": latitude,
        "longitude": longitude,
      };
}
