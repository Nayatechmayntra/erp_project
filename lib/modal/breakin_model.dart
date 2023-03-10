// To parse this JSON data, do
//
//     final breakin = breakinFromJson(jsonString);

import 'dart:convert';

Breakin breakinFromJson(String str) => Breakin.fromJson(json.decode(str));

String breakinToJson(Breakin data) => json.encode(data.toJson());

class Breakin {
  Breakin({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory Breakin.fromJson(Map<String, dynamic> json) => Breakin(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.empId,
    required this.outime,
    required this.intime,
    required this.breakDate,
    required this.inLatitude,
    required this.inLongitude,
    required this.id,
  });

  int empId;
  DateTime outime;
  DateTime intime;
  DateTime breakDate;
  String inLatitude;
  String inLongitude;
  int id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    empId: json["emp_id"],
    outime: DateTime.parse(json["outime"]),
    intime: DateTime.parse(json["intime"]),
    breakDate: DateTime.parse(json["break_date"]),
    inLatitude: json["in_latitude"],
    inLongitude: json["in_longitude"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "emp_id": empId,
    "outime": outime.toIso8601String(),
    "intime": intime.toIso8601String(),
    "break_date": "${breakDate.year.toString().padLeft(4, '0')}-${breakDate.month.toString().padLeft(2, '0')}-${breakDate.day.toString().padLeft(2, '0')}",
    "in_latitude": inLatitude,
    "in_longitude": inLongitude,
    "id": id,
  };
}
