import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hadirin_app/api/user_api.dart';
import 'package:hadirin_app/constant/app_color.dart';
import 'package:hadirin_app/constant/app_style.dart';
import 'package:hadirin_app/screen/auth/register.dart';
import 'package:hadirin_app/screen/main_screen/button_navbar.dart';
import 'package:hadirin_app/utils/shared_preference.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = true;
  bool isLoading = false;
  bool rememberMe = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    setState(() {
      isLoading = true;
    });

    try {
      final res = await UserService.login(
        email: emailController.text,
        password: passwordController.text,
      );
      PreferenceHandler.saveToken(res.data.token);
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(message: "Login Berhasil"),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ButtonNavbar()),
        (route) => false,
      );
    } catch (e) {
      String pesanError = "Gagal login. Pastikan email dan password benar.";

      try {
        final json = jsonDecode(e.toString());
        if (json["errors"] != null) {
          pesanError = (json["errors"] as Map<String, dynamic>).entries
              .map((e) => e.value.join(', '))
              .join('\n');
        } else if (json["message"] != null) {
          pesanError = json["message"];
        }
      } catch (_) {}

      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(message: pesanError),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: AppColor.blue,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 500),
                    Container(
                      width: double.infinity,
                      height: 350,
                      decoration: BoxDecoration(
                        color: AppColor.bluelight,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(100),
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: 200),
                      AppStyle.titleBold(
                        color: Color(0xFFffffff),
                        fontSize: 32,
                        text: "Welcome Back",
                      ),
                      SizedBox(height: 14),
                      AppStyle.normalTitle(
                        color: Color(0xFFffffff),
                        text: "Login to your account",
                      ),
                      SizedBox(height: 58),
                      Container(
                        height: 500,
                        width: 351,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              AppStyle.normalTitle(
                                color: AppColor.coklat,
                                text: "Email",
                              ),
                              SizedBox(height: 14),
                              AppStyle.TextField(
                                controller: emailController,
                                color: Color(0xffE6E6E6),
                                colorItem: AppColor.coklat,
                              ),
                              SizedBox(height: 14),
                              AppStyle.normalTitle(
                                color: AppColor.coklat,
                                text: "Password",
                              ),
                              SizedBox(height: 14),
                              AppStyle.TextField(
                                controller: passwordController,
                                color: Color(0xffE6E6E6),
                                isPassword: true,
                                isVisibility: passwordVisible,
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                              ),
                              SizedBox(height: 18),

                              SizedBox(height: 44),

                              SizedBox(
                                height: 56,
                                width: double.infinity,
                                child: AppStyle.buttonAuth(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      login();
                                      print('Email : ${emailController.text}');
                                    }
                                  },
                                  text: "Login",
                                ),
                              ),
                              SizedBox(height: 18),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppStyle.normalTitle(
                                    text: "Don't have account?",
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => RegisterScreen(),
                                        ),
                                      );
                                    },
                                    child: AppStyle.titleBold(text: "Sign Up"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
