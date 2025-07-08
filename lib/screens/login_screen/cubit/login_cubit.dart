import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/common/enum/load_status.dart';

import '../../../services/api.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.api) : super(LoginState.init());
  Api api;
  Future<void> loginWithEmail(String email, String password) async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      User? user = await api.loginWithEmail(email, password);
      if (user != null) {
        await api.createUser(user);
        emit(state.copyWith(loadStatus: LoadStatus.Success));
      }
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      User? user = await api.loginWithGoogle();
      if (user != null) {
        await api.createUser(user);
        emit(state.copyWith(loadStatus: LoadStatus.Success));
      } else {
        emit(state.copyWith(loadStatus: LoadStatus.Error));
      }
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  Future<void> registerWithEmail(String email, String password) async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      User? user = await api.registerWithEmail(email, password);
      if (user != null) {
        emit(state.copyWith(loadStatus: LoadStatus.Success));
      } else {
        emit(state.copyWith(loadStatus: LoadStatus.Error));
      }
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  Future<void> sendVerificationEmail() async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      await api.sendVerificationEmail();
      emit(state.copyWith(loadStatus: LoadStatus.Success));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  Future<void> checkEmailVerified() async {
    try {
      bool isVerified = await api.checkEmailVerified();
      emit(state.copyWith(isVerified: isVerified));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error, isVerified: false));
    }
  }

  Future<void> deleteUser() async {
    try {
      await api.deleteUser();
      emit(state.copyWith(loadStatus: LoadStatus.Success, isVerified: false));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      await api.resetPassword(email);
      emit(state.copyWith(loadStatus: LoadStatus.Success));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  void updateEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void updatePassword(String password) {
    emit(state.copyWith(password: password));
  }
}
