import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:study_english_app/widgets/screens/home_screen/home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String route = "LoginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _username = "";
  String _password = "";
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Usename",
                hintStyle: TextStyle(color: Colors.black26),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.black26),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.remove_red_eye_rounded : Icons.remove_red_eye_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                      print(_obscureText);
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: () {
              Navigator.of(context).pushNamed(HomeScreen.route);
            }, child: Text("Login")),
            SizedBox(height: 24),
            Text("OR"),
            SizedBox(height: 24),
            ElevatedButton(onPressed: () {
              Navigator.of(context).pushNamed(HomeScreen.route);
            }, child: Text("Login with Google")),
          ],
        ),
      ),
    );
  }
}
