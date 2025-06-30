class UserInformation {
  final String username;
  final String password;
  final String email;

  //<editor-fold desc="Data Methods">
  const UserInformation({
    required this.username,
    required this.password,
    required this.email,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserInformation &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          password == other.password &&
          email == other.email);

  @override
  int get hashCode => username.hashCode ^ password.hashCode ^ email.hashCode;

  @override
  String toString() {
    return 'UserInformation{' +
        ' username: $username,' +
        ' password: $password,' +
        ' email: $email,' +
        '}';
  }

  UserInformation copyWith({
    String? username,
    String? password,
    String? email,
  }) {
    return UserInformation(
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': this.username,
      'password': this.password,
      'email': this.email,
    };
  }

  factory UserInformation.fromMap(Map<String, dynamic> map) {
    return UserInformation(
      username: map['username'] as String,
      password: map['password'] as String,
      email: map['email'] as String,
    );
  }

  //</editor-fold>
}