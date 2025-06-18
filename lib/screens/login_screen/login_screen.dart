import 'package:flutter/material.dart';
import 'package:study_english_app/screens/login_screen/login_with_email.dart';
import 'package:study_english_app/widgets/button/button.dart';
import 'package:study_english_app/widgets/button/primary_button.dart';
import 'package:study_english_app/widgets/text/terms_of_service.dart';
import '../main_screen/main_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String route = "LoginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    double spacing = height / 25;
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 2, child: SizedBox(width: width, child: Text(""))),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Cách tốt nhất để học. Đăng ký miễn phí.",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: spacing),
                SizedBox(width: width / 2, child: termOfService()),
                SizedBox(height: spacing),
                SizedBox(
                  width: width - 100,
                  child: primaryButton(true, "Continue with Google", 18, () {
                    print("Login with google");
                    Navigator.of(context).pushNamed(MainScreen.route);
                  }),
                ),
                SizedBox(height: spacing),
                SizedBox(
                  width: width - 100,
                  child: button(true, "Register with Email", 18, () {
                    print("register with email");
                    Navigator.of(context).pushNamed("RegisterWithEmail");
                  }),
                ),
                SizedBox(height: spacing),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Đã có tài khoản? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(
                          context,
                        ).pushNamed(LoginWithEmailScreen.route);
                      },
                      child: Text(
                        "Đăng nhập",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
