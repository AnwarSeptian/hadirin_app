import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadirin_app/constant/app_color.dart';

class AppStyle {
  static Text titleBold({String? text, double? fontSize, Color? color}) {
    return Text(
      text ?? "",
      style: GoogleFonts.inter(
        textStyle: TextStyle(
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  static Text normalTitle({
    String? text,
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return Text(
      text ?? "",
      style: GoogleFonts.inter(
        textStyle: TextStyle(
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.normal,
          color: color,
        ),
      ),
    );
  }

  static TextFormField TextField({
    String? hintText,
    Color? color,
    Color? colorItem,

    bool isPassword = false,
    bool isVisibility = false,
    void Function()? onPressed,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      style: GoogleFonts.inter(
        textStyle: TextStyle(
          color: colorItem ?? Colors.black,
          fontWeight: FontWeight.normal,
        ),
      ),
      obscureText: isPassword ? isVisibility : false,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: AppColor.coklat, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: AppColor.coklat, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Color(0xffE6E6E6), width: 1.0),
        ),
        filled: true,
        fillColor: color,
        suffixIcon:
            isPassword
                ? IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    isVisibility ? Icons.visibility_off : Icons.visibility,
                    color: colorItem,
                  ),
                )
                : null,
      ),
    );
  }

  static ElevatedButton buttonAuth({void Function()? onPressed, String? text}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: titleBold(text: text, color: Colors.white),

      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
