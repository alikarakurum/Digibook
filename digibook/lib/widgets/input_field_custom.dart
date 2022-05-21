
import 'package:flutter/material.dart';

class DecorationSpecific {
  InputDecoration textFieldStyle(
      {Icon icon,
      final String hintText,
      final String errorText,
      final Border border,
      final String labelText,
      final Widget suffixIcon,
      final errorStyle}) {
    return InputDecoration(
      errorStyle: TextStyle(color: Colors.orange[700], fontSize: 11),
      fillColor: Colors.orange[100],
      filled: true,
      suffixIcon: suffixIcon,
      icon: icon,
      labelText: labelText,
      hintText: hintText,
      contentPadding: EdgeInsets.all(10),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.brown[300], width: 3.5),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.brown[500], width: 3.5),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.orange[700], width: 3.5),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.orange[700], width: 3.5),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
