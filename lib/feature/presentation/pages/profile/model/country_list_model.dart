import 'dart:convert';

class CountryListModel {
  int? id;
  String? name;

  CountryListModel({
    this.id = 0,
    this.name = '',
  });

  factory CountryListModel.fromJson(Map<String, dynamic> json) =>
      CountryListModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
