import 'package:flutter/material.dart';

class AppColors {
  static const MaterialColor primaryColor = MaterialColor(
    0xFFF4511E, // Base color (maps to 500)
    <int, Color>{
      50: Color(0xFFFCEAE4),
      100: Color(0xFFF8CAB9),
      200: Color(0xFFF5A78B),
      300: Color(0xFFF1835C),
      400: Color(0xFFEF6A3D),
      500: Color(0xFFF4511E), // Base
      600: Color(0xFFE2491B),
      700: Color(0xFFCC3F17),
      800: Color(0xFFB63513),
      900: Color(0xFF8E250B),
    },
  );

  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color backgroundColor = Color(0xFFF8F9FF);

  // MaterialColor swatch for background tints and surfaces
  static const MaterialColor backgroundSwatch = MaterialColor(
    0xFFF8F9FF,
    <int, Color>{
      50: Color(0xFFFFFFFF), // Pure white tint
      100: Color(0xFFF8F9FF), // Original base color
      200: Color(0xFFEDEFFD),
      300: Color(0xFFDFE3FC),
      400: Color(0xFFD0D6FA),
      500: Color(0xFFC0C7F8), // Mid-tone
      600: Color(0xFFA1ACF4),
      700: Color(0xFF7E8CF0),
      800: Color(0xFF5365EC),
      900: Color(0xFF2C3EE2), // Dark accent balance
    },
  );
  static const Color textColor = Color(0xFF000000);
  static const Color accentColor = Color(0xFFFFC107);
}
