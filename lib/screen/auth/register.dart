import 'package:flutter/material.dart';
import 'package:hadirin_app/constant/app_color.dart';
import 'package:hadirin_app/constant/app_style.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nohandphoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordVisible = true;

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
                    text: "Register",
                  ),
                  SizedBox(height: 14),
                  AppStyle.normalTitle(
                    color: Color(0xFFffffff),
                    text: "Register your account",
                  ),
                  SizedBox(height: 38),
                  Container(
                    height: 660,
                    width: 351,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 18),
                          AppStyle.normalTitle(
                            color: AppColor.coklat,
                            text: "Nama",
                          ),
                          SizedBox(height: 14),
                          AppStyle.TextField(
                            controller: nameController,
                            color: Color(0xffE6E6E6),
                            colorItem: AppColor.coklat,
                          ),
                          SizedBox(height: 14),

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
                          SizedBox(height: 58),
                          SizedBox(
                            height: 56,
                            width: double.infinity,
                            child: AppStyle.buttonAuth(
                              onPressed: () {},
                              text: "Register",
                            ),
                          ),
                          SizedBox(height: 18),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppStyle.normalTitle(text: "Have account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: AppStyle.titleBold(text: "Sign in"),
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
