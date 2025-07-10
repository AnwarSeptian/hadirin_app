import 'package:flutter/material.dart';
import 'package:hadirin_app/constant/app_color.dart';
import 'package:hadirin_app/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null); // Inisialisasi locale Indonesia

  runApp(MyApp()); // ganti dengan widget utama kamu
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.blue),
      ),
      home: SplashScreen(),
    );
  }
}
