import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen/login_screen.dart';
import 'main_screen/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String route = "SplashScreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
    await Future.delayed(Duration(milliseconds: 300)); // mô phỏng loading
    final user = FirebaseAuth.instance.currentUser;

    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        user != null ? MainScreen.route : LoginScreen.route,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
