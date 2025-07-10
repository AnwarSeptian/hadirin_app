import 'package:flutter/material.dart';
import 'package:hadirin_app/screen/auth/login.dart';
import 'package:hadirin_app/screen/main_screen/button_navbar.dart';
import 'package:hadirin_app/utils/shared_preference.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void changePage() {
    Future.delayed(Duration(seconds: 3), () async {
      String? isLogin = await PreferenceHandler.getToken();
      print("isLogin : $isLogin");

      if (isLogin != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ButtonNavbar()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      }
    });
  }

  @override
  void initState() {
    changePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),

            Image.asset("assets/images/logohadirin.png"),
            SizedBox(height: 20),
            Text(
              "v 1.0.0",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
