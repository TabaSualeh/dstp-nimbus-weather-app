import 'condition_model.dart';

class Weather {
  double? temperatureC;
  Condition? condition;

  Weather({
    this.temperatureC,
    this.condition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    temperatureC: json["temperatureC"]?.toDouble(),
    condition: json["condition"] == null ? null : Condition.fromJson(json["condition"]),
  );

  Map<String, dynamic> toJson() => {
    "temperatureC": temperatureC,
    "condition": condition?.toJson(),
  };
}
