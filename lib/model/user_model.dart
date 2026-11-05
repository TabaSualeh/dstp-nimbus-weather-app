// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final UserClass? user;
  final String? token;
  final int? expiresInSeconds;

  User({
    this.user,
    this.token,
    this.expiresInSeconds,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    user: json["user"] == null ? null : UserClass.fromJson(json["user"]),
    token: json["token"],
    expiresInSeconds: json["expiresInSeconds"],
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "token": token,
    "expiresInSeconds": expiresInSeconds,
  };
}

class UserClass {
  final int? id;
  final String? name;
  final String? email;
  final DateTime? createdAt;

  UserClass({
    this.id,
    this.name,
    this.email,
    this.createdAt,
  });

  factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "createdAt": createdAt?.toIso8601String(),
  };
}
