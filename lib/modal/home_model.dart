// To parse this JSON data, do
//
//     final homelistmodel = homelistmodelFromJson(jsonString);

import 'dart:convert';

Homelistmodel homelistmodelFromJson(String str) => Homelistmodel.fromJson(json.decode(str));

String homelistmodelToJson(Homelistmodel data) => json.encode(data.toJson());

class Homelistmodel {
  Homelistmodel({
     this.status,
     this.message,
     this.data,
  });

  bool? status;
  String? message;
  List<HomeList>? data;

  factory Homelistmodel.fromJson(Map<String, dynamic> json) => Homelistmodel(
    status: json["status"],
    message: json["message"],
    data: List<HomeList>.from(json["data"].map((x) => HomeList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class HomeList {
  HomeList({
    required this.totalTime,
    required this.breakTime,
    required this.productiveTime,
    required this.attendanceData,
    this.breakData,
  });

  Time? totalTime;
  Time? breakTime;
  Time? productiveTime;
  AttendanceData? attendanceData;
  dynamic breakData;

  factory HomeList.fromJson(Map<String, dynamic> json) => HomeList(
    totalTime: Time.fromJson(json["total_time"]),
    breakTime: Time.fromJson(json["break_time"]),
    productiveTime: Time.fromJson(json["productive_time"]),
    attendanceData: AttendanceData.fromJson(json["attendance_data"]),
    breakData: json["break_data"],
  );

  Map<String, dynamic> toJson() => {
    "total_time": totalTime!.toJson(),
    "break_time": breakTime!.toJson(),
    "productive_time": productiveTime!.toJson(),
    "attendance_data": attendanceData!.toJson(),
    "break_data": breakData,
  };
}

class AttendanceData {
  AttendanceData({
    required this.id,
    required this.empId,
    required this.workIn,
    required this.workOut,
    required this.guest,
    required this.purpose,
    required this.contact,
    required this.inLatitude,
    required this.inLongitude,
    this.inAddress,
    this.outLatitude,
    this.outLongitude,
    this.outAddress,
  });

  int id;
  int empId;
  DateTime workIn;
  DateTime workOut;
  String guest;
  String purpose;
  String contact;
  String inLatitude;
  String inLongitude;
  dynamic inAddress;
  dynamic outLatitude;
  dynamic outLongitude;
  dynamic outAddress;

  factory AttendanceData.fromJson(Map<String, dynamic> json) => AttendanceData(
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
    "work_in": workIn.toIso8601String(),
    "work_out": workOut.toIso8601String(),
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

class Time {
  Time({
    required this.time,
    required this.h,
    required this.i,
    required this.s,
  });

  String time;
  String h;
  String i;
  String s;

  factory Time.fromJson(Map<String, dynamic> json) => Time(
    time: json["time"],
    h: json["h"],
    i: json["i"],
    s: json["s"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "h": h,
    "i": i,
    "s": s,
  };
}
