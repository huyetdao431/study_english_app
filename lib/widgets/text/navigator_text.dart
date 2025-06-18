import 'package:flutter/cupertino.dart';

GestureDetector navigatorText(String text, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Text(text),
  );
}