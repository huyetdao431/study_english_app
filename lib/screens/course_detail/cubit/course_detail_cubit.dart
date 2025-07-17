
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/enum/load_status.dart';
import '../../../models/word.dart';
import '../../../services/api.dart';

part 'course_detail_state.dart';

class CourseDetailCubit extends Cubit<CourseDetailState> {
  Api api;
  CourseDetailCubit(this.api) : super(CourseDetailState.init());

  Future<void> fetchCourseDetail(String courseId) async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      final course = await api.getCourseById(courseId);
      final user = await api.getUserById(course['course'].createdBy);
      emit(state.copyWith(
        courseId: course['course'].id,
        username: user.username,
        userImageUrl: user.avt,
        courseName: course['course'].name,
        numberOfWords: course['course'].words.length,
        words: course['course'].words,
        loadStatus: LoadStatus.Success,
      ));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  Future<void> addCourseToUser(String courseId) async{
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      // await api.addCourseToUser(courseId);
      // await api.addUserToCourse(courseId);
      await api.enrollUserToCourse(courseId);
      emit(state.copyWith(
        loadStatus: LoadStatus.Success,
      ));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }
}
