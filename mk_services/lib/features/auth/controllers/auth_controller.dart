import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import 'package:mk_services/core/models/user_model.dart';
import 'package:mk_services/providers/auth_provider.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

class AuthController {
  final Ref ref;
  AuthController(this.ref);

  /// Login user and navigate based on role
  Future<bool> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final success = await ref
          .read(authNotifierProvider.notifier)
          .login(email, password);

      if (success) {
        final user = ref.read(authNotifierProvider).value;
        Fluttertoast.showToast(
          msg: "Login successful!",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        _navigateBasedOnRole(user?.role, context);
        return true;
      } else {
        // Handle login failure: User not found
        Fluttertoast.showToast(
          msg: "User not found. Redirecting to signup...",
          backgroundColor: Colors.orange,
          textColor: Colors.white,
        );
        Future.microtask(() => context.go('/signup'));
        return false;
      }
    } catch (e) {
      // Catch unexpected errors without crashing UI
      Fluttertoast.showToast(
        msg: "Something went wrong. Please try again.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      Future.microtask(() => context.go('/signup'));
      return false;
    }
  }

  /// Send OTP for signup
  Future<bool> requestOtp(String email) async {
    try {
      return await ref.read(authNotifierProvider.notifier).sendOtp(email);
    } catch (_) {
      Fluttertoast.showToast(
        msg: "Failed to send OTP",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  /// Verify OTP and complete signup
  Future<bool> verifyOtpAndSignup({
    required String email,
    required String name,
    required String phone,
    required String password,
    required String otp,
    String role = 'USER',
    required BuildContext context,
  }) async {
    final verified = await ref
        .read(authNotifierProvider.notifier)
        .verifyOtp(email, otp);

    if (!verified) {
      Fluttertoast.showToast(
        msg: "Invalid OTP",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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

    try {
      final success = await ref
          .read(authNotifierProvider.notifier)
          .signup(user, password);

      if (success) {
        Fluttertoast.showToast(
          msg: "Account created successfully!",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        final newUser = ref.read(authNotifierProvider).value;
        _navigateBasedOnRole(newUser?.role, context);
      } else {
        Fluttertoast.showToast(
          msg: "Signup failed",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }

      return success;
    } catch (e) {
      try {
        // Try to decode the error if it's a JSON
        final Map<String, dynamic> errorData = json.decode(
          e.toString().replaceFirst('Exception: ', ''),
        );
        final errorMessage = errorData['message']?.toLowerCase() ?? '';

        if (errorMessage.contains("admin already exists")) {
          Fluttertoast.showToast(
            msg: "Admin already exists. Only one admin is allowed.",
            backgroundColor: Colors.orange,
            textColor: Colors.white,
          );
        } else if (errorMessage.contains("technician already exists")) {
          Fluttertoast.showToast(
            msg: "Technician already exists. Only one technician is allowed.",
            backgroundColor: Colors.orange,
            textColor: Colors.white,
          );
        } else if (errorMessage.contains("user already exists")) {
          Fluttertoast.showToast(
            msg: "User already exists. Please login instead.",
            backgroundColor: Colors.orange,
            textColor: Colors.white,
          );
        } else if (errorMessage.contains("please verify your email")) {
          Fluttertoast.showToast(
            msg: "Please verify your email via OTP before signing up.",
            backgroundColor: Colors.orange,
            textColor: Colors.white,
          );
        } else {
          Fluttertoast.showToast(
            msg: "Signup failed: $errorMessage",
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } catch (_) {
        // Fallback in case decoding fails
        Fluttertoast.showToast(
          msg: "Signup failed: ${e.toString()}",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }

      return false;
    }
  }

  /// Logout and redirect to login
  Future<void> logout(BuildContext context) async {
    await ref.read(authNotifierProvider.notifier).logout();
    Fluttertoast.showToast(
      msg: "Logged out",
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
    Future.microtask(() => context.go('/login'));
  }

  /// Role-based navigation
  void _navigateBasedOnRole(String? role, BuildContext context) {
    final normalizedRole = role?.toLowerCase();
    if (normalizedRole == 'admin') {
      context.go('/admin/home');
    } else if (normalizedRole == 'provider' || normalizedRole == 'technician') {
      context.go('/provider/dashboard');
    } else {
      context.go('/user/main');
    }
  }
}
