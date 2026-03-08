import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/fonts.dart';

class AppTheme {
  static ColorScheme lightScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
    surface: AppColors.white,
  );
  static ColorScheme darkScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
    surface: AppColors.dark,
  );
}

final lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: AppFonts.satoshi,
  colorScheme: AppTheme.lightScheme,
  useMaterial3: true,
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: AppFonts.satoshi,
  colorScheme: AppTheme.darkScheme,
  useMaterial3: true,
);
