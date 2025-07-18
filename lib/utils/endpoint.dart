class Endpoint {
  static const String baseUrl = "https://appabsensi.mobileprojp.com/api";
  static const String register = "$baseUrl/register";
  static const String training = "$baseUrl/trainings";
  static const String batch = "$baseUrl/batches";
  static const String login = "$baseUrl/login";
  static const String profile = "$baseUrl/profile";
  static const String absen = "$baseUrl/absen";
  static const String checkin = "$absen/check-in";
  static const String checkout = "$absen/check-out";
  static const String history = "$absen/history";
  static const String leave = "$baseUrl/izin";
  static const String updateProfile = "$profile/photo";
  static const String user = "$baseUrl/users";
  static const String statistikAbsen = "$absen/stats";
  static const String baseImageUrl =
      "https://appabsensi.mobileprojp.com/public/";
}
