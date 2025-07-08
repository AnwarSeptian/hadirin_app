import 'dart:convert';

import 'package:hadirin_app/model/user_response.dart';
import 'package:hadirin_app/utils/endpoint.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<Map<String, dynamic>> registerUser({
    required String email,
    required String name,
    required String password,
    required String gender,
    required int trainingId,
    required int batchId,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.register),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "jenis_kelamin": gender,
        "batch_id": batchId,
        "training_id": trainingId,
      }),
    );
    if (response.statusCode == 200) {
      return registerResponseFromJson(response.body).toJson();
    } else {
      print(response.body);
      throw Exception("${response.statusCode}");
    }
  }
}
