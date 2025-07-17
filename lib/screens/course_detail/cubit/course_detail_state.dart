part of 'course_detail_cubit.dart';

class CourseDetailState {
  final String courseId;
  final String courseName;
  final String username;
  final String userImageUrl;
  final int numberOfWords;
  final List<Word> words;
  final LoadStatus loadStatus;

  const CourseDetailState.init({
    this.courseId = '',
    this.courseName = '',
    this.username = '',
    this.userImageUrl = '',
    this.numberOfWords = 0,
    this.words = const [],
    this.loadStatus = LoadStatus.Init,
  });

  //<editor-fold desc="Data Methods">
  const CourseDetailState({
    required this.courseId,
    required this.courseName,
    required this.username,
    required this.userImageUrl,
    required this.numberOfWords,
    required this.words,
    required this.loadStatus,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CourseDetailState &&
          runtimeType == other.runtimeType &&
          courseId == other.courseId &&
          courseName == other.courseName &&
          username == other.username &&
          userImageUrl == other.userImageUrl &&
          numberOfWords == other.numberOfWords &&
          words == other.words &&
          loadStatus == other.loadStatus);

  @override
  int get hashCode =>
      courseId.hashCode ^
      courseName.hashCode ^
      username.hashCode ^
      userImageUrl.hashCode ^
      numberOfWords.hashCode ^
      words.hashCode ^
      loadStatus.hashCode;

  @override
  String toString() {
    return 'CourseDetailState{' +
        ' courseId: $courseId,' +
        ' courseName: $courseName,' +
        ' username: $username,' +
        ' userImageUrl: $userImageUrl,' +
        ' numberOfWords: $numberOfWords,' +
        ' words: $words,' +
        ' loadStatus: $loadStatus,' +
        '}';
  }

  CourseDetailState copyWith({
    String? courseId,
    String? courseName,
    String? username,
    String? userImageUrl,
    int? numberOfWords,
    List<Word>? words,
    LoadStatus? loadStatus,
  }) {
    return CourseDetailState(
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      username: username ?? this.username,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      numberOfWords: numberOfWords ?? this.numberOfWords,
      words: words ?? this.words,
      loadStatus: loadStatus ?? this.loadStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseId': this.courseId,
      'courseName': this.courseName,
      'username': this.username,
      'userImageUrl': this.userImageUrl,
      'numberOfWords': this.numberOfWords,
      'words': this.words,
      'loadStatus': this.loadStatus,
    };
  }

  factory CourseDetailState.fromMap(Map<String, dynamic> map) {
    return CourseDetailState(
      courseId: map['courseId'] as String,
      courseName: map['courseName'] as String,
      username: map['username'] as String,
      userImageUrl: map['userImageUrl'] as String,
      numberOfWords: map['numberOfWords'] as int,
      words: map['words'] as List<Word>,
      loadStatus: map['loadStatus'] as LoadStatus,
    );
  }

  //</editor-fold>
}
