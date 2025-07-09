import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_english_app/models/user.dart';

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

  // user management methods
  Future<bool> reAuthenticateWithCheck({String? password});

  Future<void> changeUsername(String username);

  Future<void> changeEmail(String email);

  Future<bool> checkEmailChangeVerified(String email);

  Future<void> changePassword(String password);

  Future<void> changeAvatar(String imagePath);

  Future<int> getLastUsernameChangeTime();
}
