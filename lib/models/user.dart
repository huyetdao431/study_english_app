class User {
  final String username;
  final String password;

  //<editor-fold desc="Data Methods">
  const User({
    required this.username,
    required this.password,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is User &&
              runtimeType == other.runtimeType &&
              username == other.username &&
              password == other.password
          );


  @override
  int get hashCode =>
      username.hashCode ^
      password.hashCode;


  @override
  String toString() {
    return 'User{' +
        ' username: $username,' +
        ' password: $password,' +
        '}';
  }


  User copyWith({
    String? username,
    String? password,
  }) {
    return User(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'username': this.username,
      'password': this.password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }


//</editor-fold>
}