import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mk_services/core/models/user_model.dart';
import 'package:mk_services/core/services/api_service.dart';
import 'package:mk_services/storage/local_storage.dart';

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
      return AuthNotifier();
    });

final authChangeNotifierProvider = Provider<AuthChangeNotifier>((ref) {
  return ref.watch(authNotifierProvider.notifier).notifier;
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final ApiService _apiService = ApiService();
  final _authChangeNotifier = AuthChangeNotifier._();

  AuthNotifier() : super(const AsyncValue.loading()) {
    loadUser();
  }

  AuthChangeNotifier get notifier => _authChangeNotifier;

  Future<void> loadUser() async {
    final token = await LocalStorage.getToken();
    if (token == null) {
      state = const AsyncValue.data(null);
      notifier.notify();
      return;
    }

    try {
      final user = await _apiService.getProfile();
      if (user != null) {
        state = AsyncValue.data(user);
      } else {
        await LocalStorage.clearAll();
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      await LocalStorage.clearAll();
      state = AsyncValue.error(e, st);
    } finally {
      notifier.notify();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      // Don’t trigger full app loading
      final user = await _apiService.login(email, password);

      if (user != null) {
        state = AsyncValue.data(user);
        notifier.notify();
        return true;
      } else {
        state = const AsyncValue.data(null);
        notifier.notify();
        return false;
      }
    } catch (e) {
      final isUserNotFound = e.toString().contains('UserNotFound');
      if (isUserNotFound) {
        state = const AsyncValue.data(null);
        notifier.notify();
        return false;
      }

      // Don't crash UI, set error state if needed
      state = AsyncValue.error(e, StackTrace.current);
      notifier.notify();
      return false;
    }
  }

  Future<bool> signup(UserModel user, String password) async {
    try {
      final createdUser = await _apiService.signup(user, password);
      state = AsyncValue.data(createdUser); // Only update state after success
      notifier.notify();
      return true;
    } catch (e, st) {
      // Don't assign AsyncValue.error() if you want to suppress screen errors
      // Optionally log error instead
      notifier.notify();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (_) {}

    await LocalStorage.clearAll();
    state = const AsyncValue.data(null);
    notifier.notify();
  }

  void clearSession() {
    LocalStorage.clearAll();
    state = const AsyncValue.data(null);
    notifier.notify();
  }

  void updateUser(UserModel updatedUser) {
    state = AsyncValue.data(updatedUser);
    notifier.notify();
  }

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
        notifier.notify();
        return true;
      }
      return false;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      notifier.notify();
      return false;
    }
  }

  Future<bool> sendOtp(String email) async {
    try {
      return await _apiService.sendOtp(email);
    } catch (_) {
      return false;
    }
  }

  Future<bool> verifyOtp(String email, String code) async {
    try {
      return await _apiService.verifyOtp(email, code);
    } catch (_) {
      return false;
    }
  }
}

class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier._();
  void notify() => notifyListeners();
}
