import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudu/presentation/provider/auth_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().signOut();
              // No navigation needed here. AuthCheck handles it.
            },
          )
        ],
      ),
      body: const Center(
        child: Text('Welcome! You are logged in.'),
      ),
    );
  }
}