import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/common/enum/load_status.dart';
import 'package:study_english_app/models/user.dart';
import '../../../services/api.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  Api api;

  AccountCubit(this.api) : super(AccountState.init());

  Future<void> loadUser() async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      UserInformation user = await api.getUser();
      int usernameChangeTime = await api.getLastUsernameChangeTime();
      Map<String, dynamic> streak = await api.getStreak();
      emit(state.copyWith(loadStatus: LoadStatus.Success, user: user, usernameChangeTime: usernameChangeTime, streak: streak));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  Future<void> reAuthenticateWithCheck({String? password}) async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      bool isReAuthenticated = await api.reAuthenticateWithCheck(password: password);
      emit(state.copyWith(isReAuthenticated: isReAuthenticated, loadStatus: LoadStatus.Success));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  Future<void> changeUsername(String username) async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      await api.changeUsername(username);
      emit(state.copyWith(loadStatus: LoadStatus.Success, user: state.user.copyWith(username: username)));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  Future<void> changePassword(String password) async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      await api.changePassword(password);
      emit(state.copyWith(loadStatus: LoadStatus.Success));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  Future<void> changeEmail(String newEmail) async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      await api.changeEmail(newEmail);
      emit(state.copyWith(loadStatus: LoadStatus.Success));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  Future<void> checkChangeEmailVerified(String newEmail) async {
    try {
      bool isEmailChanged = await api.checkEmailChangeVerified(newEmail);
      if (isEmailChanged) {
        emit(state.copyWith(loadStatus: LoadStatus.Success, user: state.user.copyWith(email: newEmail)));
      }
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      await api.signOut();
      emit(state.copyWith(loadStatus: LoadStatus.Success));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  Future<void> deleteAccount() async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      await api.deleteUser();
      emit(state.copyWith(loadStatus: LoadStatus.Success));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  void resetReAuthenticated() {
    emit(state.copyWith(isReAuthenticated: false));
  }

  Future<void> changeAvatar(String imagePath) async{
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      await api.changeAvatar(imagePath);
      emit(state.copyWith(loadStatus: LoadStatus.Success, user: state.user.copyWith(avt: imagePath)));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  Future<int> getLastUsernameChangeTime() async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      int lastLoginTime = await api.getLastUsernameChangeTime();
      emit(state.copyWith(loadStatus: LoadStatus.Success));
      return lastLoginTime;
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
      return 0;
    }
  }
}
