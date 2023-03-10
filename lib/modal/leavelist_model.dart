// To parse this JSON data, do
//
//     final leavelist = leavelistFromJson(jsonString);

import 'dart:convert';

Leavelist leavelistFromJson(String str) => Leavelist.fromJson(json.decode(str));

String leavelistToJson(Leavelist data) => json.encode(data.toJson());

class Leavelist {
  Leavelist({
     this.status,
     this.message,
     this.data,
  });

  bool? status;
  String? message;
  List<Datum>? data;

  factory Leavelist.fromJson(Map<String, dynamic> json) => Leavelist(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.supervisorId,
    required this.empId,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    required this.leaveType,
    required this.halfDay,
    required this.dayType,
  });

  int id;
  int supervisorId;
  int empId;
  DateTime startDate;
  DateTime endDate;
  String reason;
  String status;
  String leaveType;
  int halfDay;
  String dayType;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    supervisorId: json["supervisor_id"],
    empId: json["emp_id"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    reason: json["reason"],
    status: json["status"],
    leaveType: json["leave_type"],
    halfDay: json["half_day"],
    dayType: json["day_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "supervisor_id": supervisorId,
    "emp_id": empId,
    "start_date": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "end_date": "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "reason": reason,
    "status": status,
    "leave_type": leaveType,
    "half_day": halfDay,
    "day_type": dayType,
  };
}
