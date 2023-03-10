// To parse this JSON data, do
//
//     final breakout = breakoutFromJson(jsonString);

import 'dart:convert';

Breakout breakoutFromJson(String str) => Breakout.fromJson(json.decode(str));

String breakoutToJson(Breakout data) => json.encode(data.toJson());

class Breakout {
  Breakout({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory Breakout.fromJson(Map<String, dynamic> json) => Breakout(
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
    required this.id,
    required this.empId,
    required this.outime,
    required this.intime,
    required this.breakDate,
    this.purpose,
    required this.createdAt,
    required this.inLatitude,
    required this.inLongitude,
    this.inAddress,
    required this.outLatitude,
    required this.outLongitude,
    this.outAddress,
  });

  int id;
  int empId;
  DateTime outime;
  DateTime intime;
  DateTime breakDate;
  dynamic purpose;
  DateTime createdAt;
  String inLatitude;
  String inLongitude;
  dynamic inAddress;
  String outLatitude;
  String outLongitude;
  dynamic outAddress;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    empId: json["emp_id"],
    outime: DateTime.parse(json["outime"]),
    intime: DateTime.parse(json["intime"]),
    breakDate: DateTime.parse(json["break_date"]),
    purpose: json["purpose"],
    createdAt: DateTime.parse(json["created_at"]),
    inLatitude: json["in_latitude"],
    inLongitude: json["in_longitude"],
    inAddress: json["in_address"],
    outLatitude: json["out_latitude"],
    outLongitude: json["out_longitude"],
    outAddress: json["out_address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "emp_id": empId,
    "outime": outime.toIso8601String(),
    "intime": intime.toIso8601String(),
    "break_date": breakDate.toIso8601String(),
    "purpose": purpose,
    "created_at": createdAt.toIso8601String(),
    "in_latitude": inLatitude,
    "in_longitude": inLongitude,
    "in_address": inAddress,
    "out_latitude": outLatitude,
    "out_longitude": outLongitude,
    "out_address": outAddress,
  };
}
