part of 'library_cubit.dart';

class LibraryState {
  final LoadStatus loadStatus;
  final List<Map<String, dynamic>> learnedCourses;
  final List<Map<String, dynamic>> userCourses;

  const LibraryState.init({
    this.loadStatus = LoadStatus.Init,
    this.learnedCourses = const [],
    this.userCourses = const [],
  });

  //<editor-fold desc="Data Methods">
  const LibraryState({
    required this.loadStatus,
    required this.learnedCourses,
    required this.userCourses,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryState &&
          runtimeType == other.runtimeType &&
          loadStatus == other.loadStatus &&
          learnedCourses == other.learnedCourses &&
          userCourses == other.userCourses);

  @override
  int get hashCode =>
      loadStatus.hashCode ^ learnedCourses.hashCode ^ userCourses.hashCode;

  @override
  String toString() {
    return 'LibraryState{' +
        ' loadStatus: $loadStatus,' +
        ' learnedCourses: $learnedCourses,' +
        ' userCourses: $userCourses,' +
        '}';
  }

  LibraryState copyWith({
    LoadStatus? loadStatus,
    List<Map<String, dynamic>>? learnedCourses,
    List<Map<String, dynamic>>? userCourses,
  }) {
    return LibraryState(
      loadStatus: loadStatus ?? this.loadStatus,
      learnedCourses: learnedCourses ?? this.learnedCourses,
      userCourses: userCourses ?? this.userCourses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'loadStatus': this.loadStatus,
      'learnedCourses': this.learnedCourses,
      'userCourses': this.userCourses,
    };
  }

  factory LibraryState.fromMap(Map<String, dynamic> map) {
    return LibraryState(
      loadStatus: map['loadStatus'] as LoadStatus,
      learnedCourses: map['learnedCourses'] as List<Map<String, dynamic>>,
      userCourses: map['userCourses'] as List<Map<String, dynamic>>,
    );
  }

  //</editor-fold>
}
