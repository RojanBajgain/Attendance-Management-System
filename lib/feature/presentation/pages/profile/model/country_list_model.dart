import 'dart:convert';

class CountryListModel {
  int totalPages;
  int currentPage;
  int count;
  List<Datumm> data;

  CountryListModel({
    this.totalPages = 0,
    this.currentPage = 0,
    this.count = 0,
    this.data = const [],
  });

  factory CountryListModel.fromRawJson(String str) =>
      CountryListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CountryListModel.fromJson(Map<String, dynamic> json) =>
      CountryListModel(
        totalPages: json["total_pages"],
        currentPage: json["current_page"],
        count: json["count"],
        data: List<Datumm>.from(json["data"].map((x) => Datumm.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_pages": totalPages,
        "current_page": currentPage,
        "count": count,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datumm {
  int id;
  String name;
  String code;

  Datumm({
    this.id = 0,
    this.name = '',
    this.code = '',
  });

  factory Datumm.fromRawJson(String str) => Datumm.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datumm.fromJson(Map<String, dynamic> json) => Datumm(
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
