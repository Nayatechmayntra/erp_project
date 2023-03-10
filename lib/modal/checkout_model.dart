// To parse this JSON data, do
//
//     final checkout = checkoutFromJson(jsonString);

import 'dart:convert';

Checkout checkoutFromJson(String str) => Checkout.fromJson(json.decode(str));

String checkoutToJson(Checkout data) => json.encode(data.toJson());

class Checkout {
  Checkout({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  Data? data;

  factory Checkout.fromJson(Map<String, dynamic> json) => Checkout(
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
    this.id,
    this.empId,
    this.workIn,
    this.workOut,
    this.guest,
    this.purpose,
    this.contact,
    this.inLatitude,
    this.inLongitude,
    this.inAddress,
    this.outLatitude,
    this.outLongitude,
    this.outAddress,
  });

  int? id;
  int? empId;
  DateTime? workIn;
  DateTime? workOut;
  String? guest;
  String? purpose;
  String? contact;
  String? inLatitude;
  String? inLongitude;
  dynamic inAddress;
  String? outLatitude;
  String? outLongitude;
  dynamic outAddress;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        empId: json["emp_id"],
        workIn: DateTime.parse(json["work_in"]),
        workOut: DateTime.parse(json["work_out"]),
        guest: json["guest"],
        purpose: json["purpose"],
        contact: json["contact"],
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
        "work_in": workIn!.toIso8601String(),
        "work_out": workOut!.toIso8601String(),
        "guest": guest,
        "purpose": purpose,
        "contact": contact,
        "in_latitude": inLatitude,
        "in_longitude": inLongitude,
        "in_address": inAddress,
        "out_latitude": outLatitude,
        "out_longitude": outLongitude,
        "out_address": outAddress,
      };
}
