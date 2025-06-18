import 'package:flutter/material.dart';
import 'package:study_english_app/screens/course_detail/course_detail_screen.dart';
import 'package:study_english_app/screens/flashcard_screen/flashcard_screen.dart';
import 'package:study_english_app/screens/account_screen/account_screen.dart';
import 'package:study_english_app/screens/home_screen/home_screen.dart';
import 'package:study_english_app/screens/main_screen/main_screen.dart';
import 'package:study_english_app/screens/login_screen/login_screen.dart';
import 'package:study_english_app/screens/login_screen/login_with_email.dart';
import 'package:study_english_app/screens/login_screen/register_with_email.dart';
import 'package:study_english_app/screens/mini_game_screen/mini_game_screen.dart';
import 'package:study_english_app/screens/statisticial_screen/statistical_screen.dart';
import 'package:study_english_app/screens/suggest_screen/suggest_screen.dart';

Route<dynamic>? mainRoute (RouteSettings settings) {
  switch(settings.name) {
    case LoginScreen.route:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    case MainScreen.route:
      return MaterialPageRoute(builder: (context) => MainScreen());
    case HomeScreen.route:
      return MaterialPageRoute(builder: (context) => HomeScreen());
    case MiniGameScreen.route:
      return MaterialPageRoute(builder: (context) => MiniGameScreen());
    case FlashcardScreen.route:
      return MaterialPageRoute(builder: (context) => FlashcardScreen());
    case CourseDetailScreen.route:
      return MaterialPageRoute(builder: (context) => CourseDetailScreen());
    case StatisticalScreen.route:
      return MaterialPageRoute(builder: (context) => StatisticalScreen());
    case SuggestScreen.route:
      return MaterialPageRoute(builder: (context) => SuggestScreen());
    case AccountScreen.route:
      return MaterialPageRoute(builder: (context) => AccountScreen());
    case RegisterWithEmail.route:
      return MaterialPageRoute(builder: (context) => RegisterWithEmail());
    case LoginWithEmailScreen.route:
      return MaterialPageRoute(builder: (context) => LoginWithEmailScreen());
    default:
      return MaterialPageRoute(builder: (context) => LoginScreen());
  }
}