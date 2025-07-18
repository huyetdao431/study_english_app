part of 'home_cubit.dart';

class HomeState {
  final LoadStatus loadStatus;
  final UserInformation userInfo;
  final Map<String, dynamic> latestCourse;
  final List<Map<String, dynamic>> suggestCourse;
  final Map<String, dynamic> streak;

  const HomeState.init({
    this.loadStatus = LoadStatus.Init,
    this.userInfo = const UserInformation.init(),
    this.latestCourse = const {},
    this.suggestCourse = const [],
    this.streak = const {},
  });

  //<editor-fold desc="Data Methods">
  const HomeState({
    required this.loadStatus,
    required this.userInfo,
    required this.latestCourse,
    required this.suggestCourse,
    required this.streak,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HomeState &&
          runtimeType == other.runtimeType &&
          loadStatus == other.loadStatus &&
          userInfo == other.userInfo &&
          latestCourse == other.latestCourse &&
          suggestCourse == other.suggestCourse &&
          streak == other.streak);

  @override
  int get hashCode =>
      loadStatus.hashCode ^
      userInfo.hashCode ^
      latestCourse.hashCode ^
      suggestCourse.hashCode ^
      streak.hashCode;

  @override
  String toString() {
    return 'HomeState{' +
        ' loadStatus: $loadStatus,' +
        ' userInfo: $userInfo,' +
        ' latestCourse: $latestCourse,' +
        ' suggestCourse: $suggestCourse,' +
        ' streak: $streak,' +
        '}';
  }

  HomeState copyWith({
    LoadStatus? loadStatus,
    UserInformation? userInfo,
    Map<String, dynamic>? latestCourse,
    List<Map<String, dynamic>>? suggestCourse,
    Map<String, dynamic>? streak,
  }) {
    return HomeState(
      loadStatus: loadStatus ?? this.loadStatus,
      userInfo: userInfo ?? this.userInfo,
      latestCourse: latestCourse ?? this.latestCourse,
      suggestCourse: suggestCourse ?? this.suggestCourse,
      streak: streak ?? this.streak,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'loadStatus': this.loadStatus,
      'userInfo': this.userInfo,
      'latestCourse': this.latestCourse,
      'suggestCourse': this.suggestCourse,
      'streak': this.streak,
    };
  }

  factory HomeState.fromMap(Map<String, dynamic> map) {
    return HomeState(
      loadStatus: map['loadStatus'] as LoadStatus,
      userInfo: map['userInfo'] as UserInformation,
      latestCourse: map['latestCourse'] as Map<String, dynamic>,
      suggestCourse: map['suggestCourse'] as List<Map<String, dynamic>>,
      streak: map['streak'] as Map<String, dynamic>,
    );
  }

  //</editor-fold>
}
