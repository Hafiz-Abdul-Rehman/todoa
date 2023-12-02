import 'package:flutter/material.dart';

class AppColors {
  static const Color offWhite = Color(0xFFF7F7F7);
  static const Color dOffWhite = Color(0xFFF7F7F7);
  static const Color doOffWhite = Color(0xFFF3F3F3);
  static const Color ddOffWhite = Color(0xFFE8E8E8);
  static const Color dTOffWhite = Color(0xFFA8A8A8);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color primaryColor = Color(0xFF007AFF);
  static const Color lightPrimaryColor = Color.fromARGB(255, 86, 168, 255);
  static const Color whiteColor = Colors.white;
  static const Color blueBlack = Color(0xFF111727);
  static const Color darkPrimaryColor = Color(0xFF0053A0);
  static const Color redColor = Colors.red;
  static const Color orangeColor = Colors.orange;
  static const Color transparent = Colors.transparent;

  static MaterialColor customPrimaryColor = const MaterialColor(
    0xFF007AFF,
    <int, Color>{
      50: Color(0xFF007AFF),
      100: Color(0xFF007AFF),
      200: Color(0xFF007AFF),
      300: Color(0xFF007AFF),
      400: Color(0xFF007AFF),
      500: Color(0xFF007AFF),
      600: Color(0xFF007AFF),
      700: Color(0xFF007AFF),
      800: Color(0xFF007AFF),
      900: Color(0xFF007AFF),
    },
  );

}
