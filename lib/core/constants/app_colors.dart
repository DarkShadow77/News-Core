import 'package:flutter/material.dart';

import '../utils/helpers.dart';

class AppColors {
  //State-Colors ---Primary
  static const Color primary = Color(0xFF3C25B3);

  static Color get primary75 => primary.withValues(alpha: .75);

  static Color get primary70 => primary.withValues(alpha: .70);

  static Color get primary50 => primary.withValues(alpha: .50);

  static Color get primary35 => primary.withValues(alpha: .35);

  static Color get primary20 => primary.withValues(alpha: .20);

  static Color get primary15 => primary.withValues(alpha: .15);

  static Color get primary10 => primary.withValues(alpha: .10);

  static Color get primary07 => primary.withValues(alpha: .07);

  static Color get primary05 => primary.withValues(alpha: .05);

  //State-Colors ---Black
  static const Color black = Color(0xFF071A27);

  static Color get black75 => black.withValues(alpha: .75);

  static Color get black60 => black.withValues(alpha: .60);

  static Color get black50 => black.withValues(alpha: .50);

  static Color get black40 => black.withValues(alpha: .40);

  static Color get black30 => black.withValues(alpha: .30);

  static Color get black25 => black.withValues(alpha: .25);

  static Color get black20 => black.withValues(alpha: .20);

  static Color get black10 => black.withValues(alpha: .10);

  static Color get black05 => black.withValues(alpha: .05);

  //State-Colors ---Dark
  static const Color dark = Color(0xFF1A1A1A);

  static Color get dark75 => dark.withValues(alpha: .75);

  static Color get dark60 => dark.withValues(alpha: .60);

  static Color get dark50 => dark.withValues(alpha: .50);

  static Color get dark40 => dark.withValues(alpha: .40);

  static Color get dark30 => dark.withValues(alpha: .30);

  static Color get dark25 => dark.withValues(alpha: .25);

  static Color get dark20 => dark.withValues(alpha: .20);

  static Color get dark10 => dark.withValues(alpha: .10);

  static Color get dark05 => dark.withValues(alpha: .05);

  //State-Colors ---White
  static const Color white = Color(0xFFFFFFFF);

  static Color get white85 => white.withValues(alpha: .85);

  static Color get white75 => white.withValues(alpha: .75);

  static Color get white50 => white.withValues(alpha: .50);

  static Color get white25 => white.withValues(alpha: .25);

  static Color get white29 => white.withValues(alpha: .29);

  static Color get white10 => white.withValues(alpha: .10);

  static Color get white05 => white.withValues(alpha: .05);

  //State-Colors ---OffWhite
  static Color get offWhite => inverseDynamicColor(.45);

  static Color get offWhite85 => offWhite.withValues(alpha: .85);

  static Color get offWhite75 => offWhite.withValues(alpha: .75);

  static Color get offWhite50 => offWhite.withValues(alpha: .50);

  static Color get offWhite25 => offWhite.withValues(alpha: .25);

  static Color get offWhite29 => offWhite.withValues(alpha: .29);

  static Color get offWhite10 => offWhite.withValues(alpha: .10);

  static Color get offWhite05 => offWhite.withValues(alpha: .05);

  //State-Colors ---Away
  static const Color away = Color(0xFFFFC857);

  static Color get away70 => away.withValues(alpha: .70);

  static Color get away50 => away.withValues(alpha: .50);

  static Color get away39 => away.withValues(alpha: .39);

  static Color get away20 => away.withValues(alpha: .20);

  static Color get away10 => away.withValues(alpha: .10);

  static Color get away5 => away.withValues(alpha: .05);

  //State-Colors ---Error
  static const Color error = Color(0xFFDC0D18);
  static Color get error70 => error.withValues(alpha: .70);
  static Color get error50 => error.withValues(alpha: .50);
  static Color get error39 => error.withValues(alpha: .39);
  static Color get error20 => error.withValues(alpha: .20);
  static Color get error11 => error.withValues(alpha: .11);
  static Color get error5 => error.withValues(alpha: .05);

