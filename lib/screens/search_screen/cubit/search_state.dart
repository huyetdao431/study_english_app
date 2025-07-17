part of 'search_cubit.dart';

class SearchState {
  final LoadStatus loadStatus;
  final List<String> courseName;
  final List<Map<String, dynamic>> searchResults;

  const SearchState.init({
    this.loadStatus = LoadStatus.Init,
    this.courseName = const [],
    this.searchResults = const [],
  });

  //<editor-fold desc="Data Methods">
  const SearchState({
    required this.loadStatus,
    required this.courseName,
    required this.searchResults,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchState &&
          runtimeType == other.runtimeType &&
          loadStatus == other.loadStatus &&
          courseName == other.courseName &&
          searchResults == other.searchResults);

  @override
  int get hashCode =>
      loadStatus.hashCode ^ courseName.hashCode ^ searchResults.hashCode;

  @override
  String toString() {
    return 'SearchState{' +
        ' loadStatus: $loadStatus,' +
        ' courseName: $courseName,' +
        ' searchResults: $searchResults,' +
        '}';
  }

  SearchState copyWith({
    LoadStatus? loadStatus,
    List<String>? courseName,
    List<Map<String, dynamic>>? searchResults,
  }) {
    return SearchState(
      loadStatus: loadStatus ?? this.loadStatus,
      courseName: courseName ?? this.courseName,
      searchResults: searchResults ?? this.searchResults,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'loadStatus': this.loadStatus,
      'courseName': this.courseName,
      'searchResults': this.searchResults,
    };
  }

  factory SearchState.fromMap(Map<String, dynamic> map) {
    return SearchState(
      loadStatus: map['loadStatus'] as LoadStatus,
      courseName: map['courseName'] as List<String>,
      searchResults: map['searchResults'] as List<Map<String, dynamic>>,
    );
  }

  //</editor-fold>
}
