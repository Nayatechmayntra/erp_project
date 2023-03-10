// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  Login({
     this.status,
     this.token,
     this.message,
     this.data,
  });

  bool? status;
  String? token;
  String? message;
  Data? data;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
    status: json["status"],
    token: json["token"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "token": token,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  Data({
     this.employeeData,
     this.attendanceData,
  });

  EmployeeData? employeeData;
  AttendanceData? attendanceData;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    employeeData: EmployeeData.fromJson(json["employee_data"]),
    attendanceData: AttendanceData.fromJson(json["attendance_data"]),
  );

  Map<String, dynamic> toJson() => {
    "employee_data": employeeData!.toJson(),
    "attendance_data": attendanceData!.toJson(),
  };
}

class AttendanceData {
  AttendanceData({
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

class EmployeeData {
  EmployeeData({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
  });

  int id;
  String name;
  String email;
  int mobile;

  factory EmployeeData.fromJson(Map<String, dynamic> json) => EmployeeData(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile": mobile,
  };
}
