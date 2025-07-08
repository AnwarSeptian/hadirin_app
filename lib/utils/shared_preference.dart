import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String _loginkey = "login";
  static const String _tokenkey = "token";

  static void saveLogin(bool login) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_loginkey, login);
  }

  static void saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_tokenkey, token);
  }

  static Future<bool> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    bool? login = prefs.getBool(_loginkey) ?? false;
    return login;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(_tokenkey);
    return token;
  }

  static void deleteLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_loginkey);
  }

  static void deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_tokenkey);
  }
}
