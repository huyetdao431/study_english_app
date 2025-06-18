import 'package:flutter/material.dart';

Widget editText(String title, TextEditingController text, VoidCallback onChanged, VoidCallback onSubmitted) {
  return TextField(
    decoration: InputDecoration(
      labelText: title,
      border: InputBorder.none,
      filled: true,
      fillColor: Colors.white
    ),
    keyboardType: TextInputType.emailAddress,
    maxLength: 50,
    onChanged: (value) {
      text.text = value;
      onChanged();
    },
    onSubmitted: (value) => onSubmitted(),
  );
}
