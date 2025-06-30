part of 'login_cubit.dart';
class LoginState {
  final String email;
  final String password;
  final bool isVerified;
  final LoadStatus loadStatus;

  const LoginState.init({
    this.email = '',
    this.password = '',
    this.isVerified = false,
    this.loadStatus = LoadStatus.Init,
  });

  //<editor-fold desc="Data Methods">
  const LoginState({
    required this.email,
    required this.password,
    required this.isVerified,
    required this.loadStatus,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoginState &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password &&
          isVerified == other.isVerified &&
          loadStatus == other.loadStatus);

  @override
  int get hashCode =>
      email.hashCode ^
      password.hashCode ^
      isVerified.hashCode ^
      loadStatus.hashCode;

  @override
  String toString() {
    return 'LoginState{' +
        ' email: $email,' +
        ' password: $password,' +
        ' isVerified: $isVerified,' +
        ' loadStatus: $loadStatus,' +
        '}';
  }

  LoginState copyWith({
    String? email,
    String? password,
    bool? isVerified,
    LoadStatus? loadStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isVerified: isVerified ?? this.isVerified,
      loadStatus: loadStatus ?? this.loadStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': this.email,
      'password': this.password,
      'isVerified': this.isVerified,
      'loadStatus': this.loadStatus,
    };
  }

  factory LoginState.fromMap(Map<String, dynamic> map) {
    return LoginState(
      email: map['email'] as String,
      password: map['password'] as String,
      isVerified: map['isVerified'] as bool,
      loadStatus: map['loadStatus'] as LoadStatus,
    );
  }

  //</editor-fold>
}
