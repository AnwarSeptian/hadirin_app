import 'package:flutter/material.dart';
import 'package:hadirin_app/constant/app_color.dart';
import 'package:hadirin_app/constant/app_style.dart';
import 'package:hadirin_app/screen/auth/register.dart';
import 'package:hadirin_app/screen/main_screen/button_navbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = true;
  bool isLoading = false;
  bool rememberMe = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.coklat,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Spacer(),

                Container(
                  width: double.infinity,
                  height: 350,
                  decoration: BoxDecoration(
                    color: AppColor.brown,
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
                  Spacer(),
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
                          SizedBox(height: 53),
                          AppStyle.normalTitle(
                            color: AppColor.coklat,
                            text: "Username",
                          ),
                          SizedBox(height: 14),
                          AppStyle.TextField(
                            controller: usernameController,
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

                          Row(
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: Color(0xffE6E6E6),
                                ),
                                child: Checkbox(
                                  value: rememberMe,
                                  onChanged: (value) {},
                                ),
                              ),
                              SizedBox(width: 4),
                              AppStyle.normalTitle(
                                text: "Remember me",
                                fontWeight: FontWeight.w300,
                              ),
                            ],
                          ),
                          SizedBox(height: 44),

                          SizedBox(
                            height: 56,
                            width: double.infinity,
                            child: AppStyle.buttonAuth(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ButtonNavbar(),
                                  ),
                                  (route) => false,
                                );
                              },
                              text: "Login",
                            ),
                          ),
                          SizedBox(height: 18),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppStyle.normalTitle(text: "Don't have account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterScreen(),
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
    );
  }
}
