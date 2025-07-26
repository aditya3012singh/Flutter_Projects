// File: core/services/local_storage.dart
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences _prefs;

  static const _tokenKey = 'auth_token';

  /// Call this once in main() before using any other method
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save auth token
  static Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  /// Retrieve auth token
  static String? getToken() => _prefs.getString(_tokenKey);

  /// Remove auth token and optionally other keys
  static Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
  }

  /// Generic string setter/getter
  static Future<void> setString(String key, String value) async =>
      await _prefs.setString(key, value);

  static String? getString(String key) => _prefs.getString(key);

  /// Boolean setter/getter
  static Future<void> setBool(String key, bool value) async =>
      await _prefs.setBool(key, value);

  static bool? getBool(String key) => _prefs.getBool(key);

  /// Integer setter/getter
  static Future<void> setInt(String key, int value) async =>
      await _prefs.setInt(key, value);

  static int? getInt(String key) => _prefs.getInt(key);

  /// Clear all shared preferences (e.g., on full logout/reset)
  static Future<void> clearAll() async {
    await _prefs.clear();
  }
}
