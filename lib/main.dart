import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tudu/firebase_options.dart'; // <-- 1. TAMBAHKAN IMPORT INI
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/core/di/injection_container.dart' as di;
import 'package:tudu/presentation/bloc/auth_bloc.dart';
import 'package:tudu/presentation/pages/home_page.dart';
import 'package:tudu/presentation/pages/login_page.dart';
import 'package:tudu/presentation/pages/regist_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase (Gunakan konfigurasi web jika perlu)
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

  // Inisialisasi Dependency Injection
  await di.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthCheck(),
        routes: {
          '/regist': (context) => const RegistPage(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is Authenticated) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}