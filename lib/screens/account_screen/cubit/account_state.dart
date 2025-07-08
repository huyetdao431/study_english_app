part of 'account_cubit.dart';

class AccountState {
  final UserInformation user;
  final bool isReAuthenticated;
  final LoadStatus loadStatus;

  const AccountState.init({
    this.user = const UserInformation.init(),
    this.isReAuthenticated = false,
    this.loadStatus = LoadStatus.Init,
  });

  //<editor-fold desc="Data Methods">
  const AccountState({
    required this.user,
    required this.isReAuthenticated,
    required this.loadStatus,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountState &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          isReAuthenticated == other.isReAuthenticated &&
          loadStatus == other.loadStatus);

  @override
  int get hashCode =>
      user.hashCode ^ isReAuthenticated.hashCode ^ loadStatus.hashCode;

  @override
  String toString() {
    return 'AccountState{' +
        ' user: $user,' +
        ' isReAuthenticated: $isReAuthenticated,' +
        ' loadStatus: $loadStatus,' +
        '}';
  }

  AccountState copyWith({
    UserInformation? user,
    bool? isReAuthenticated,
    LoadStatus? loadStatus,
  }) {
    return AccountState(
      user: user ?? this.user,
      isReAuthenticated: isReAuthenticated ?? this.isReAuthenticated,
      loadStatus: loadStatus ?? this.loadStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': this.user,
      'isReAuthenticated': this.isReAuthenticated,
      'loadStatus': this.loadStatus,
    };
  }

  factory AccountState.fromMap(Map<String, dynamic> map) {
    return AccountState(
      user: map['user'] as UserInformation,
      isReAuthenticated: map['isReAuthenticated'] as bool,
      loadStatus: map['loadStatus'] as LoadStatus,
    );
  }

  //</editor-fold>
}
