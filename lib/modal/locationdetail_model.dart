// To parse this JSON data, do
//
//     final locationdetail = locationdetailFromJson(jsonString);

import 'dart:convert';

Locationdetail locationdetailFromJson(String str) => Locationdetail.fromJson(json.decode(str));

String locationdetailToJson(Locationdetail data) => json.encode(data.toJson());

class Locationdetail {
  Locationdetail({
     this.status,
     this.message,
     this.data,
  });

  bool? status;
  String? message;
  Data? data;

  factory Locationdetail.fromJson(Map<String, dynamic> json) => Locationdetail(
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
    required this.addressData,
  });

  String addressData;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    addressData: json["address_data"],
  );

  Map<String, dynamic> toJson() => {
    "address_data": addressData,
  };
}
