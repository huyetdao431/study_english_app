import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_english_app/models/categories.dart';
import 'package:study_english_app/models/user.dart';
import 'package:study_english_app/models/word.dart';
import 'package:study_english_app/screens/library_screen/cubit/library_cubit.dart';

import '../models/courses.dart';

abstract class Api {
  //authentication methods
  Future<User?> registerWithEmail(String email, String password);

  Future<User?> loginWithEmail(String email, String password);

  Future<User?> loginWithGoogle();

  Future<void> signOut();

  Future<void> sendVerificationEmail();

  Future<bool> checkEmailVerified();

  Future<void> resetPassword(String email);

  Future<void> deleteUser();

  Future<void> createUser(User? user);

  Future<UserInformation> getUser();

  Future<UserInformation> getUserById(String userId);

  // user management methods
  Future<bool> reAuthenticateWithCheck({String? password});

  Future<void> changeUsername(String username);

  Future<void> changeEmail(String email);

  Future<bool> checkEmailChangeVerified(String email);

  Future<void> changePassword(String password);

  Future<void> changeAvatar(String imagePath);

  Future<int> getLastUsernameChangeTime();

  // course management methods
  Future<List<Categories>> getCategories();

  Future<List<Word>> getWords(String courseId);

  Future<Map<String, dynamic>> getCourseById(String courseId);

  Future<List<Map<String, dynamic>>> getUserCourses();

  Future<List<Map<String, dynamic>>> getLearnedCourses();

  Future<List<String>> getCourseName();

  Future<List<Map<String, dynamic>>> getCourses(String searchInfo);

  // Future<void> addCourseToUser(String courseId);
  //
  // Future<void> addUserToCourse(String courseId);

  Future<void> enrollUserToCourse(String courseId);

  Future<void> updateCourse(
    String courseId,
    String courseName,
    List<Word> words,
  );

  Future<void> createCourse(String courseName, List<Word> words);

  Future<void> setPublicCourse(String courseId, bool status);

  Future<void> deleteCourse(String courseId);

  Future<void> removeUserFromCourse(String courseId);
}
