import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:study_english_app/firebase_options.dart';
import 'package:study_english_app/screens/course_detail/course_detail_screen.dart';
import 'package:study_english_app/screens/flashcard_screen/flashcard_screen.dart';
import 'package:study_english_app/routes.dart';
import 'package:study_english_app/screens/main_screen/main_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(
    SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "My Application",
        scrollBehavior: MaterialScrollBehavior().copyWith(dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.trackpad,
        }),
        onGenerateRoute: mainRoute,
        initialRoute: CourseDetailScreen.route,
      ),
    ),
  );
}
