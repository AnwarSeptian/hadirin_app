// To parse this JSON dataCheckin, do
//
//     final checkInResponses = checkInResponsesFromJson(jsonString);

import 'dart:convert';

CheckInResponses checkInResponsesFromJson(String str) =>
    CheckInResponses.fromJson(json.decode(str));

String checkInResponsesToJson(CheckInResponses data) =>
    json.encode(data.toJson());

class CheckInResponses {
  String message;
  DataCheckin data;

  CheckInResponses({required this.message, required this.data});

  factory CheckInResponses.fromJson(Map<String, dynamic> json) =>
      CheckInResponses(
        message: json["message"],
        data: DataCheckin.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class DataCheckin {
  int id;
  DateTime attendanceDate;
  String checkInTime;
  double checkInLat;
  double checkInLng;
  String checkInLocation;
  String checkInAddress;
  String status;
  dynamic alasanIzin;

  DataCheckin({
    required this.id,
    required this.attendanceDate,
    required this.checkInTime,
    required this.checkInLat,
    required this.checkInLng,
    required this.checkInLocation,
    required this.checkInAddress,
    required this.status,
    required this.alasanIzin,
  });

  factory DataCheckin.fromJson(Map<String, dynamic> json) => DataCheckin(
    id: json["id"],
    attendanceDate: DateTime.parse(json["attendance_date"]),
    checkInTime: json["check_in_time"],
    checkInLat: json["check_in_lat"]?.toDouble(),
    checkInLng: json["check_in_lng"]?.toDouble(),
    checkInLocation: json["check_in_location"],
    checkInAddress: json["check_in_address"],
    status: json["status"],
    alasanIzin: json["alasan_izin"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attendance_date":
        "${attendanceDate.year.toString().padLeft(4, '0')}-${attendanceDate.month.toString().padLeft(2, '0')}-${attendanceDate.day.toString().padLeft(2, '0')}",
    "check_in_time": checkInTime,
    "check_in_lat": checkInLat,
    "check_in_lng": checkInLng,
    "check_in_location": checkInLocation,
    "check_in_address": checkInAddress,
    "status": status,
    "alasan_izin": alasanIzin,
  };
}

// To parse this JSON data, do
//
//     final checkoutResponses = checkoutResponsesFromJson(jsonString);

CheckoutResponses checkoutResponsesFromJson(String str) =>
    CheckoutResponses.fromJson(json.decode(str));

String checkoutResponsesToJson(CheckoutResponses data) =>
    json.encode(data.toJson());

class CheckoutResponses {
  String message;
  DataCheckout data;

  CheckoutResponses({required this.message, required this.data});

  factory CheckoutResponses.fromJson(Map<String, dynamic> json) =>
      CheckoutResponses(
        message: json["message"],
        data: DataCheckout.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class DataCheckout {
  int id;
  DateTime attendanceDate;
  String checkInTime;
  String checkOutTime;
  String checkInAddress;
  String checkOutAddress;
  String checkInLocation;
  String checkOutLocation;
  String status;
  dynamic alasanIzin;

  DataCheckout({
    required this.id,
    required this.attendanceDate,
    required this.checkInTime,
    required this.checkOutTime,
    required this.checkInAddress,
    required this.checkOutAddress,
    required this.checkInLocation,
    required this.checkOutLocation,
    required this.status,
    required this.alasanIzin,
  });

  factory DataCheckout.fromJson(Map<String, dynamic> json) => DataCheckout(
    id: json["id"],
    attendanceDate: DateTime.parse(json["attendance_date"]),
    checkInTime: json["check_in_time"],
    checkOutTime: json["check_out_time"],
    checkInAddress: json["check_in_address"],
    checkOutAddress: json["check_out_address"],
    checkInLocation: json["check_in_location"],
    checkOutLocation: json["check_out_location"],
    status: json["status"],
    alasanIzin: json["alasan_izin"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attendance_date":
        "${attendanceDate.year.toString().padLeft(4, '0')}-${attendanceDate.month.toString().padLeft(2, '0')}-${attendanceDate.day.toString().padLeft(2, '0')}",
    "check_in_time": checkInTime,
    "check_out_time": checkOutTime,
    "check_in_address": checkInAddress,
    "check_out_address": checkOutAddress,
    "check_in_location": checkInLocation,
    "check_out_location": checkOutLocation,
    "status": status,
    "alasan_izin": alasanIzin,
  };
}

// To parse this JSON data, do
//
//     final attendaceResponses = attendaceResponsesFromJson(jsonString);

AttendaceResponses attendaceResponsesFromJson(String str) =>
    AttendaceResponses.fromJson(json.decode(str));

String attendaceResponsesToJson(AttendaceResponses data) =>
    json.encode(data.toJson());

class AttendaceResponses {
  String message;
  List<DataAttendace> data;

  AttendaceResponses({required this.message, required this.data});

  factory AttendaceResponses.fromJson(Map<String, dynamic> json) =>
      AttendaceResponses(
        message: json["message"],
        data: List<DataAttendace>.from(
          json["data"].map((x) => DataAttendace.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DataAttendace {
  int id;
  DateTime attendanceDate;
  String checkInTime;
  dynamic checkOutTime;
  double checkInLat;
  double checkInLng;
  dynamic checkOutLat;
  dynamic checkOutLng;
  String checkInAddress;
  dynamic checkOutAddress;
  String checkInLocation;
  dynamic checkOutLocation;
  String status;
  dynamic alasanIzin;

  DataAttendace({
    required this.id,
    required this.attendanceDate,
    required this.checkInTime,
    required this.checkOutTime,
    required this.checkInLat,
    required this.checkInLng,
    required this.checkOutLat,
    required this.checkOutLng,
    required this.checkInAddress,
    required this.checkOutAddress,
    required this.checkInLocation,
    required this.checkOutLocation,
    required this.status,
    required this.alasanIzin,
  });

  factory DataAttendace.fromJson(Map<String, dynamic> json) => DataAttendace(
    id: json["id"],
    attendanceDate: DateTime.parse(json["attendance_date"]),
    checkInTime: json["check_in_time"],
    checkOutTime: json["check_out_time"],
    checkInLat: json["check_in_lat"]?.toDouble(),
    checkInLng: json["check_in_lng"]?.toDouble(),
    checkOutLat: json["check_out_lat"],
    checkOutLng: json["check_out_lng"],
    checkInAddress: json["check_in_address"],
    checkOutAddress: json["check_out_address"],
    checkInLocation: json["check_in_location"],
    checkOutLocation: json["check_out_location"],
    status: json["status"],
    alasanIzin: json["alasan_izin"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attendance_date":
        "${attendanceDate.year.toString().padLeft(4, '0')}-${attendanceDate.month.toString().padLeft(2, '0')}-${attendanceDate.day.toString().padLeft(2, '0')}",
    "check_in_time": checkInTime,
    "check_out_time": checkOutTime,
    "check_in_lat": checkInLat,
    "check_in_lng": checkInLng,
    "check_out_lat": checkOutLat,
    "check_out_lng": checkOutLng,
    "check_in_address": checkInAddress,
    "check_out_address": checkOutAddress,
    "check_in_location": checkInLocation,
    "check_out_location": checkOutLocation,
    "status": status,
    "alasan_izin": alasanIzin,
  };
}
