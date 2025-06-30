import 'package:firebase_auth/firebase_auth.dart';

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
  Future<User?> getCurrentUser();
  // user management methods
  Future<void> updateUsername(String username);
  Future<void> updatePassword(String username);
}