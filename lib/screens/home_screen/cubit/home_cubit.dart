import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/common/enum/load_status.dart';
import 'package:study_english_app/models/courses.dart';
import 'package:study_english_app/models/user.dart';

import '../../../services/api.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  Api api;
  HomeCubit(this.api) : super(HomeState.init());

  Future<void> fetchCategories() async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      UserInformation userInfo = await api.getUser();
      emit(state.copyWith(
        loadStatus: LoadStatus.Success,
        userInfo: userInfo,
      ));
    } catch (e) {
      emit(state.copyWith(
        loadStatus: LoadStatus.Error,
      ));
    }
  }
}
