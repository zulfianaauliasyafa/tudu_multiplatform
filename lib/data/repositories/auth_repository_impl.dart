import 'package:firebase_auth/firebase_auth.dart';
import 'package:tudu/data/models/auth_model.dart';
import 'package:tudu/domain/entities/auth_entity.dart';
import 'package:tudu/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;

  AuthRepositoryImpl({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  AuthEntity _createAuthEntity(User user) {
    return AuthModel(
      uid: user.uid,
      email: user.email ?? '',
    );
  }

  @override
  Future<Map<String, dynamic>> signUp(String email, String password) async {
   try {
      print('Starting registration process for email: $email');

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Firebase response received');

      if (credential.user != null) {
        print('User created successfully: ${credential.user!.uid}');
        final user = _createAuthEntity(credential.user!);
        return {
          'success': true,
          'user': user,
          'message': 'Registration successful'
        };
      } else {
        print('User creation failed: credential.user is null');
        return {
          'success': false,
          'message': 'Registration failed - no user created'
        };
      }
    } on FirebaseAuthException catch (e) {
      print(
          'FirebaseAuthException during registration: ${e.code} - ${e.message}');
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak';
          break;
        case 'email-already-in-use':
          message = 'An account already exists for that email';
          break;
        case 'invalid-email':
          message = 'The email address is not valid';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled';
          break;
        default:
          message = 'An error occurred during registration: ${e.message}';
      }
      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      print('Unexpected error during registration: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred: $e',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> signIn(String email, String password) async {
  try {
      print('Starting login process for email: $email');

      // Pastikan tidak ada session yang tersisa
      if (_auth.currentUser != null) {
        print('Signing out existing user: ${_auth.currentUser?.uid}');
        await _auth.signOut();
        await Future.delayed(const Duration(milliseconds: 500));
      }

      print('Attempting to sign in with email and password');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      print('Firebase login response received');
      print('Credential type: ${credential.runtimeType}');
      print('User type: ${credential.user?.runtimeType}');

      if (credential.user != null) {
        print('User logged in successfully: ${credential.user!.uid}');
        print('User email: ${credential.user!.email}');

        // Tunggu sedikit untuk memastikan data user sudah lengkap
        await Future.delayed(const Duration(milliseconds: 500));

        // Refresh user untuk mendapatkan data terbaru
        await credential.user?.reload();
        final currentUser = _auth.currentUser;

        if (currentUser != null) {
          print('Creating auth entity for user: ${currentUser.uid}');
          final user = _createAuthEntity(currentUser);
          print('Auth entity created: ${user.runtimeType}');
          print('Auth entity data: ${user.toJson()}');
          return {'success': true, 'user': user, 'message': 'Login successful'};
        } else {
          print('Login failed: currentUser is null after reload');
          return {'success': false, 'message': 'Login failed - no user data'};
        }
      } else {
        print('Login failed: credential.user is null');
        return {'success': false, 'message': 'Login failed - no user data'};
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException during login: ${e.code} - ${e.message}');
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Email tidak terdaftar';
          break;
        case 'wrong-password':
          message = 'Password salah';
          break;
        case 'user-disabled':
          message = 'Akun ini telah dinonaktifkan';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid';
          break;
        case 'invalid-credential':
          message = 'Email atau password salah';
          break;
        case 'too-many-requests':
          message = 'Terlalu banyak percobaan login. Silakan coba lagi nanti';
          break;
        default:
          message = 'Terjadi kesalahan saat login: ${e.message}';
      }
      return {
        'success': false,
        'message': message,
      };
    } catch (e, stackTrace) {
      print('Unexpected error during login: $e');
      print('Stack trace: $stackTrace');
      return {
        'success': false,
        'message': 'Terjadi kesalahan tidak terduga: $e',
      };
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('User signed out successfully');
    } catch (e) {
      print('Error signing out: $e');
      throw Exception('Failed to sign out: $e');
    }
  }

  @override
  AuthEntity? getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        print('Getting current user: ${user.uid}');
        return _createAuthEntity(user);
      }
      print('No current user found');
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }
}