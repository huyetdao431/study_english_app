import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:study_english_app/widgets/text/link_text.dart';
import 'package:url_launcher/url_launcher.dart';

Widget termOfService() {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      style: TextStyle(color: Colors.black, fontSize: 14),
      children: [
        TextSpan(text: "Bằng việc đăng ký, bạn chấp nhận "),
        linkText("Điều khoản dịch vụ", null, (){}),
        TextSpan(text: " và "),
        linkText("Chính sách quyền riêng tư", null, (){}),
        TextSpan(text: " của chúng tôi."),
      ],
    ),
  );
}
