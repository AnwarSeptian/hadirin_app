import 'dart:convert';
import 'dart:io';

import 'package:hadirin_app/model/user_response.dart';
import 'package:hadirin_app/utils/endpoint.dart';
import 'package:hadirin_app/utils/shared_preference.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<RegisterResponse> registerUser({
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

    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    try {
      return registerResponseFromJson(response.body);
    } catch (e) {
      print("❌ Gagal parsing JSON ke model: $e");
      throw Exception("Parsing error");
    }
  }

  static Future<LoginRespons> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.login),
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password},
    );

    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      try {
        return loginResponsFromJson(response.body);
      } catch (e) {
        print("❌ Gagal parsing JSON ke model: $e");
        throw Exception("Parsing error");
      }
    } else {
      throw Exception(response.body);
    }
  }

  Future<ProfileRespons> getProfile() async {
    String? token = await PreferenceHandler.getToken();
    final response = await http.get(
      Uri.parse(Endpoint.profile),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    print(response.body);

    if (response.statusCode == 200) {
      print(profileResponsFromJson(response.body));
      return profileResponsFromJson(response.body);
    } else {
      print('${response.statusCode}');
      throw Exception("${response.statusCode}");
    }
  }

  static Future<UploadProfileResponse> uploadProfilePhoto({
    required String token,
    required File photoFile,
  }) async {
    final url = Uri.parse(Endpoint.updateProfile);
    final bytes = await photoFile.readAsBytes();
    final base64Image = base64Encode(bytes);
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({'profile_photo': base64Image}),
    );
    print('Upload photo status: \\${response.statusCode}');
    print('Upload photo body: \\${response.body}');
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return UploadProfileResponse.fromJson(jsonBody);
    } else {
      throw Exception('Failed to upload profile photo: ${response.body}');
    }
  }

  Future<EditProfileResponse> updateProfile({required String name}) async {
    String? token = await PreferenceHandler.getToken();

    final response = await http.put(
      Uri.parse(Endpoint.profile),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: {"name": name},
    );
    print(response.body);
    if (response.statusCode == 200) {
      return EditProfileResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception("Gagal update profile : ${response.body}");
    }
  }

  static Future<UserListResponse> listUser() async {
    final response = await http.get(
      Uri.parse(Endpoint.user),
      headers: {"Accept": "application/json"},
    );
    print(response.body);

    if (response.statusCode == 200) {
      print(userListResponseFromJson(response.body));
      return UserListResponse.fromJson(jsonDecode(response.body));
    } else {
      print('${response.statusCode}');
      throw Exception("${response.statusCode}");
    }
  }
}
