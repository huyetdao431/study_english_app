import 'package:flutter/material.dart';
import 'package:study_english_app/widgets/screens/account_screen/account_screen.dart';
import 'package:study_english_app/widgets/screens/flashcard_screen/flashcard_screen.dart';
import 'package:study_english_app/widgets/screens/home_screen/home_screen.dart';
import 'package:study_english_app/widgets/screens/login_screen/login_screen.dart';
import 'package:study_english_app/widgets/screens/mini_game_screen/mini_game_screen.dart';
import 'package:study_english_app/widgets/screens/statisticial_screen/statistical_screen.dart';
import 'package:study_english_app/widgets/screens/suggest_screen/suggest_screen.dart';

Route<dynamic>? mainRoute (RouteSettings settings) {
  switch(settings.name) {
    case LoginScreen.route:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    case HomeScreen.route:
      return MaterialPageRoute(builder: (context) => HomeScreen());
    case FlashcardScreen.route:
      return MaterialPageRoute(builder: (context) => FlashcardScreen());
    case MiniGameScreen.route:
      return MaterialPageRoute(builder: (context) => MiniGameScreen());
    case StatisticalScreen.route:
      return MaterialPageRoute(builder: (context) => StatisticalScreen());
    case SuggestScreen.route:
      return MaterialPageRoute(builder: (context) => SuggestScreen());
    case AccountScreen.route:
      return MaterialPageRoute(builder: (context) => AccountScreen());
    default:
      return MaterialPageRoute(builder: (context) => LoginScreen());
  }
}