// To parse this JSON data, do
//
//     final takeleave = takeleaveFromJson(jsonString);

import 'dart:convert';

Takeleave takeleaveFromJson(String str) => Takeleave.fromJson(json.decode(str));

String takeleaveToJson(Takeleave data) => json.encode(data.toJson());

class Takeleave {
  Takeleave({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory Takeleave.fromJson(Map<String, dynamic> json) => Takeleave(
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
     this.supervisorId,
     this.empId,
     this.startDate,
     this.endDate,
     this.reason,
     this.status,
     this.id,
  });

  int? supervisorId;
  int? empId;
  DateTime? startDate;
  DateTime? endDate;
  String? reason;
  int? status;
  int? id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    supervisorId: json["supervisor_id"],
    empId: json["emp_id"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    reason: json["reason"],
    status: json["status"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "supervisor_id": supervisorId,
    "emp_id": empId,
    "start_date": "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "end_date": "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
    "reason": reason,
    "status": status,
    "id": id,
  };
}
