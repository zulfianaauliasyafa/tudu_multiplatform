import 'package:tudu/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> signUp(String email, String password);
  Future<Map<String, dynamic>> signIn(String email, String password);
  Future<void> signOut();
  AuthEntity? getCurrentUser();
}