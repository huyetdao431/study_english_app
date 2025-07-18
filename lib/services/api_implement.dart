import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_english_app/models/courses.dart';
import 'package:study_english_app/models/user.dart';
import 'package:study_english_app/models/word.dart';
import 'package:study_english_app/services/api.dart';
import 'package:study_english_app/services/repositories/log.dart';

class ApiImplement implements Api {
  Log log;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ApiImplement(this.log);

  //<editor-fold desc="login Methods">
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
    final docSnapshot =
        await _firestore.collection('accounts').doc(user.uid).get();
    try {
      if (!docSnapshot.exists) {
        await _firestore.collection('accounts').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'username': user.displayName ?? user.email?.split('@').first,
          'latestLogin': FieldValue.serverTimestamp(),
          'avt': '',
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

    return _firestore
        .collection('accounts')
        .doc(user.uid)
        .get()
        .then((doc) {
          if (doc.exists) {
            final data = doc.data()!;
            return UserInformation(
              username: data['username'] ?? '',
              email: data['email'] ?? '',
              avt: data['avt'] ?? '',
              uid: user.uid,
              provider:
                  user.providerData.isNotEmpty
                      ? user.providerData.first.providerId
                      : 'email',
            );
          } else {
            return UserInformation.init();
          }
        })
        .catchError((e) {
          log.e('error', "Failed to get user information: $e");
          return UserInformation.init();
        });
  }

  @override
  Future<UserInformation> getUserById(String userId) async {
    try {
      final docSnapshot =
          await _firestore.collection('accounts').doc(userId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        return UserInformation(
          username: data['username'] ?? '',
          email: data['email'] ?? '',
          avt: data['avt'] ?? '',
          uid: userId,
          provider: data['provider'] ?? 'password',
        );
      } else {
        return UserInformation.init();
      }
    } catch (e) {
      log.e('error', "Failed to get user by ID: $e");
      return UserInformation.init();
    }
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

  //</editor-fold>

  //<editor-fold desc="User management Methods">
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
        final tempUserCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);

        if (tempUserCredential.user?.uid != currentUser.uid) {
          await FirebaseAuth.instance.signOut(); // Sign out tài khoản tạm
          await FirebaseAuth.instance.signInWithCredential(
            await currentUser.getIdTokenResult(true).then((_) => credential),
          ); // Khôi phục tài khoản cũ
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
        log.e('error', " Sai mật khẩu!");
      } else if (e.code == 'user-mismatch') {
        log.e('error', " Tài khoản không khớp khi xác thực lại!");
      } else {
        log.e('error', " Lỗi Firebase: ${e.code}");
      }
      return false;
    } catch (e) {
      log.e('error', " Lỗi không xác định: $e");
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
        await user.verifyBeforeUpdateEmail(email);
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
      }
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'user-token-expired') {
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
        final docSnapshot =
            await _firestore.collection('accounts').doc(uid).get();
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

  //</editor-fold>

  //<editor-fold desc="Course management Methods">

  @override
  Future<List<Map<String, dynamic>>> getCourses(String searchInfo) async{
    try {
      final snapshot = await _firestore.collection('courses').where('keyword', arrayContains: searchInfo.toLowerCase()).get();
      final List<Map<String, dynamic>> courses = await Future.wait(
        snapshot.docs.map((doc) async {
          final courseId = doc.id;
          return await getCourseById(courseId);
        }),
      );
      return courses;
    } catch (e) {
      log.e('error', "Failed to search course: $e");
    }
    return [];
  }

  @override
  Future<List<Word>> getWords(String courseId) async {
    try {
      final wordsSnapshot =
          await _firestore
              .collection('courses')
              .doc(courseId)
              .collection('words')
              .get();
      return wordsSnapshot.docs.map((doc) {
        return Word.fromMap(doc.data());
      }).toList();
    } catch (e) {
      log.e('error', "Failed to get words: $e");
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUserCourses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid');
      if (uid == null) {
        return [];
      } else {
        final userCoursesSnapshot =
            await _firestore
                .collection('accounts')
                .doc(uid)
                .collection('userCourses')
                .get();
        return Future.wait(
          userCoursesSnapshot.docs.map((doc) async {
            final courseId = doc['courseId'];
            Map<String, dynamic> course = await getCourseById(courseId);
            course['latestUpdate'] =
                (doc['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
            return course;
          }),
        );
      }
    } catch (e) {
      log.e('error', "Failed to get user courses: $e");
      return Future.value([]);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getLearnedCourses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid');
      if (uid == null) {
        return [];
      } else {
        final learnedCoursesSnapshot =
            await _firestore
                .collection('accounts')
                .doc(uid)
                .collection('learnedCourse')
                .get();
        return Future.wait(
          learnedCoursesSnapshot.docs.map((doc) async {
            final courseId = doc['courseId'];
            Map<String, dynamic> course = await getCourseById(courseId);
            course['latestLearn'] =
                (doc['latestLearn'] as Timestamp?)?.toDate() ?? DateTime.now();
            return course;
          }),
        );
      }
    } catch (e) {
      log.e('error', "Failed to get learned courses: $e");
      return Future.value([]);
    }
  }

  @override
  Future<List<String>> getCourseName() async{
    try {
      final courseDoc = await _firestore.collection('courses').get();
      return courseDoc.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      log.e('error', "Failed to get courses: $e");
      return [];
    }
  }

  // @override
  // Future<void> createCourse(String courseName, List<Word> words) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     String? uid = prefs.getString('uid');
  //     if (uid != null) {
  //       final coursesRef = await _firestore.collection('courses').add({
  //         'name': courseName,
  //         'createdBy': uid,
  //         'createdAt': FieldValue.serverTimestamp(),
  //       });
  //
  //       await _firestore
  //           .collection('accounts')
  //           .doc(uid)
  //           .collection('userCourses')
  //           .doc(coursesRef.id)
  //           .set({
  //             'courseId': coursesRef.id,
  //             'createdAt': FieldValue.serverTimestamp(),
  //           });
  //
  //       final wordsRef = coursesRef.collection('words');
  //       const chunkSize = 20;
  //       for (int i = 0; i < words.length; i += chunkSize) {
  //         final chunk = words.skip(i).take(chunkSize);
  //         await Future.wait(
  //           chunk.map((word) {
  //             return wordsRef.add({'word': word.word, 'meaning': word.meaning});
  //           }),
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     log.e('error', "Failed to create course: $e");
  //   }
  // }

  @override
  Future<void> createCourse(String courseName, List<Word> words) async {
    try {
      if (words.isEmpty) {
        throw Exception('Không thể tạo khóa học không có từ vựng.');
      }

      final prefs = await SharedPreferences.getInstance();
      String? uid = prefs.getString('uid');
      if (uid == null) return;

      final courseDocRef = _firestore.collection('courses').doc();
      final keywords = generateKeywords(courseName);
      final batch = _firestore.batch();

      // 1. Ghi course chính
      batch.set(courseDocRef, {
        'name': courseName,
        'createdBy': uid,
        'createdAt': FieldValue.serverTimestamp(),
        'totalWords': words.length,
        'isPublic': true,
        'keyword' : keywords,
      });

      // 2. Ghi courseId vào userCourses
      final userCourseRef = _firestore
          .collection('accounts')
          .doc(uid)
          .collection('userCourses')
          .doc(courseDocRef.id);

      batch.set(userCourseRef, {
        'courseId': courseDocRef.id,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      // 3. Ghi từ vựng
      final wordsRef = courseDocRef.collection('words');
      const chunkSize = 20;
      for (int i = 0; i < words.length; i += chunkSize) {
        final chunk = words.skip(i).take(chunkSize);
        await Future.wait(
          chunk.map((word) {
            return wordsRef.add({'word': word.word, 'meaning': word.meaning});
          }),
        );
      }
    } catch (e) {
      log.e('error', "Failed to create course: $e");
    }
  }

  @override
  Future<void> deleteCourse(String courseId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? uid = prefs.getString('uid');
      if (uid == null) {
        log.e('error', "UID is null");
        return;
      }

      WriteBatch batch = _firestore.batch();

      // 1. Xóa khỏi userCourses của người tạo
      final userCoursesRef = _firestore
          .collection('accounts')
          .doc(uid)
          .collection('userCourses')
          .doc(courseId);
      batch.delete(userCoursesRef);

      // 2. Xóa tất cả người học: courses/{courseId}/userAttended/*
      final userAttendedSnap =
          await _firestore
              .collection('courses')
              .doc(courseId)
              .collection('userAttended')
              .get();

      for (var doc in userAttendedSnap.docs) {
        final userId = doc.id;
        batch.delete(doc.reference);

        // 3. Xóa khóa học này trong learnedCourse của từng người học
        final learnedCourseRef = _firestore
            .collection('accounts')
            .doc(userId)
            .collection('learnedCourse')
            .doc(courseId);

        batch.delete(learnedCourseRef);
      }

      // 4. Xóa tất cả words (nếu có collection words trong course)
      final wordSnap =
          await _firestore
              .collection('courses')
              .doc(courseId)
              .collection('words')
              .get();

      for (var doc in wordSnap.docs) {
        batch.delete(doc.reference);
      }

      // 5. Xóa document chính của course
      final courseDocRef = _firestore.collection('courses').doc(courseId);
      batch.delete(courseDocRef);

      // Commit all
      await batch.commit();
    } catch (e) {
      log.e('error', "Failed to delete course: $e");
    }
  }

  @override
  Future<void> updateCourse(
    String courseId,
    String newName,
    List<Word> words,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? uid = prefs.getString('uid');
      if (uid == null) throw Exception("User not logged in");

      // 1. Cập nhật tên khóa học + tổng số từ
      final courseRef = _firestore.collection('courses').doc(courseId);

      await courseRef.update({
        'name': newName,
        'updatedAt': FieldValue.serverTimestamp(),
        'totalWords': words.length,
        'keyword': generateKeywords(newName),
      });

      // 2. Xóa toàn bộ từ cũ
      final wordsCollection = courseRef.collection('words');
      final oldWordsSnapshot = await wordsCollection.get();
      for (var doc in oldWordsSnapshot.docs) {
        await doc.reference.delete();
      }
      // 3. Ghi lại danh sách từ mới
      const chunkSize = 20;
      for (int i = 0; i < words.length; i += chunkSize) {
        final chunk = words.skip(i).take(chunkSize);
        await Future.wait(
          chunk.map((word) {
            return wordsCollection.add({
              'word': word.word,
              'meaning': word.meaning,
            });
          }),
        );
      }
      // 4. (Tùy chọn) Cập nhật trong userCourses
      final userCourseRef = _firestore
          .collection('accounts')
          .doc(uid)
          .collection('userCourses')
          .doc(courseId);
      await userCourseRef.update({'updatedAt': FieldValue.serverTimestamp()});
    } catch (e) {
      log.e('error', "Cập nhật khóa học thất bại: $e");
    }
  }

  @override
  Future<void> setPublicCourse(String courseId, bool status) async{
    try {
      final courseRef = _firestore.collection('courses').doc(courseId);
      await courseRef.update({'isPublic': status});
    } catch (e) {
      log.e('error', "Failed to set course public: $e");
    }
  }

  @override
  Future<Map<String, dynamic>> getCourseById(String courseId) async {
    try {
      String name;
      String createdBy;
      int totalWords = 0;
      DateTime createdAt;
      final docSnapshot =
          await _firestore.collection('courses').doc(courseId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          name = data['name'] ?? '';
          createdBy = data['createdBy'] ?? '';
          createdAt =
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
          final userDoc = await _firestore
              .collection('accounts')
              .doc(createdBy)
              .get();

          // Lấy danh sách từ vựng liên quan đến khóa học
          final wordsSnapshot =
              await _firestore
                  .collection('courses')
                  .doc(courseId)
                  .collection('words')
                  .get();
          final words =
              wordsSnapshot.docs.map((doc) {
                return Word.fromMap(doc.data());
              }).toList();

          totalWords = words.length;
          final course = Courses(
            id: courseId,
            name: name,
            totalWords: totalWords,
            createdBy: createdBy,
            createdAt: createdAt,
            words: words,
            isPublic: data['isPublic'] ?? true,
          );

          return {
            'course' : course,
            'username' : userDoc.data()?['username'] ?? '',
            'avt' : userDoc.data()?['avt'] ?? '',
          };
        }
      } else {
        log.e('error', "Course with ID $courseId does not exist.");
      }
    } catch (e) {
      log.e('error', "Failed to get course by ID: $e");
    }
    return {};
  }

  @override
  Future<void> updateStreak() async{
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('uid');
      if(userId == null) return;

      final userRef = _firestore.collection('accounts').doc(userId);
      final doc = await userRef.get();
      final data = doc.data();

      if (data == null) return;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final lastLoginStr = data['lastLoginDate'];
      final currentStreak = data['streak'] ?? 0;
      final history = List<String>.from(data['streakHistory'] ?? []);

      DateTime? lastLogin;
      if (lastLoginStr != null) {
        lastLogin = DateTime.tryParse(lastLoginStr);
      }

      if (lastLogin != null && today.difference(lastLogin).inDays == 1) {
        // học liên tục
        await userRef.update({
          'streak': currentStreak + 1,
          'lastLoginDate': today.toIso8601String(),
          'streakHistory': [...history, today.toIso8601String()],
        });
      } else if (lastLogin == null || today.isAfter(lastLogin)) {
        // học lại sau khi nghỉ / lần đầu
        await userRef.update({
          'streak': 1,
          'lastLoginDate': today.toIso8601String(),
          'streakHistory': [today.toIso8601String()],
        });
      }
    } catch (e) {
      log.e('error', "Failed to update Streak: $e");
    }
  }

  @override
  Future<Map<String, dynamic>> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    if (uid == null) throw Exception("User not logged in");

    final userRef = _firestore.collection('accounts').doc(uid);
    final doc = await userRef.get();

    if (!doc.exists) {
      return {
        'streak': 0,
        'lastLoginDate': null,
        'streakHistory': [],
      };
    }

    final data = doc.data()!;
    final streak = data['streak'] ?? 0;
    final lastLoginDate = data['lastLoginDate'];
    final history = List<String>.from(data['streakHistory'] ?? []);

    return {
      'streak': streak,
      'lastLoginDate': lastLoginDate,
      'streakHistory': history,
    };
  }


  // @override
  // Future<void> addCourseToUser(String courseId) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     String? uid = prefs.getString('uid');
  //     if (uid != null) {
  //       final courseDoc =
  //           await _firestore.collection('courses').doc(courseId).get();
  //
  //       final learnedCourseRef = _firestore
  //           .collection('accounts')
  //           .doc(uid)
  //           .collection('learnedCourse')
  //           .doc(courseId);
  //
  //       final learnedCourseDoc = await learnedCourseRef.get();
  //
  //       if (courseDoc.exists && !learnedCourseDoc.exists) {
  //         await learnedCourseRef.set({
  //           'courseId': courseId,
  //           'latestLearn': FieldValue.serverTimestamp(),
  //         });
  //       } else {
  //         log.e(
  //           'error',
  //           "Course with ID $courseId does not exist or already added.",
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     log.e('error', "Failed to add user to course: $e");
  //   }
  // }
  //
  // @override
  // Future<void> addUserToCourse(String courseId) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     String? uid = prefs.getString('uid');
  //     if (uid != null) {
  //       final courseDoc =
  //           await _firestore.collection('courses').doc(courseId).get();
  //       if (courseDoc.exists) {
  //         final userCourseRef = _firestore
  //             .collection('courses')
  //             .doc(courseId)
  //             .collection('userAttended')
  //             .doc(uid);
  //         final userCourseDoc = await userCourseRef.get();
  //         if (!userCourseDoc.exists) {
  //           await userCourseRef.set({
  //             'userId': uid,
  //             'attendedAt': FieldValue.serverTimestamp(),
  //           });
  //         } else {
  //           log.e('error', "User already added to course $courseId");
  //         }
  //       } else {
  //         log.e('error', "Course with ID $courseId does not exist.");
  //       }
  //     } else {
  //       log.e('error', "User ID is null, cannot add to course.");
  //     }
  //   } catch (e) {
  //     log.e('error', "Failed to add user to course: $e");
  //   }
  // }

  @override
  Future<void> enrollUserToCourse(String courseId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? uid = prefs.getString('uid');
      if (uid == null) throw Exception("User ID not found");

      final courseDoc =
          await _firestore.collection('courses').doc(courseId).get();
      if (!courseDoc.exists) throw Exception("Course $courseId not found");

      final userCourseRef = _firestore
          .collection('courses')
          .doc(courseId)
          .collection('userAttended')
          .doc(uid);

      final learnedCourseRef = _firestore
          .collection('accounts')
          .doc(uid)
          .collection('learnedCourse')
          .doc(courseId);

      final userCourseDoc = await userCourseRef.get();
      final learnedCourseDoc = await learnedCourseRef.get();

      // Bat dau ghi du lieu
      WriteBatch batch = _firestore.batch();

      if (!userCourseDoc.exists) {
        batch.set(userCourseRef, {
          'userId': uid,
          'attendedAt': FieldValue.serverTimestamp(),
        });
      }

      if (!learnedCourseDoc.exists) {
        batch.set(learnedCourseRef, {
          'courseId': courseId,
          'latestLearn': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
    } catch (e) {
      log.e('EnrollError', e.toString());
    }
  }

  @override
  Future<void> removeUserFromCourse(String courseId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? uid = prefs.getString('uid');
      if (uid == null) {
        log.e('error', 'UID is null');
        return;
      }

      final batch = _firestore.batch();

      // 1. Xóa trong learnedCourse
      final learnedCourseRef = _firestore
          .collection('accounts')
          .doc(uid)
          .collection('learnedCourse')
          .doc(courseId);

      final learnedDoc = await learnedCourseRef.get();
      if (learnedDoc.exists) {
        batch.delete(learnedCourseRef);
      }

      // 2. Xóa trong userAttended
      final userAttendedRef = _firestore
          .collection('courses')
          .doc(courseId)
          .collection('userAttended')
          .doc(uid);

      final attendedDoc = await userAttendedRef.get();
      if (attendedDoc.exists) {
        batch.delete(userAttendedRef);
      }

      // Commit batch
      await batch.commit();
    } catch (e) {
      log.e('error', "Failed to delete user from course: $e");
    }
  }

  //</editor-fold>

  List<String> generateKeywords(String text) {
    final words = text.toLowerCase().split(RegExp(r'\s+'));
    final Set<String> keywords = {};

    for (final word in words) {
      keywords.add(word);
      for (int i = 1; i <= word.length; i++) {
        keywords.add(word.substring(0, i));
      }
    }

    return keywords.toList();
  }
}
