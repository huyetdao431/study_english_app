class UserInformation {
  final String username;
  final String email;
  final String avt;
  final String uid;
  final String provider;

  const UserInformation.init({
    this.username = '',
    this.email = '',
    this.avt = '',
    this.uid = '',
    this.provider = '',
  });

  //<editor-fold desc="Data Methods">
  const UserInformation({
    required this.username,
    required this.email,
    required this.avt,
    required this.uid,
    required this.provider,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserInformation &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          email == other.email &&
          avt == other.avt &&
          uid == other.uid &&
          provider == other.provider);

  @override
  int get hashCode =>
      username.hashCode ^
      email.hashCode ^
      avt.hashCode ^
      uid.hashCode ^
      provider.hashCode;

  @override
  String toString() {
    return 'UserInformation{' +
        ' username: $username,' +
        ' email: $email,' +
        ' avt: $avt,' +
        ' uid: $uid,' +
        ' provider: $provider,' +
        '}';
  }

  UserInformation copyWith({
    String? username,
    String? email,
    String? avt,
    String? uid,
    String? provider,
  }) {
    return UserInformation(
      username: username ?? this.username,
      email: email ?? this.email,
      avt: avt ?? this.avt,
      uid: uid ?? this.uid,
      provider: provider ?? this.provider,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': this.username,
      'email': this.email,
      'avt': this.avt,
      'uid': this.uid,
      'provider': this.provider,
    };
  }

  factory UserInformation.fromMap(Map<String, dynamic> map) {
    return UserInformation(
      username: map['username'] as String,
      email: map['email'] as String,
      avt: map['avt'] as String,
      uid: map['uid'] as String,
      provider: map['provider'] as String,
    );
  }

  //</editor-fold>
}