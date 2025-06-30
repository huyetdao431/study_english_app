import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:study_english_app/common/enum/load_status.dart';

import '../../../services/api.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  Api api;
  AccountCubit(this.api) : super(AccountState.init());
  Future<void> logout() async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      await api.signOut();
      emit(state.copyWith(loadStatus: LoadStatus.Success));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }
}
