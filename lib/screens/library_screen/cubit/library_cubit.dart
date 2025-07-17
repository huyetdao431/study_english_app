import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/enum/load_status.dart';
import '../../../services/api.dart';

part 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  Api api;

  LibraryCubit(this.api) : super(LibraryState.init());

  Future<void> fetchCourses() async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      final courses = await api.getUserCourses();
      final learnedCourses = await api.getLearnedCourses();

      emit(
        state.copyWith(
          loadStatus: LoadStatus.Success,
          userCourses: courses.map((course) {
            return {
              'course': course['course'],
              'username': course['username'],
              'avt': course['avt'],
              'latestLearn': course['latestLearn'],
            };
          }).toList(),
          learnedCourses: learnedCourses.map((course) {
            return {
              'course': course['course'],
              'username': course['username'],
              'avt': course['avt'],
              'latestLearn': course['latestLearn'],
            };
          }).toList(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  Future<void> setPublicCourse(String courseId, bool status) async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      await api.setPublicCourse(courseId, status);
      await fetchCourses();
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  Future<void> deleteCourse(String courseId) async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      await api.deleteCourse(courseId);
      await fetchCourses();
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  Future<void> removeUserFromCourse(String courseId) async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      await api.removeUserFromCourse(courseId);
      await fetchCourses();
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

}
