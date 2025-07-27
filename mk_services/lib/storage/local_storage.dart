import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save authentication token
  static Future<void> saveToken(String token) async {
    await _prefs?.setString('auth_token', token);
  }

  static Future<String?> getToken() async {
    return _prefs?.getString('auth_token');
  }

  static Future<void> clearAll() async {
    await _prefs?.clear();
  }

  // Save any string (used for theme, etc.)
  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  // Get any string (used for theme, etc.)
  static Future<String?> getString(String key) async {
    return _prefs?.getString(key);
  }
}
