part of 'home_cubit.dart';

class HomeState {
  final LoadStatus loadStatus;
  final UserInformation userInfo;

  const HomeState.init({
    this.loadStatus = LoadStatus.Init,
    this.userInfo = const UserInformation.init(),
  });

  //<editor-fold desc="Data Methods">
  const HomeState({
    required this.loadStatus,
    required this.userInfo,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is HomeState &&
              runtimeType == other.runtimeType &&
              loadStatus == other.loadStatus &&
              userInfo == other.userInfo
          );


  @override
  int get hashCode =>
      loadStatus.hashCode ^
      userInfo.hashCode;


  @override
  String toString() {
    return 'HomeState{' +
        ' loadStatus: $loadStatus,' +
        ' userInfo: $userInfo,' +
        '}';
  }


  HomeState copyWith({
    LoadStatus? loadStatus,
    UserInformation? userInfo,
  }) {
    return HomeState(
      loadStatus: loadStatus ?? this.loadStatus,
      userInfo: userInfo ?? this.userInfo,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'loadStatus': this.loadStatus,
      'userInfo': this.userInfo,
    };
  }

  factory HomeState.fromMap(Map<String, dynamic> map) {
    return HomeState(
      loadStatus: map['loadStatus'] as LoadStatus,
      userInfo: map['userInfo'] as UserInformation,
    );
  }


//</editor-fold>
}
