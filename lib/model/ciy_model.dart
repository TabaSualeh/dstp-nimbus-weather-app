import 'package:nimbus/model/weather_model.dart';

class City {
  String? id;
  String? name;
  String? country;
  String? region;
  String? tagline;
  int? population;
  Weather? weather;

  City({
    this.id,
    this.name,
    this.country,
    this.region,
    this.tagline,
    this.population,
    this.weather,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    name: json["name"],
    country: json["country"],
    region: json["region"],
    tagline: json["tagline"],
    population: json["population"],
    weather: json["weather"] == null ? null : Weather.fromJson(json["weather"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "country": country,
    "region": region,
    "tagline": tagline,
    "population": population,
    "weather": weather?.toJson(),
  };
}
