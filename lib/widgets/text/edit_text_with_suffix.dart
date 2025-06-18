import 'package:flutter/material.dart';

Widget editTextWithSuffix(
  String title,
  TextEditingController text,
  VoidCallback onChanged,
  VoidCallback onSubmitted,
) {
  bool obscure = true;
  return StatefulBuilder(
    builder: (context, setState) {
      return TextField(
        decoration: InputDecoration(
          labelText: title,
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          suffixIcon: IconButton(
            onPressed: () => setState(() => obscure = !obscure),
            icon: Icon(
              obscure ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,
            ),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        maxLength: 50,
        obscureText: obscure,
        onChanged: (value) {
          text.text = value;
          onChanged();
        },
        onSubmitted: (value) => onSubmitted(),
      );
    },
  );
}
