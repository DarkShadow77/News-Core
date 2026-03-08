import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../styles/text_styles.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.onPressed,
    this.waitOnPressed,
    required this.text,
    this.loading = false,
    this.waiting = true,
    this.outlined = false,
    this.color,
    this.textColor,
  });

  final VoidCallback onPressed;
  final VoidCallback? waitOnPressed;
  final String text;
  final bool loading;
  final bool waiting;
  final bool outlined;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    Color nullColor = color ?? AppColors.primary;
    return Material(
      borderRadius: BorderRadius.circular(100.r),
      color: Colors.transparent,
      child: InkWell(
        onTap: loading
            ? () {}
            : !waiting
            ? waitOnPressed ?? () {}
            : onPressed,
        borderRadius: BorderRadius.circular(100.r),
        child: Ink(
          height: 50.h,
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: outlined
                ? Colors.transparent
                : loading
                ? lighten(nullColor)
                : !waiting
                ? AppColors.dynamic40
                : nullColor,
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(
              width: outlined ? 1.w : 0.w,
              color: outlined ? nullColor : Colors.transparent,
            ),
          ),
          child: Row(
            spacing: 12.w,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (loading)
                LoadingAnimationWidget.beat(
                  color: textColor ?? AppColors.white,
                  size: 16.sp,
                ),
              Flexible(
                child: RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: text,
                    style: TextStyles.bodySemiBold16(
                      context,
                    ).copyWith(color: textColor ?? AppColors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
