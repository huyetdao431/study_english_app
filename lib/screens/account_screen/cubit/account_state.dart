part of 'account_cubit.dart';

class AccountState {
  final UserInformation user;
  final bool isReAuthenticated;
  final int usernameChangeTime;
  final Map<String, dynamic> streak;
  final LoadStatus loadStatus;

  const AccountState.init({
    this.user = const UserInformation.init(),
    this.isReAuthenticated = false,
    this.usernameChangeTime = 0,
    this.streak = const {},
    this.loadStatus = LoadStatus.Init,
  });

  //<editor-fold desc="Data Methods">
  const AccountState({
    required this.user,
    required this.isReAuthenticated,
    required this.usernameChangeTime,
    required this.streak,
    required this.loadStatus,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountState &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          isReAuthenticated == other.isReAuthenticated &&
          usernameChangeTime == other.usernameChangeTime &&
          streak == other.streak &&
          loadStatus == other.loadStatus);

  @override
  int get hashCode =>
      user.hashCode ^
      isReAuthenticated.hashCode ^
      usernameChangeTime.hashCode ^
      streak.hashCode ^
      loadStatus.hashCode;

  @override
  String toString() {
    return 'AccountState{' +
        ' user: $user,' +
        ' isReAuthenticated: $isReAuthenticated,' +
        ' usernameChangeTime: $usernameChangeTime,' +
        ' streak: $streak,' +
        ' loadStatus: $loadStatus,' +
        '}';
  }

  AccountState copyWith({
    UserInformation? user,
    bool? isReAuthenticated,
    int? usernameChangeTime,
    Map<String, dynamic>? streak,
    LoadStatus? loadStatus,
  }) {
    return AccountState(
      user: user ?? this.user,
      isReAuthenticated: isReAuthenticated ?? this.isReAuthenticated,
      usernameChangeTime: usernameChangeTime ?? this.usernameChangeTime,
      streak: streak ?? this.streak,
      loadStatus: loadStatus ?? this.loadStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': this.user,
      'isReAuthenticated': this.isReAuthenticated,
      'usernameChangeTime': this.usernameChangeTime,
      'streak': this.streak,
      'loadStatus': this.loadStatus,
    };
  }

  factory AccountState.fromMap(Map<String, dynamic> map) {
    return AccountState(
      user: map['user'] as UserInformation,
      isReAuthenticated: map['isReAuthenticated'] as bool,
      usernameChangeTime: map['usernameChangeTime'] as int,
      streak: map['streak'] as Map<String, dynamic>,
      loadStatus: map['loadStatus'] as LoadStatus,
    );
  }

  //</editor-fold>
}
