import 'package:flutter/material.dart';
import 'package:study_english_app/routes.dart';
import 'package:study_english_app/widgets/screens/login_screen/login_screen.dart';

void main() {
  runApp(
    SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: mainRoute,
        initialRoute: LoginScreen.route,
      ),
    ),
  );
}