  //State-Colors ---NavyBlue
  static const Color navyBlue = Color(0xFF0F172A);
  static Color get navyBlue50 => navyBlue.withValues(alpha: .50);
  static Color get navyBlue39 => navyBlue.withValues(alpha: .39);
  static Color get navyBlue11 => navyBlue.withValues(alpha: .11);
  static Color get navyBlue5 => navyBlue.withValues(alpha: .05);
  //State-Colors ---Blue
  static const Color blue = Color(0xFF1E3A8A);
  static Color get blue50 => blue.withValues(alpha: .50);
  static Color get blue39 => blue.withValues(alpha: .39);
  static Color get blue11 => blue.withValues(alpha: .11);
  static Color get blue5 => blue.withValues(alpha: .05);

  //State-Colors ---Orange
  static const Color orange = Color(0xFFF59E0B);
  static Color get orange50 => orange.withValues(alpha: .50);
  static Color get orange39 => orange.withValues(alpha: .39);
  static Color get orange10 => orange.withValues(alpha: .10);
  static Color get orange5 => orange.withValues(alpha: .05);

  //State-Colors ---Orange
  static const Color green = Color(0xFF10B981);
  static Color get green50 => green.withValues(alpha: .50);
  static Color get green39 => green.withValues(alpha: .39);
  static Color get green11 => green.withValues(alpha: .11);
  static Color get green5 => green.withValues(alpha: .05);

  //State-Colors ---Dynamic Color Palette
  static Color get dynamic => dynamicColor();
  static Color get dynamic95 => dynamicColor(.95);
  static Color get dynamic90 => dynamicColor(.9);
  static Color get dynamic85 => dynamicColor(.85);
  static Color get dynamic80 => dynamicColor(.8);
  static Color get dynamic75 => dynamicColor(.75);
  static Color get dynamic70 => dynamicColor(.7);
  static Color get dynamic65 => dynamicColor(.65);
  static Color get dynamic60 => dynamicColor(.6);
  static Color get dynamic55 => dynamicColor(.55);
  static Color get dynamic50 => dynamicColor(.5);
  static Color get dynamic45 => dynamicColor(.45);
  static Color get dynamic40 => dynamicColor(.4);
  static Color get dynamic35 => dynamicColor(.35);
  static Color get dynamic30 => dynamicColor(.3);
  static Color get dynamic25 => dynamicColor(.25);
  static Color get dynamic20 => dynamicColor(.2);
  static Color get dynamic15 => dynamicColor(.15);
  static Color get dynamic10 => dynamicColor(.1);
  static Color get dynamic075 => dynamicColor(.075);
  static Color get dynamic05 => dynamicColor(.05);
  static Color get dynamic025 => dynamicColor(.025);

  //State-Colors ---Dynamic Color Palette
  static Color get inverseDynamic => inverseDynamicColor();
  static Color get inverseDynamic95 => inverseDynamicColor(.95);
  static Color get inverseDynamic90 => inverseDynamicColor(.9);
  static Color get inverseDynamic85 => inverseDynamicColor(.85);
  static Color get inverseDynamic80 => inverseDynamicColor(.8);
  static Color get inverseDynamic75 => inverseDynamicColor(.75);
  static Color get inverseDynamic70 => inverseDynamicColor(.7);
  static Color get inverseDynamic65 => inverseDynamicColor(.65);
  static Color get inverseDynamic60 => inverseDynamicColor(.6);
  static Color get inverseDynamic55 => inverseDynamicColor(.55);
  static Color get inverseDynamic50 => inverseDynamicColor(.5);
  static Color get inverseDynamic45 => inverseDynamicColor(.45);
  static Color get inverseDynamic40 => inverseDynamicColor(.4);
  static Color get inverseDynamic35 => inverseDynamicColor(.35);
  static Color get inverseDynamic30 => inverseDynamicColor(.3);
  static Color get inverseDynamic25 => inverseDynamicColor(.25);
  static Color get inverseDynamic20 => inverseDynamicColor(.2);
  static Color get inverseDynamic15 => inverseDynamicColor(.15);
  static Color get inverseDynamic10 => inverseDynamicColor(.1);
  static Color get inverseDynamic05 => inverseDynamicColor(.05);
}
