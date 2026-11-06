// To parse this JSON data, do
//
//     final cities = citiesFromJson(jsonString);

import 'dart:convert';

import 'ciy_model.dart';
import 'meta_model.dart';

Cities citiesFromJson(String str) => Cities.fromJson(json.decode(str));

String citiesToJson(Cities data) => json.encode(data.toJson());

class Cities {
  List<City>? data;
  Meta? meta;

  Cities({
    this.data,
    this.meta,
  });

  factory Cities.fromJson(Map<String, dynamic> json) => Cities(
    data: json["data"] == null ? [] : List<City>.from(json["data"]!.map((x) => City.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "meta": meta?.toJson(),
  };
}
