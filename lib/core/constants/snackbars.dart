import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/helpers.dart';
import 'app_colors.dart';

class UtilsSnackBars {
  void errorSnackBar({
    String? title,
    required String message,
    SnackPosition position = SnackPosition.TOP,
  }) {
    Get.snackbar(
      title ?? "Error",
      message,
      backgroundColor: AppColors.error50,
      colorText: AppColors.white,
      snackPosition: position,
    );
  }

  void successSnackBar({
    String? title,
    String? message,
    Widget? icon,
    SnackPosition position = SnackPosition.TOP,
  }) {
    Get.snackbar(
      title ?? "Success",

      message ?? "",
      backgroundColor: surfaceColor(),
      colorText: AppColors.dynamic,
      icon: icon,
      snackPosition: position,
    );
  }
}
