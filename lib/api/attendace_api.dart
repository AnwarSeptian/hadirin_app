import 'dart:convert';

import 'package:hadirin_app/model/attendace_response.dart';
import 'package:hadirin_app/utils/endpoint.dart';
import 'package:hadirin_app/utils/shared_preference.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AttendaceApi {
  static Future<CheckInResponses> postCheckIn({
    required double lat,
    required double lng,
    required String location,
    required String address,
  }) async {
    String? token = await PreferenceHandler.getToken();
    final now = DateTime.now();
    final checkInTime = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    final response = await http.post(
      Uri.parse(Endpoint.checkin),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "attendance_date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "check_in": checkInTime,
        "check_in_lat": lat,
        "check_in_lng": lng,
        "check_in_location": location,
        "check_in_address": address,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
      return checkInResponsesFromJson(response.body);
    } else {
      print(response.body);
      throw jsonDecode(response.body)['message'] ?? 'Terjadi Kesalahan';
    }
  }

  static Future<CheckoutResponses> postCheckout({
    required double lat,
    required double lng,
    required String location,
    required String address,
  }) async {
    String? token = await PreferenceHandler.getToken();
    final now = DateTime.now();
    final checkInTime = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    final response = await http.post(
      Uri.parse(Endpoint.checkout),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "attendance_date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "check_out": checkInTime,
        "check_out_lat": lat,
        "check_out_lng": lng,
        "check_out_location": location,
        "check_out_address": address,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
      return checkoutResponsesFromJson(response.body);
    } else {
      print(response.body);
      throw jsonDecode(response.body)['message'] ?? 'Terjadi Kesalahan';
    }
  }

  static Future<AttendaceResponses> historyAbsen() async {
    String? token = await PreferenceHandler.getToken();
    final response = await http.get(
      Uri.parse(Endpoint.history),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    print("Respons :${response.body}");

    if (response.statusCode == 200) {
      print(attendaceResponsesFromJson(response.body).toJson());
      return attendaceResponsesFromJson(response.body);
    } else {
      throw Exception("Gagal Memuat data: ${response.body}");
    }
  }
}
