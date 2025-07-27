import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mk_services/storage/local_storage.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const _themeKey = 'theme_mode';

  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  /// Loads saved theme mode from local storage
  Future<void> _loadTheme() async {
    final saved = await LocalStorage.getString(_themeKey); // Now async
    if (saved == 'dark') {
      state = ThemeMode.dark;
    } else if (saved == 'light') {
      state = ThemeMode.light;
    } else {
      state = ThemeMode.system;
    }
  }

  /// Toggles theme and saves it
  void toggleTheme() {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      LocalStorage.setString(_themeKey, 'dark'); // <-- FIXED (2 args)
    } else {
      state = ThemeMode.light;
      LocalStorage.setString(_themeKey, 'light'); // <-- FIXED (2 args)
    }
  }
}
