// To parse this JSON data, do
//
//     final changepassword = changepasswordFromJson(jsonString);

import 'dart:convert';

Changepassword changepasswordFromJson(String str) => Changepassword.fromJson(json.decode(str));

String changepasswordToJson(Changepassword data) => json.encode(data.toJson());

class Changepassword {
  Changepassword({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<dynamic> data;

  factory Changepassword.fromJson(Map<String, dynamic> json) => Changepassword(
    status: json["status"],
    message: json["message"],
    data: List<dynamic>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x)),
  };
}
