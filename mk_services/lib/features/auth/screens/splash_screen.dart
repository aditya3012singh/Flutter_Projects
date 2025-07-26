// lib/features/auth/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      // context.go('/login');
      context.go('/userhome');
    });

    return Scaffold(body: Center(child: Image.asset('assets/images/mk.png')));
  }
}
