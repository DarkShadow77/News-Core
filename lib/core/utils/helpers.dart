import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../app/theme/app_themes.dart';
import '../../app/theme/bloc/theme_bloc.dart';
import '../constants/app_colors.dart';
import '../di/service_locator.dart';

final _themeBloc = sl<ThemeBloc>();

bool isDark() {
  return _themeBloc.state == ThemeMode.dark;
}

Color surfaceColor() {
  return isDark() ? AppTheme.darkScheme.surface : AppTheme.lightScheme.surface;
}

Color inverseSurfaceColor() {
  return isDark() ? AppTheme.lightScheme.surface : AppTheme.darkScheme.surface;
}

Color dynamicColor([double opacity = 1.0]) {
  Color color = isDark() ? AppColors.white : AppColors.black;
  return color.withValues(alpha: opacity);
}

Color inverseDynamicColor([double opacity = 1.0]) {
  Color color = isDark() ? AppColors.black : AppColors.white;
  return color.withValues(alpha: opacity);
}

final amountFormat = NumberFormat("#,##0.00", "en_US");

String getCurrency(String name) {
  var format = NumberFormat.simpleCurrency(
    locale: Platform.localeName,
    name: name,
  );
  return format.currencySymbol;
}

Color lighten(Color color, [double amount = 0.2, Color? mainColor]) {
  final mColor = mainColor ?? surfaceColor();
  assert(amount >= 0 && amount <= 1);
  return Color.alphaBlend(mColor.withValues(alpha: amount), color);
}

void validatePassword({
  required String password,
  required Function(bool) lengthBool,
  required Function(bool) upperBool,
  required Function(bool) lowerBool,
  required Function(bool) numberBool,
  required Function(bool) specialBool,
}) {
  // Password length greater than 8
  lengthBool(password.length >= 8);

  // Contains at least one uppercase letter
  upperBool(RegExp(r'[A-Z]').hasMatch(password));

  // Contains at least one lowercase letter
  lowerBool(RegExp(r'[a-z]').hasMatch(password));

  // Contains at least one digit
  numberBool(RegExp(r'[0-9]').hasMatch(password));

  // Contains at least one special character
  specialBool(RegExp(r'[@$!%?&#*^_~+-]').hasMatch(password));
}

void validateImage({
  required String imagePath,
  required Function(bool) sizeBool,
  required Function(bool) typeBool,
}) {
  if (imagePath != "Choose File" && imagePath.isNotEmpty) {
    final String fileExt = imagePath.split('.').last.toLowerCase();
    final fileSize = getFileSize(file: File(imagePath));

    // check size > 500kb
    sizeBool(fileSize < 500);

    // check allowed types
    typeBool(fileExt == "jpeg" || fileExt == "jpg" || fileExt == "png");
  } else {
    // invalid if no image chosen
    sizeBool(false);
    typeBool(false);
  }
}

void copyToClipboard({
  required BuildContext context,
  required String textToCopy,
  required String message,
}) async {
  try {
    await Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to copy to clipboard.')),
    );
  }
}

double getFileSize({required File file}) {
  final bytes = file.readAsBytesSync().lengthInBytes;
  final kb = bytes / 1024;

  return kb;
}

Map<String, String> separateCountryCode(String phone) {
  // Regular expression to match phone number with country code inside parentheses
  final regex = RegExp(
    r'^\(([^)]+)\)(\d+)$',
  ); // Matches (+234)8165168979 or (+358-18)239898328

  final match = regex.firstMatch(phone);

  if (match != null) {
    final countryCode =
        match.group(1) ?? ''; // Captures the country code inside parentheses
    final localNumber =
        match.group(2) ?? ''; // Captures the local number after the parentheses
    return {'countryCode': countryCode, 'localNumber': localNumber};
  } else {
    // If the phone number doesn't match the expected format, return as is
    return {'countryCode': '', 'localNumber': phone};
  }
}

String formatAmount(
  num value, {
  bool compact = true,
  bool uniComp = false,
  String locale = 'en_US',
}) {
  if (!uniComp) {
    if (!compact || value < 1000000) {
      return NumberFormat("#,##0", locale).format(value);
    }

    final compactFormat = NumberFormat.compact(locale: locale);

    return compactFormat.format(value);
  } else {
    if (!compact) {
      return NumberFormat("#,##0", locale).format(value);
    }

    if (value < 1000) {
      return NumberFormat("#,##0", locale).format(value);
    }

    if (value < 1000000) {
      final v = value / 1000;
      return "${_trim(v)}k";
    }

    if (value < 1000000000) {
      final v = value / 1000000;
      return "${_trim(v)}M";
    }

    final v = value / 1000000000;
    return "${_trim(v)}B";
  }
}

String _trim(num value) {
  final formatted = value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
  return formatted;
}

String formatDate(String date) {
  String dateString = '2026-02-15 23:23:27';
  DateTime dateTime = DateTime.parse(dateString);
  String formatted = DateFormat('d MMM, yyyy').format(dateTime);
  return formatted;
}

List<String> formatDateRange(List<DateTime> dateList) {
  if (dateList.isEmpty || dateList.length > 2) {
    return ["from", "to"]; // Return empty string for invalid input
  }

  final dateFormatter = DateFormat('EEE, dd MMM');
  final yearFormatter = DateFormat('EEE, dd MMM yyyy');
  final currentYear = DateTime.now().year;

  // Single date
  if (dateList.length == 1) {
    final date = dateList[0];
    // Display year only if the date is not in the current year
    return [
      date.year == currentYear
          ? dateFormatter.format(date)
          : yearFormatter.format(date),
      "to",
    ];
  }

  final firstDate = dateList[0];
  final secondDate = dateList[1];

  // Check if both dates are in the same year
  if (firstDate.year == secondDate.year) {
    return [
      firstDate.year == currentYear
          ? dateFormatter.format(firstDate)
          : yearFormatter.format(firstDate),
      secondDate.year == currentYear
          ? dateFormatter.format(secondDate)
          : yearFormatter.format(secondDate),
    ];
  } else {
    // Different years, include the year in both dates
    return [yearFormatter.format(firstDate), yearFormatter.format(secondDate)];
  }
}
