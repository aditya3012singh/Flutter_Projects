import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mk_services/core/services/api_service.dart';
import 'package:mk_services/core/models/user_model.dart';
import 'package:mk_services/storage/local_storage.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
      return AuthNotifier();
    });

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final ApiService _apiService = ApiService();

  AuthNotifier() : super(const AsyncValue.loading()) {
    loadUser();
  }

  /// Loads the current user profile if a token exists (app startup)
  Future<void> loadUser() async {
    final token = await LocalStorage.getToken();
    if (token == null) {
      state = const AsyncValue.data(null);
      return;
    }

    try {
      final user = await _apiService.getProfile();
      if (user != null) {
        state = AsyncValue.data(user);
      } else {
        // Token invalid or expired → clear storage
        await LocalStorage.clearAll();
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      await LocalStorage.clearAll();
      state = AsyncValue.error(e, st);
    }
  }

  /// Login user
  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _apiService.login(email, password);
      state = AsyncValue.data(user);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Register a new user (OTP must be verified before calling this)
  Future<bool> signup(UserModel user, String password) async {
    state = const AsyncValue.loading();
    try {
      final createdUser = await _apiService.signup(user, password);
      state = AsyncValue.data(createdUser);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Logout and clear token
  Future<void> logout() async {
    await _apiService.logout();
    state = const AsyncValue.data(null);
  }

  /// Request OTP email (for signup)
  Future<bool> sendOtp(String email) async {
    try {
      return await _apiService.sendOtp(email); // Implemented in ApiService
    } catch (_) {
      return false;
    }
  }

  /// Verify OTP (for signup step)
  Future<bool> verifyOtp(String email, String code) async {
    try {
      return await _apiService.verifyOtp(email, code); // 'code' matches backend
    } catch (_) {
      return false;
    }
  }

  /// Update user state manually (after edits)
  void updateUser(UserModel updatedUser) {
    state = AsyncValue.data(updatedUser);
  }

  /// Update user profile (name, phone, location, password)
  Future<bool> updateUserProfile({
    String? name,
    String? phone,
    String? location,
    String? password,
  }) async {
    try {
      final updatedUser = await _apiService.updateProfile(
        name: name,
        phone: phone,
        location: location,
        password: password,
      );

      if (updatedUser != null) {
        state = AsyncValue.data(updatedUser);
        return true;
      }
      return false;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
