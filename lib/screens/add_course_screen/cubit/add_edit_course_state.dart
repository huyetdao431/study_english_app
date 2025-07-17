part of 'add_edit_course_cubit.dart';

class AddEditCourseState {
  final LoadStatus loadStatus;
  final String courseName;
  final List<Word> words;

  const AddEditCourseState.init({
    this.loadStatus = LoadStatus.Init,
    this.courseName = '',
    this.words = const [],
  });

  //<editor-fold desc="Data Methods">
  const AddEditCourseState({
    required this.loadStatus,
    required this.courseName,
    required this.words,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AddEditCourseState &&
          runtimeType == other.runtimeType &&
          loadStatus == other.loadStatus &&
          courseName == other.courseName &&
          words == other.words);

  @override
  int get hashCode =>
      loadStatus.hashCode ^ courseName.hashCode ^ words.hashCode;

  @override
  String toString() {
    return 'AddEditCourseState{' +
        ' loadStatus: $loadStatus,' +
        ' courseName: $courseName,' +
        ' words: $words,' +
        '}';
  }

  AddEditCourseState copyWith({
    LoadStatus? loadStatus,
    String? courseName,
    List<Word>? words,
  }) {
    return AddEditCourseState(
      loadStatus: loadStatus ?? this.loadStatus,
      courseName: courseName ?? this.courseName,
      words: words ?? this.words,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'loadStatus': this.loadStatus,
      'courseName': this.courseName,
      'words': this.words,
    };
  }

  factory AddEditCourseState.fromMap(Map<String, dynamic> map) {
    return AddEditCourseState(
      loadStatus: map['loadStatus'] as LoadStatus,
      courseName: map['courseName'] as String,
      words: map['words'] as List<Word>,
    );
  }

  //</editor-fold>
}
