import 'package:flutter/material.dart';
import 'package:hadirin_app/constant/app_color.dart';
import 'package:hadirin_app/constant/app_style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isVisibility = false;
  bool isLoading = false;

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
                  AppStyle.buildTitle(
                    color: Color(0xFFffffff),
                    text: "Login to your account",
                  ),
                  SizedBox(height: 58),
                  Container(
                    height: 448,
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
                          AppStyle.buildTitle(
                            color: AppColor.coklat,
                            text: "Username",
                          ),
                          SizedBox(height: 14),
                          AppStyle.buildTextField(
                            controller: usernameController,
                            color: Color(0xffE6E6E6),
                          ),
                          SizedBox(height: 14),
                          AppStyle.buildTitle(
                            color: AppColor.coklat,
                            text: "Password",
                          ),
                          SizedBox(height: 14),
                          AppStyle.buildTextField(
                            controller: passwordController,
                            color: Color(0xffE6E6E6),
                            isVisibility: true,
                            isPassword: true,
                          ),
                          SizedBox(height: 18),

                          Row(
                            children: [
                              // Checkbox(value: value, onChanged: onChanged)
                              AppStyle.buildTitle(
                                text: "Remember me",
                                fontWeight: FontWeight.w300,
                              ),
                              Spacer(),
                              AppStyle.titleBold(text: "Forgot Password"),
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

  Widget buildTextField({
    String? hintText,
    bool isPassword = false,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lengkapi data';
        }
        return null;
      },
      obscureText: isPassword ? isVisibility : false,

      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black54),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white38, width: 0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white38),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white38, width: 0),
        ),
        suffixIcon:
            isPassword
                ? IconButton(
                  onPressed: () {
                    setState(() {
                      isVisibility = !isVisibility;
                    });
                  },
                  icon: Icon(
                    isVisibility ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black54,
                  ),
                )
                : null,
      ),
    );
  }
}
