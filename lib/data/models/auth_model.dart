import 'package:tudu/domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  AuthModel({
    required String uid,
    required String email,
  }) : super(
          uid: uid,
          email: email,
        );

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
    };
  }

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
    );
  }
}