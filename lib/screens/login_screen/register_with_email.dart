import 'package:flutter/material.dart';
import 'package:study_english_app/widgets/button/button.dart';
import 'package:study_english_app/core/color.dart';
import 'package:study_english_app/core/text.dart';
import 'package:study_english_app/widgets/text/edit_text.dart';
import 'package:study_english_app/widgets/text/edit_text_with_suffix.dart';
import 'package:study_english_app/widgets/text/terms_of_service.dart';

import '../main_screen/main_screen.dart';

class RegisterWithEmail extends StatelessWidget {
  static const String route = "RegisterWithEmail";

  const RegisterWithEmail({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Tạo tài khoản",
                style: AppTextStyles.headline,
              ),
            ),
            SizedBox(height: 24),
            LoginForm(width: width),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.width});

  final double width;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isActive = false;
  TextEditingController email = TextEditingController(text: "");
  TextEditingController password = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        children: [
          editText("Email", email, () {
            setState(() {
              isActived(email.text, password.text);
            });
          }, () {}),
          SizedBox(height: 16),
          editTextWithSuffix("Password", password, () {
            setState(() {
              isActived(email.text, password.text);
            });
          }, () {}),
          SizedBox(height: 24),
          SizedBox(width: widget.width / 2, child: termOfService()),
          SizedBox(height: 24),
          SizedBox(
            width: widget.width,
            height: 40,
            child: Opacity(
              opacity: isActive ? 1 : 0.3,
              child: IgnorePointer(
                ignoring: !isActive,
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: isActive ? AppColors.primaryBlue : AppColors.lightGray,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(MainScreen.route);
                    },
                    borderRadius: BorderRadius.circular(27),
                    highlightColor: AppColors.primaryDark,
                    child: Center(
                      child: Text(
                        "Tạo tài khoản",
                        style: isActive ? AppTextStyles.primaryButton : AppTextStyles.button,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void isActived(String emailText, String passwordText) {
    final active = emailText.isNotEmpty && passwordText.isNotEmpty;
    if (active != isActive) {
      isActive = active;
    }
  }
}
