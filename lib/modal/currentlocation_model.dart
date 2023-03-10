// To parse this JSON data, do
//
//     final currentlocation = currentlocationFromJson(jsonString);

import 'dart:convert';

Currentlocation currentlocationFromJson(String str) => Currentlocation.fromJson(json.decode(str));

String currentlocationToJson(Currentlocation data) => json.encode(data.toJson());

class Currentlocation {
  Currentlocation({
     this.status,
     this.message,
     this.data,
  });

  bool? status;
  String? message;
  Data? data;

  factory Currentlocation.fromJson(Map<String, dynamic> json) => Currentlocation(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    required this.empId,
    required this.date,
    required this.latitude,
    required this.longitude,
    required this.id,
  });

  int empId;
  DateTime date;
  String latitude;
  String longitude;
  int id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    empId: json["emp_id"],
    date: DateTime.parse(json["date"]),
    latitude: json["latitude"],
    longitude: json["longitude"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "emp_id": empId,
    "date": date.toIso8601String(),
    "latitude": latitude,
    "longitude": longitude,
    "id": id,
  };
}
