import 'package:flutter/material.dart';
import 'package:study_english_app/screens/account_screen/edit_profile_screen.dart';
import 'package:study_english_app/screens/card_merge_screen/card_merge_screen.dart';
import 'package:study_english_app/screens/course_detail/course_detail_screen.dart';
import 'package:study_english_app/screens/flashcard_screen/flashcard_screen.dart';
import 'package:study_english_app/screens/account_screen/account_screen.dart';
import 'package:study_english_app/screens/home_screen/home_screen.dart';
import 'package:study_english_app/screens/learn_screen/learn_screen.dart';
import 'package:study_english_app/screens/library_screen/library_screen.dart';
import 'package:study_english_app/screens/login_screen/email_verification_screen.dart';
import 'package:study_english_app/screens/main_screen/main_screen.dart';
import 'package:study_english_app/screens/login_screen/login_screen.dart';
import 'package:study_english_app/screens/login_screen/login_with_email.dart';
import 'package:study_english_app/screens/login_screen/register_with_email.dart';
import 'package:study_english_app/screens/splash_screen.dart';
import 'package:study_english_app/screens/statisticial_screen/statistical_screen.dart';

Route<dynamic>? mainRoute (RouteSettings settings) {
  switch(settings.name) {
    case LoginScreen.route:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    case RegisterWithEmail.route:
      return MaterialPageRoute(builder: (context) => RegisterWithEmail());
    case LoginWithEmailScreen.route:
      return MaterialPageRoute(builder: (context) => LoginWithEmailScreen());
    case EmailVerificationScreen.route:
      return MaterialPageRoute(builder: (context) => EmailVerificationScreen());
    case SplashScreen.route:
      return MaterialPageRoute(builder: (context) => SplashScreen());
    case MainScreen.route:
      return MaterialPageRoute(builder: (context) => MainScreen());
    case HomeScreen.route:
      return MaterialPageRoute(builder: (context) => HomeScreen());
    case LearnScreen.route:
      return MaterialPageRoute(builder: (context) => LearnScreen());
    case FlashcardScreen.route:
      return MaterialPageRoute(builder: (context) => FlashcardScreen());
    case CourseDetailScreen.route:
      return MaterialPageRoute(builder: (context) => CourseDetailScreen());
    case CardMergeScreen.route:
      return MaterialPageRoute(builder: (context) => CardMergeScreen());
    case StatisticalScreen.route:
      return MaterialPageRoute(builder: (context) => StatisticalScreen());
    case LibraryScreen.route:
      return MaterialPageRoute(builder: (context) => LibraryScreen());
    case AccountScreen.route:
      return MaterialPageRoute(builder: (context) => AccountScreen());
    case EditProfileScreen.route:
      return MaterialPageRoute(builder: (context) => EditProfileScreen());
    default:
      return MaterialPageRoute(builder: (context) => LoginScreen());
  }
}