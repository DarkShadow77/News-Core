import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../styles/text_styles.dart';

class TextDropdown extends StatelessWidget {
  const TextDropdown({
    super.key,
    required this.hintText,
    required this.text,
    required this.onPressed,
    this.errorBool = false,
    this.enabled = true,
    this.icon,
    this.trailing,
    this.mainColor,
  });

  final String hintText;
  final String text;
  final VoidCallback? onPressed;
  final bool errorBool;
  final bool enabled;
  final IconData? icon;
  final Widget? trailing;
  final Color? mainColor;

  @override
  Widget build(BuildContext context) {
    final color = mainColor ?? AppColors.dynamic05;
    bool hint = true;
    if (text == hintText) {
      hint = true;
    } else {
      hint = false;
    }
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.r),
          color: enabled ? color : AppColors.dynamic20,
          border: Border.all(
            width: 1.w,
            color: !enabled
                ? AppColors.dynamic20
                : errorBool
                ? AppColors.error
                : Colors.transparent,
          ),
        ),
        padding: EdgeInsets.only(
          left: 16.w,
          right: trailing == null ? 16.w : 0.w,
        ),
        child: Row(
          spacing: 10.w,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  text: text,
                  style: TextStyles.smallSemibold12(context).copyWith(
                    color: hint
                        ? AppColors.dynamic40
                        : !enabled
                        ? AppColors.dynamic50
                        : dynamicColor(),
                  ),
                ),
              ),
            ),
            trailing ??
                Icon(
                  icon ?? Icons.arrow_drop_down_rounded,
                  size: 20.sp,
                  color: AppColors.dynamic50,
                ),
          ],
        ),
      ),
    );
  }
}
