import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mk_services/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Check auth state after a small delay (so logo is visible)
    Future.delayed(const Duration(seconds: 2), () {
      final authState = ref.read(authNotifierProvider);

      if (!mounted) return;

      if (authState.hasError || authState.value == null) {
        // No user or error → go to login
        context.go('/login');
      } else {
        final user = authState.value!;
        final role = user.role?.toLowerCase();

        // Role-based navigation
        if (role == 'admin') {
          context.go('/admin/dashboard');
        } else if (role == 'provider') {
          context.go('/provider/dashboard');
        } else {
          context.go('/user/main');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/images/mk.png'), height: 120),
            SizedBox(height: 24),
            CircularProgressIndicator(color: Colors.blue),
          ],
        ),
      ),
    );
  }
}
