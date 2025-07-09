part of 'account_cubit.dart';

class AccountState {
  final UserInformation user;
  final bool isReAuthenticated;
  final int usernameChangeTime;
  final LoadStatus loadStatus;

  const AccountState.init({
    this.user = const UserInformation.init(),
    this.isReAuthenticated = false,
    this.usernameChangeTime = 0,
    this.loadStatus = LoadStatus.Init,
  });

  //<editor-fold desc="Data Methods">
  const AccountState({
    required this.user,
    required this.isReAuthenticated,
    required this.usernameChangeTime,
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
          loadStatus == other.loadStatus);

  @override
  int get hashCode =>
      user.hashCode ^
      isReAuthenticated.hashCode ^
      usernameChangeTime.hashCode ^
      loadStatus.hashCode;

  @override
  String toString() {
    return 'AccountState{' +
        ' user: $user,' +
        ' isReAuthenticated: $isReAuthenticated,' +
        ' usernameChangeTime: $usernameChangeTime,' +
        ' loadStatus: $loadStatus,' +
        '}';
  }

  AccountState copyWith({
    UserInformation? user,
    bool? isReAuthenticated,
    int? usernameChangeTime,
    LoadStatus? loadStatus,
  }) {
    return AccountState(
      user: user ?? this.user,
      isReAuthenticated: isReAuthenticated ?? this.isReAuthenticated,
      usernameChangeTime: usernameChangeTime ?? this.usernameChangeTime,
      loadStatus: loadStatus ?? this.loadStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': this.user,
      'isReAuthenticated': this.isReAuthenticated,
      'usernameChangeTime': this.usernameChangeTime,
      'loadStatus': this.loadStatus,
    };
  }

  factory AccountState.fromMap(Map<String, dynamic> map) {
    return AccountState(
      user: map['user'] as UserInformation,
      isReAuthenticated: map['isReAuthenticated'] as bool,
      usernameChangeTime: map['usernameChangeTime'] as int,
      loadStatus: map['loadStatus'] as LoadStatus,
    );
  }

  //</editor-fold>
}
