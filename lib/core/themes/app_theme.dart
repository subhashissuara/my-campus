import 'package:mycampus/core/themes/text_theme.dart';
import 'package:mycampus/core/values/colors.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: AppColor.kPrimaryBlue[100],
        ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: textThemeLight,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Color(0xFFFBFAFF).withOpacity(0.15)),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: ThemeData().colorScheme.copyWith(
      primary: AppColor.kPrimaryBlue[100],
    ),
    scaffoldBackgroundColor: Colors.black,
    textTheme: textThemeDark,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Color(0xFFFBFAFF).withOpacity(0.15)),
  );
}
