import 'package:flutter/material.dart';
import 'package:study_english_app/widgets/text/link_text.dart';

import '../../helpers/helper_implement.dart';
import '../../helpers/helpers.dart';

Widget termOfService() {
  Helper helper = HelperImplement();
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      style: TextStyle(color: Colors.black, fontSize: 14),
      children: [
        TextSpan(text: "Bằng việc đăng ký, bạn chấp nhận "),
        linkText("Điều khoản dịch vụ", null, () async {
          try {
            await helper.openUrl('');
          } catch (e) {
            print('Lỗi mở link: $e');
          }
        }),
        TextSpan(text: " và "),
        linkText("Chính sách quyền riêng tư", null, () async {
          await helper.openUrl('');
        }),
        TextSpan(text: " của chúng tôi."),
      ],
    ),
  );
}
