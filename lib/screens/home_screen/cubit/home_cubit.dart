import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/common/enum/load_status.dart';
import 'package:study_english_app/models/user.dart';

import '../../../services/api.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  Api api;
  HomeCubit(this.api) : super(HomeState.init());

  Future<void> fetchData() async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      final result = await Future.wait([
        api.getUser(),
        api.updateStreak(),
        api.getStreak(),
        api.getLearnedCourses(),
        api.getCourses('a'),
      ]);
      UserInformation userInfo = result[0] as UserInformation;
      Map<String, dynamic> streak = result[2] as Map<String, dynamic>;
      List<Map<String, dynamic>> latestCourse = result[3] as List<Map<String, dynamic>>;
      List<Map<String, dynamic>> suggestCourses = result[4] as List<Map<String, dynamic>>;
      latestCourse.shuffle();
      suggestCourses.shuffle();
      emit(state.copyWith(
        loadStatus: LoadStatus.Success,
        userInfo: userInfo,
        streak: streak,
        latestCourse: latestCourse.isEmpty ? {} : latestCourse.first,
        suggestCourse: suggestCourses.take(3).toList(),
      ));
    } catch (e) {
      emit(state.copyWith(
        loadStatus: LoadStatus.Error,
      ));
    }
  }
}
