import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_english_app/models/user.dart';
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
      // Lưu UID vào SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', userCredential.user?.uid ?? '');
      //
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
      // Lưu UID vào SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', userCredential.user?.uid ?? '');
      //
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
  Future<void> createUser(User? user) async {
    if (user == null) return;
    final docSnapshot = await _firestore.collection('accounts').doc(user.uid).get();
    try {
      if(!docSnapshot.exists) {
        await _firestore.collection('accounts').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'username': user.displayName ?? user.email?.split('@').first,
          'latestLogin': FieldValue.serverTimestamp(),
          'avt' : '',
        });
      } else {
        // Nếu người dùng đã tồn tại, cập nhật thông tin mới
        await _firestore.collection('accounts').doc(user.uid).update({
          'email': user.email,
          'latestLogin': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      log.e('error', "Failed to create user in Firestore: $e");
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
  Future<UserInformation> getUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      return UserInformation.init();
    }

    return _firestore.collection('accounts').doc(user.uid).get().then((doc) {
      if (doc.exists) {
        final data = doc.data()!;
        return UserInformation(
          username: data['username'] ?? '',
          email: data['email'] ?? '',
          avt: data['avt'] ?? '',
          uid: user.uid,
          provider: user.providerData.isNotEmpty
              ? user.providerData.first.providerId
              : 'email',
        );
      } else {
        return UserInformation.init();
      }
    }).catchError((e) {
      log.e('error', "Failed to get user information: $e");
      return UserInformation.init();
    });
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid'); // Xóa UID khỏi SharedPreferences
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Future<bool> reAuthenticateWithCheck({String? password}) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.providerData.isEmpty) {
      return false;
    }

    try {
      final providerId = currentUser.providerData.first.providerId;

      if (providerId == 'google.com') {
        // Google Sign-In
        final googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          return false;
        }

        final googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Tạm sign-in để lấy user mới
        final tempUserCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        if (tempUserCredential.user?.uid != currentUser.uid) {
          await FirebaseAuth.instance.signOut(); // Sign out tài khoản tạm
          await FirebaseAuth.instance.signInWithCredential(
              await currentUser.getIdTokenResult(true).then((_) => credential)); // Khôi phục tài khoản cũ
          return false;
        }

        // Reauthenticate với credential hợp lệ
        await currentUser.reauthenticateWithCredential(credential);
        return true;
      }

      if (providerId == 'password') {
        // Email/Password
        if (password == null) {
          return false;
        }

        final credential = EmailAuthProvider.credential(
          email: currentUser.email!,
          password: password,
        );

        await currentUser.reauthenticateWithCredential(credential);
        return true;
      }

      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        log.e('error',"❌ Sai mật khẩu!");
      } else if (e.code == 'user-mismatch') {
        log.e('error',"❌ Tài khoản không khớp khi xác thực lại!");
      } else {
        log.e('error',"❌ Lỗi Firebase: ${e.code}");
      }
      return false;
    } catch (e) {
      log.e('error',"❌ Lỗi không xác định: $e");
      return false;
    }
  }

  @override
  Future<void> changeUsername(String username) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('accounts').doc(user.uid).update({
          'username': username,
          'usernameChangeTime': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      log.e('error', "Failed to update username: $e");
    }
  }

  @override
  Future<void> changeEmail(String email) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        user.verifyBeforeUpdateEmail(email);
      }
    } catch (e) {
      log.e('error', "Failed to update email: $e");
    }
  }

  @override
  Future<bool> checkEmailChangeVerified(String email) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.reload();
        final newUser = _auth.currentUser;
      }
    } catch (e) {
      if(e is FirebaseAuthException && e.code == 'user-token-expired') {
        return true;
      } else {
        log.e('error', "Failed to check email change verification: $e");
      }
    }
    return false;
  }


  @override
  Future<void> changePassword(String password) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(password);
      }
    } catch (e) {
      log.e('error', "Failed to update password: $e");
    }
  }

  @override
  Future<void> changeAvatar(String imagePath) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('accounts').doc(user.uid).update({
          'avt': imagePath,
        });
      }
    } catch (e) {
      log.e('error', "Failed to update avatar: $e");
    }
  }

  @override
  Future<int> getLastUsernameChangeTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? uid = prefs.getString('uid');
      if (uid != null) {
        final docSnapshot = await _firestore.collection('accounts').doc(uid).get();
        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          if (data != null && data['usernameChangeTime'] != null) {
            Timestamp? timestamp = data['usernameChangeTime'];
            if (timestamp != null) {
              DateTime lastLoginTime = timestamp.toDate();
              DateTime now = DateTime.now();
              Duration difference = now.difference(lastLoginTime);
              return difference.inDays;
            }
          }
        }
      }
    } catch (e) {
      log.e('error', "Failed to get last login time: $e");
    }
    return 0; // Trả về 0 nếu không tìm thấy hoặc có lỗi
  }
}
