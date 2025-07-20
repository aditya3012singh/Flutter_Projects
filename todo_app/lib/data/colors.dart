import 'package:flutter/material.dart';

class LunaColors {
  static const Color lightSky = Color(0xFFA7EBF2); // #A7EBF2
  static const Color aquaBlue = Color(0xFF54ACBF); // #54ACBF
  static const Color deepTeal = Color(0xFF26658C); // #26658C
  static const Color oceanDark = Color(0xFF023859); // #023859
  static const Color midnight = Color(0xFF011C40); // #011C40
}

ThemeData lunaTheme = ThemeData(
  primaryColor: LunaColors.deepTeal,
  scaffoldBackgroundColor: LunaColors.lightSky,
  appBarTheme: AppBarTheme(
    backgroundColor: LunaColors.oceanDark,
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: LunaColors.aquaBlue,
  ),
);
