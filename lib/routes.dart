import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/screens/account_screen/avatar_screen.dart';
import 'package:study_english_app/screens/account_screen/cubit/account_cubit.dart';
import 'package:study_english_app/screens/account_screen/edit_user_info_screen.dart';
import 'package:study_english_app/screens/account_screen/image_preview_screen.dart';
import 'package:study_english_app/screens/account_screen/settings_screen.dart';
import 'package:study_english_app/screens/add_course_screen/add_course_screen.dart';
import 'package:study_english_app/screens/card_merge_screen/card_merge_screen.dart';
import 'package:study_english_app/screens/course_detail/course_detail_screen.dart';
import 'package:study_english_app/screens/exam_screen/exam_screen.dart';
import 'package:study_english_app/screens/flashcard_screen/flashcard_screen.dart';
import 'package:study_english_app/screens/account_screen/account_screen.dart';
import 'package:study_english_app/screens/home_screen/home_screen.dart';
import 'package:study_english_app/screens/home_screen/notification_screen.dart';
import 'package:study_english_app/screens/library_screen/library_screen.dart';
import 'package:study_english_app/screens/login_screen/email_verification_screen.dart';
import 'package:study_english_app/screens/main_screen/main_screen.dart';
import 'package:study_english_app/screens/login_screen/login_screen.dart';
import 'package:study_english_app/screens/login_screen/login_with_email.dart';
import 'package:study_english_app/screens/login_screen/register_with_email.dart';
import 'package:study_english_app/screens/search_screen/search_screen.dart';
import 'package:study_english_app/screens/splash_screen.dart';
import 'package:study_english_app/screens/study_screen/study_screen.dart';

import 'models/word.dart';

Route<dynamic>? mainRoute(RouteSettings settings) {
  switch (settings.name) {
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
    case NotificationScreen.route:
      return MaterialPageRoute(builder: (context) => NotificationScreen());
    case SearchScreen.route:
      return MaterialPageRoute(builder: (context) => SearchScreen());
    case StudyScreen.route:
      var words =
          (settings.arguments as Map<String, dynamic>)['words'] as List<Word>;
      return MaterialPageRoute(builder: (context) => StudyScreen(words: words));
    case FlashcardScreen.route:
      var words =
          (settings.arguments as Map<String, dynamic>)['words'] as List<Word>;
      return MaterialPageRoute(
        builder: (context) => FlashcardScreen(words: words),
      );
    case CourseDetailScreen.route:
      var courseId =
          (settings.arguments as Map<String, dynamic>)['courseId']
              as String;
      return MaterialPageRoute(
        builder: (context) => CourseDetailScreen(courseId: courseId),
      );
    case CardMergeScreen.route:
      var words =
          (settings.arguments as Map<String, dynamic>)['words'] as List<Word>;
      return MaterialPageRoute(
        builder: (context) => CardMergeScreen(words: words),
      );
    case ExamScreen.route:
      var words =
          (settings.arguments as Map<String, dynamic>)['words'] as List<Word>;
      return MaterialPageRoute(
        builder: (context) => ExamScreen(words: words),
      );
    case AddCourseScreen.route:
      var isAddCourse = (settings.arguments as Map<String, dynamic>)['isAddCourse'] as bool;
      var courseId = (settings.arguments as Map<String, dynamic>)['courseId'] as String;
      return MaterialPageRoute(builder: (context) => AddCourseScreen(isAddCourse: isAddCourse, courseId: courseId));
    case LibraryScreen.route:
      return MaterialPageRoute(builder: (context) => LibraryScreen());
    case AccountScreen.route:
      return MaterialPageRoute(builder: (context) => AccountScreen());
    case SettingsScreen.route:
      var cubit =
          (settings.arguments as Map<String, dynamic>)['cubit'] as AccountCubit;
      return MaterialPageRoute(
        builder:
            (context) =>
                BlocProvider.value(value: cubit, child: SettingsScreen()),
      );
    case EditUserInfoScreen.route:
      var cubit =
          (settings.arguments as Map<String, dynamic>)['cubit'] as AccountCubit;
      var fieldType =
          (settings.arguments as Map<String, dynamic>)['fieldType'] as String;
      var oldValue =
          (settings.arguments as Map<String, dynamic>)['oldValue'] as String;
      return MaterialPageRoute(
        builder:
            (context) => BlocProvider.value(
              value: cubit,
              child: EditUserInfoScreen(
                fieldType: fieldType,
                oldValue: oldValue,
              ),
            ),
      );
    case AvatarScreen.route:
      var cubit =
          (settings.arguments as Map<String, dynamic>)['cubit'] as AccountCubit;
      return MaterialPageRoute(
        builder:
            (context) =>
                BlocProvider.value(value: cubit, child: AvatarScreen()),
      );
    case ImagePreviewScreen.route:
      var cubit =
          (settings.arguments as Map<String, dynamic>)['cubit'] as AccountCubit;
      var index = (settings.arguments as Map<String, dynamic>)['index'] as int;
      return MaterialPageRoute(
        builder:
            (context) => BlocProvider.value(
              value: cubit,
              child: ImagePreviewScreen(index: index),
            ),
      );
    default:
      return MaterialPageRoute(builder: (context) => LoginScreen());
  }
}
