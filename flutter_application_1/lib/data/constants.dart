import 'package:flutter/material.dart';

class KTextStyles {
  static const TextStyle titleTealText = TextStyle(
    color: Colors.teal,
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.0,
  );
  static const TextStyle discriptionText = TextStyle(fontSize: 20.0);
}

class KConstants {
  static const String themeModeKey = "themeModeKey";
}

class KValue {
  static const String basicLayout = "Basic Layout";
  static const String basicLayoutDescription =
      "The description of the layout goes for here";
  static const String welcomeScreenLottie = "assets/lotties/WelcomeScreen.json";
  static const String welcomeLottie = "assets/lotties/welcom.json";
}
