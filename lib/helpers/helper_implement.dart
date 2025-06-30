import 'package:url_launcher/url_launcher.dart';

import 'helpers.dart';

class HelperImplement implements Helper {
  HelperImplement();
  @override
  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url.isEmpty ? 'https://google.com' : url);
    if(await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } else {
      throw "Không thể mở liên kết";
    }
  }

  @override
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w.-]+@[a-zA-Z\d.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  @override
  bool isValidPassword(String password) {
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{8,}$');
    return passwordRegex.hasMatch(password);
  }
}