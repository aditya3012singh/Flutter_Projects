import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mk_services/core/models/user_model.dart';
import 'package:mk_services/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

class AuthController {
  final Ref ref;
  AuthController(this.ref);

  /// User Login
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final success = await ref
        .read(authProvider.notifier)
        .login(email, password);

    if (success) {
      final user = ref.read(authProvider).value;
      Fluttertoast.showToast(
        msg: "Login successful!",
        backgroundColor: Colors.green,
      );

      // Navigate based on user role
      if (user?.role?.toLowerCase() == 'admin') {
        context.go('/admin/home');
      } else if (user?.role?.toLowerCase() == 'provider') {
        context.go('/provider/dashboard');
      } else {
        context.go('/user/main');
      }
    } else {
      Fluttertoast.showToast(msg: "Login failed", backgroundColor: Colors.red);
    }
  }

  /// Request OTP
  Future<bool> requestOtp(String email) async {
    try {
      return await ref.read(authProvider.notifier).sendOtp(email);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to send OTP",
        backgroundColor: Colors.red,
      );
      return false;
    }
  }

  /// Verify OTP & Sign Up
  Future<bool> verifyOtpAndSignup({
    required String email,
    required String name,
    required String phone,
    required String password,
    required String otp,
    String role = 'USER', // Default role
    required BuildContext context,
  }) async {
    final verified = await ref
        .read(authProvider.notifier)
        .verifyOtp(email, otp);

    if (!verified) {
      Fluttertoast.showToast(msg: "Invalid OTP", backgroundColor: Colors.red);
      return false;
    }

    final user = UserModel(
      id: null,
      name: name,
      email: email,
      phone: phone,
      location: '',
      role: role,
    );

    final success = await ref
        .read(authProvider.notifier)
        .signup(user, password);

    if (success) {
      Fluttertoast.showToast(
        msg: "Account created successfully!",
        backgroundColor: Colors.green,
      );
      final newUser = ref.read(authProvider).value;

      // Navigate based on role after signup
      if (newUser?.role?.toLowerCase() == 'admin') {
        context.go('/admin/dashboard');
      } else if (newUser?.role?.toLowerCase() == 'provider') {
        context.go('/provider/dashboard');
      } else {
        context.go('/user/main');
      }
    } else {
      Fluttertoast.showToast(msg: "Signup failed", backgroundColor: Colors.red);
    }

    return success;
  }

  /// Logout
  Future<void> logout(BuildContext context) async {
    await ref.read(authProvider.notifier).logout();
    Fluttertoast.showToast(msg: "Logged out", backgroundColor: Colors.blue);
    context.go('/login');
  }
}
