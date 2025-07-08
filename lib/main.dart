import 'package:flutter/material.dart';
import 'package:hadirin_app/screen/auth/login.dart';
import 'package:hadirin_app/screen/auth/register.dart';
import 'package:hadirin_app/constant/app_color.dart';

void main() {
  runApp(const MyApp());
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
      home: LoginScreen(),
    );
  }
}
