import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

TextSpan linkText(String text, double? fontSize, VoidCallback onTap) {
  return TextSpan(
    text: text,
    style: TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold
    ),
    recognizer: TapGestureRecognizer() ..onTap = onTap
  );
}
