import 'package:flutter/material.dart';

class AppStyle {
  static Text titleBold({String? text, double? fontSize, Color? color}) {
    return Text(
      text ?? "",
      style: TextStyle(
        fontSize: fontSize ?? 16,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  static Text buildTitle({
    String? text,
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return Text(
      text ?? "",
      style: TextStyle(
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color,
      ),
    );
  }

  static TextFormField buildTextField({
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
      style: TextStyle(
        color: color ?? Colors.black,
        fontWeight: FontWeight.normal,
      ),
      obscureText: isPassword ? isVisibility : false,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Color(0xffE6E6E6), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Color(0xffE6E6E6), width: 1.0),
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
                  onPressed: () {
                    onPressed;
                  },
                  icon: Icon(
                    isVisibility ? Icons.visibility_off : Icons.visibility,
                    color: colorItem,
                  ),
                )
                : null,
      ),
    );
  }
}
