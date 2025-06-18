import 'package:flutter/material.dart';
import 'package:study_english_app/screens/main_screen/main_screen.dart';

import '../../widgets/button/primary_button.dart';
import '../../core/color.dart';
import '../../core/text.dart';
import '../../widgets/text/edit_text.dart';
import '../../widgets/text/edit_text_with_suffix.dart';
import '../../widgets/text/terms_of_service.dart';

class LoginWithEmailScreen extends StatelessWidget {
  const LoginWithEmailScreen({super.key});

  static const String route = "LoginWithEmailScreen";

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
            Expanded(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Đăng nhập", style: AppTextStyles.headline),
                  ),
                  SizedBox(height: 24),
                  LoginForm(width: width),
                ],
              ),
            ),
            primaryButton(true, "Continue with Google", 18, () {
              print("Login with google");
            }),
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
                    color:
                        isActive ? AppColors.primaryBlue : AppColors.lightGray,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(MainScreen.route);
                    },
                    borderRadius: BorderRadius.circular(27),
                    highlightColor: AppColors.primaryDark,
                    child: Center(
                      child: Text(
                        "Đăng nhập",
                        style:
                            isActive
                                ? AppTextStyles.primaryButton
                                : AppTextStyles.button,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 24,),
          GestureDetector(
            onTap: () {},
            child: Text(
              "Quên mật khẩu",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
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
