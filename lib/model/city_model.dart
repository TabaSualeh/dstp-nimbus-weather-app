import 'package:nimbus/model/weather_model.dart';

class City {
  String? id;
  String? name;
  String? country;
  String? region;
  String? tagline;
  int? population;
  Coordinates? coordinates;
  String? timezone;
  Weather? weather;

  City({
    this.id,
    this.name,
    this.country,
    this.region,
    this.tagline,
    this.population,
    this.coordinates,
    this.timezone,
    this.weather,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    name: json["name"],
    country: json["country"],
    region: json["region"],
    tagline: json["tagline"],
    population: json["population"],
    coordinates: json["coordinates"] == null ? null : Coordinates.fromJson(json["coordinates"]),
    timezone: json["timezone"],
    weather: json["weather"] == null ? null : Weather.fromJson(json["weather"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "country": country,
    "region": region,
    "tagline": tagline,
    "population": population,
    "coordinates": coordinates?.toJson(),
    "timezone": timezone,
    "weather": weather?.toJson(),
  };
}

class Coordinates {
  double? lat;
  double? lon;

  Coordinates({
    this.lat,
    this.lon,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
    lat: (json["lat"] as num?)?.toDouble(),
    lon: (json["lon"] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lon": lon,
  };
}
