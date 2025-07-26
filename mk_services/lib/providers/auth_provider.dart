// lib/features/auth/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mk_services/core/services/api_service.dart';
import 'package:mk_services/core/models/user_model.dart';
import 'package:mk_services/core/services/local_storage.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
      return AuthNotifier();
    });

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final ApiService _apiService = ApiService();

  AuthNotifier() : super(const AsyncValue.loading()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final token = await LocalStorageService.getToken();
    if (token == null) {
      state = const AsyncValue.data(null);
      return;
    }

    try {
      final user = await _apiService.getProfile();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _apiService.login(email, password);
      await LocalStorageService.saveToken(await _apiService.getToken() ?? '');
      state = AsyncValue.data(user);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> signup(UserModel user, String password) async {
    state = const AsyncValue.loading();
    try {
      final createdUser = await _apiService.signup(user, password);
      await LocalStorageService.saveToken(await _apiService.getToken() ?? '');
      state = AsyncValue.data(createdUser);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    await LocalStorageService.clearAll();
    state = const AsyncValue.data(null);
  }

  Future<bool> verifyOtp(String email, String otp) async {
    try {
      return await _apiService.verifyOtp(email, otp);
    } catch (_) {
      return false;
    }
  }
}
