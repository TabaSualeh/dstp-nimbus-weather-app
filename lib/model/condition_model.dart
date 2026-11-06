class Condition {
  String? code;
  String? label;
  String? icon;

  Condition({
    this.code,
    this.label,
    this.icon,
  });

  factory Condition.fromJson(Map<String, dynamic> json) => Condition(
    code: json["code"],
    label: json["label"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "label": label,
    "icon": icon,
  };
}
