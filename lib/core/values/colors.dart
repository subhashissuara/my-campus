import 'package:flutter/material.dart';

class AppColor {
  static const Map<int, Color> kPrimaryBlue = {
    100: Color(0xFF4D8FFF),
    80: Color(0xFF80B5FF),
    50: Color(0xFF98C2FF),
    20: Color(0xFFCCE1FF)
  };

  static const Map<int, Color> kTyphographyColor = {
    100: Color(0xFF1A1D26),
    80: Color(0xFF2A2F3D),
    50: Color(0xFF4D5364),
    20: Color(0xFF6E7489)
  };

  static const Map<int, Color> kGrayColor = {
    100: Color(0xFF9A9FAE),
    80: Color(0xFFA8ACB9),
    50: Color(0xFFC4C7D0),
    20: Color(0xFFEBEBEB),
    10: Color(0xFFF4F4F4)
  };

  static const Map<String, Color> kAccentColor = {
    "blue": Color(0xFFCCE1FF),
  };

  static const MaterialColor bluePalette =
  MaterialColor(_bluePalettePrimaryValue, <int, Color>{
    50: Color(0xFFE6F0FF),
    100: Color(0xFFCCE1FF),
    200: Color(0xFFB2D2FF),
    300: Color(0xFF98C2FF),
    400: Color(0xFF80B5FF),
    500: Color(_bluePalettePrimaryValue),
    600: Color(0xFF6EA9FF),
    700: Color(0xFF5D9CFF),
    800: Color(0xFF4D8FFF),
    900: Color(0xFF2E78FF),
  });
  static const int _bluePalettePrimaryValue = 0xFF6AA9FF;

  static const MaterialColor bluePaletteAccent =
  MaterialColor(_bluePaletteAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_bluePaletteAccentValue),
    400: Color(0xFFFEFDFF),
    700: Color(0xFFEAE4FF),
  });
  static const int _bluePaletteAccentValue = 0xFFFFFFFF;
}

