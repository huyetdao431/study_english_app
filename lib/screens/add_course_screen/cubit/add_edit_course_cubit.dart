import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/common/enum/load_status.dart';

import '../../../models/word.dart';
import '../../../services/api.dart';

part 'add_edit_course_state.dart';

class AddEditCourseCubit extends Cubit<AddEditCourseState> {
  Api api;

  AddEditCourseCubit(this.api) : super(AddEditCourseState.init());

  Future<void> createCourse(String courseName, List<Word> words) async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      await api.createCourse(courseName, words);
      emit(state.copyWith(loadStatus: LoadStatus.Success));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  Future<void> updateCourse(
    String courseId,
    String courseName,
    List<Word> words,
  ) async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      await api.updateCourse(courseId, courseName, words);
      emit(state.copyWith(loadStatus: LoadStatus.Success));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  Future<void> loadData(String courseId) {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    return api
        .getCourseById(courseId)
        .then((course) {
          emit(
            state.copyWith(
              loadStatus: LoadStatus.Success,
              courseName: course['course'].name,
              words: course['course'].words,
            ),
          );
        })
        .catchError((error) {
          emit(state.copyWith(loadStatus: LoadStatus.Error));
        });
  }
}
