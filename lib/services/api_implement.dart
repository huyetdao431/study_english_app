import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:study_english_app/services/api.dart';
import 'package:study_english_app/services/repositories/log.dart';

class ApiImplement implements Api {
  Log log;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ApiImplement(this.log);

  @override
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      log.e('error', "Login with email failed: $e");
      return null;
    }
  }

  @override
  Future<User?> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      return userCredential.user;
    } catch (e) {
      log.e('error', "Login with Google failed: $e");
      return null;
    }
  }

  @override
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      log.e('error', "Registration with email failed: $e");
      return null;
    }
  }

  @override
  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      log.e('error', "Failed to send verification email: $e");
    }
  }

  @override
  Future<bool> checkEmailVerified() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      return user?.emailVerified ?? false;
    } catch (e) {
      log.e('error', "Failed to check email verification: $e");
      return false;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log.e('error', "Failed to reset password: $e");
    }
  }

  @override
  Future<User?> getCurrentUser() {
    return Future.value(_auth.currentUser);
  }

  @override
  Future<void> deleteUser() async {
    try {
      await _auth.currentUser?.delete();
    } catch (e) {
      log.e('error', "Failed to delete user: $e");
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Future<void> updateUsername(String username) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'username': username,
        });
      }
    } catch (e) {
      log.e('error', "Failed to update username: $e");
    }
  }

  @override
  Future<void> updatePassword(String password) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(password);
      }
    } catch (e) {
      log.e('error', "Failed to update password: $e");
    }
  }
}
