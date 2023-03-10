// To parse this JSON data, do
//
//     final checkIn = checkInFromJson(jsonString);

import 'dart:convert';

CheckIn checkInFromJson(String str) => CheckIn.fromJson(json.decode(str));

String checkInToJson(CheckIn data) => json.encode(data.toJson());

class CheckIn {
  CheckIn({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  Data? data;

  factory CheckIn.fromJson(Map<String?, dynamic> json) => CheckIn(
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
    this.empId,
    this.workIn,
    this.workOut,
    this.purpose,
    this.contact,
    this.inLatitude,
    this.inLongitude,
    this.inAddress,
    this.id,
  });

  int? empId;
  DateTime? workIn;
  DateTime? workOut;
  String? purpose;
  String? contact;
  String? inLatitude;
  String? inLongitude;
  dynamic inAddress;
  int? id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        empId: json["emp_id"],
        workIn: DateTime.parse(json["work_in"]),
        workOut: DateTime.parse(json["work_out"]),
        purpose: json["purpose"],
        contact: json["contact"],
        inLatitude: json["in_latitude"],
        inLongitude: json["in_longitude"],
        inAddress: json["in_address"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "emp_id": empId,
        "work_in": workIn!.toIso8601String(),
        "work_out": workOut!.toIso8601String(),
        "purpose": purpose,
        "contact": contact,
        "in_latitude": inLatitude,
        "in_longitude": inLongitude,
        "in_address": inAddress,
        "id": id,
      };
}
