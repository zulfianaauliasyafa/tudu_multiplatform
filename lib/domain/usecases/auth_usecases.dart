import 'package:tudu/domain/entities/auth_entity.dart';
import 'package:tudu/domain/repositories/auth_repository.dart';

class AuthUseCases {
  final AuthRepository repository;

  AuthUseCases({required this.repository});

  Future<Map<String, dynamic>> signUp(String email, String password) async {
    return await repository.signUp(email, password);
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    return await repository.signIn(email, password);
  }

  Future<void> signOut() async {
    return await repository.signOut();
  }

  AuthEntity? getCurrentUser() {
    return repository.getCurrentUser();
  }
}