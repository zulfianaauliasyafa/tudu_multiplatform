import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:tudu/firebase_options.dart'; // <-- 1. TAMBAHKAN IMPORT INI
import 'package:tudu/core/di/injection_container.dart' as di;
import 'package:tudu/presentation/provider/auth_provider.dart';
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
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(authUseCases: di.sl()),
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
    // watch<T>() rebuilds the widget when the provider's state changes.
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.status == AuthStatus.Authenticating || authProvider.status == AuthStatus.Uninitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else if (authProvider.status == AuthStatus.Authenticated) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}