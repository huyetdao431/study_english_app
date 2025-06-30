part of 'account_cubit.dart';

class AccountState {
  final User? user;
  final LoadStatus loadStatus;

  const AccountState.init({
    this.user,
    this.loadStatus = LoadStatus.Init,
  });

//<editor-fold desc="Data Methods">


  const AccountState({
    this.user,
    required this.loadStatus,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is AccountState &&
              runtimeType == other.runtimeType &&
              user == other.user &&
              loadStatus == other.loadStatus
          );


  @override
  int get hashCode =>
      user.hashCode ^
      loadStatus.hashCode;


  @override
  String toString() {
    return 'AccountState{' +
        ' user: $user,' +
        ' loadStatus: $loadStatus,' +
        '}';
  }


  AccountState copyWith({
    User? user,
    LoadStatus? loadStatus,
  }) {
    return AccountState(
      user: user ?? this.user,
      loadStatus: loadStatus ?? this.loadStatus,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'user': this.user,
      'loadStatus': this.loadStatus,
    };
  }

  factory AccountState.fromMap(Map<String, dynamic> map) {
    return AccountState(
      user: map['user'] as User,
      loadStatus: map['loadStatus'] as LoadStatus,
    );
  }


//</editor-fold>
}
