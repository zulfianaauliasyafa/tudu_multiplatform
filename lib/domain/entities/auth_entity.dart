class AuthEntity {
  final String uid;
  final String email;

  AuthEntity({
    required this.uid,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
    };
  }
}