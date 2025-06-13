import 'package:flutter/material.dart';
import 'package:tudu/domain/entities/auth_entity.dart';
import 'package:tudu/domain/usecases/auth_usecases.dart';

// Enum to represent the different states of authentication.
enum AuthStatus { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider with ChangeNotifier {
  final AuthUseCases _authUseCases;

  AuthStatus _status = AuthStatus.Uninitialized;
  AuthEntity? _user;

  // Getters for the UI to access the state.
  AuthStatus get status => _status;
  AuthEntity? get user => _user;

  AuthProvider({required AuthUseCases authUseCases}) : _authUseCases = authUseCases {
    checkAuthStatus();
  }

  /// Checks the initial authentication status when the app starts.
  Future<void> checkAuthStatus() async {
    _status = AuthStatus.Authenticating;
    notifyListeners();

    final currentUser = _authUseCases.getCurrentUser();
    if (currentUser != null && currentUser.email.isNotEmpty) {
      _user = currentUser;
      _status = AuthStatus.Authenticated;
    } else {
      _status = AuthStatus.Unauthenticated;
    }
    notifyListeners();
  }

  /// Signs in a user and returns an error message on failure.
  Future<String?> signIn(String email, String password) async {
    _status = AuthStatus.Authenticating;
    notifyListeners();

    final result = await _authUseCases.signIn(email, password);

    if (result['success']) {
      _user = result['user'];
      _status = AuthStatus.Authenticated;
      notifyListeners();
      return null; // No error
    } else {
      _status = AuthStatus.Unauthenticated;
      notifyListeners();
      return result['message']; // Return error message
    }
  }

  /// Signs up a new user and returns an error message on failure.
  Future<String?> signUp(String email, String password) async {
    _status = AuthStatus.Authenticating;
    notifyListeners();

    final result = await _authUseCases.signUp(email, password);

    if (result['success']) {
      _user = result['user'];
      _status = AuthStatus.Authenticated;
      notifyListeners();
      return null; // No error
    } else {
      _status = AuthStatus.Unauthenticated;
      notifyListeners();
      return result['message']; // Return error message
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _authUseCases.signOut();
    _user = null;
    _status = AuthStatus.Unauthenticated;
    notifyListeners();
  }
}