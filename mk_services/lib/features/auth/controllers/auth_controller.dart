// lib/features/auth/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mk_services/core/models/user_model.dart';
import 'package:mk_services/providers/auth_provider.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

class AuthController {
  final Ref ref;
  AuthController(this.ref);

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final success = await ref
        .read(authProvider.notifier)
        .login(email, password);
    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login failed')));
    }
  }

  Future<bool> requestOtp(String email) async {
    // handle with ApiService separately if needed
    return true;
  }

  Future<bool> verifyOtpAndSignup({
    required String email,
    required String name,
    required String phone,
    required String password,
    required String otp,
    required BuildContext context,
  }) async {
    final verified = await ref
        .read(authProvider.notifier)
        .verifyOtp(email, otp);
    if (!verified) return false;

    final user = UserModel(
      name: name,
      email: email,
      phone: phone,
      location: '', // Update if needed
      role: 'user', // default
      id: '', // will be set by backend
    );

    final success = await ref
        .read(authProvider.notifier)
        .signup(user, password);
    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    }
    return success;
  }

  Future<void> logout(BuildContext context) async {
    await ref.read(authProvider.notifier).logout();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
