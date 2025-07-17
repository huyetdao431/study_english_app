import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:study_english_app/common/enum/load_status.dart';

import '../../../services/api.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  Api api;
  SearchCubit(this.api) : super(SearchState.init());

  Future<void> getCourseName() async{
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      final courseNames = await api.getCourseName();
      emit(state.copyWith(loadStatus: LoadStatus.Success, courseName: courseNames));
    } catch(e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }

  Future<void> getSearchResult(String searchInfo) async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
      final searchResults = await api.getCourses(searchInfo);
      emit(state.copyWith(loadStatus: LoadStatus.Success, searchResults: searchResults));
    } catch(e) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }
}
