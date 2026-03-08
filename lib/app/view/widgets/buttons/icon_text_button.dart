import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/enums/app_enum.dart';
import '../../../styles/text_styles.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.fontFamily,
    this.iconWidget,
    this.color,
    this.textColor,
    this.borderColor,
    this.height,
    this.textSize,
    this.iconSize = 16,
    this.spacing = 8,
    this.paddingW = 2.5,
    this.paddingH = 2.5,
    this.radius = 18,
    this.iconColor,
    this.exchange = false,
    this.buttonState = AppButtonState.idle,
  });

  final VoidCallback onPressed;
  final String text;
  final String? icon;
  final String? fontFamily;
  final Widget? iconWidget;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final Color? iconColor;
  final double? height;
  final double? textSize;
  final double paddingW;
  final double paddingH;
  final double iconSize;
  final double spacing;
  final double radius;
  final bool exchange;
  final AppButtonState buttonState;

  @override
  Widget build(BuildContext context) {
    Color nullColor = color ?? AppColors.primary;
    final buttonHeight = (height ?? 56).h;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius.r),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(radius.r),
        child: Ink(
          height: buttonHeight,
          decoration: BoxDecoration(
            color: nullColor,
            borderRadius: BorderRadius.circular(radius.r),
            border: Border.all(
              width: borderColor != null ? 1.w : 0,
              color: borderColor ?? nullColor,
            ),
          ),
          child: Row(
            spacing: spacing.w,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (buttonState == AppButtonState.loading)
                SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: CircularProgressIndicator(
                    color: textColor ?? AppColors.white,
                    strokeWidth: 2,
                  ),
                )
              else ...[
                if (!exchange) ...[
                  ?iconWidget,
                  if (icon != null)
                    SvgPicture.asset(
                      icon!,
                      width: iconSize.w,
                      height: iconSize.h,
                      fit: BoxFit.contain,
                      colorFilter: iconColor != null
                          ? ColorFilter.mode(
                              iconColor ?? AppColors.white,
                              BlendMode.srcIn,
                            )
                          : null,
                    ),
                ],
                Flexible(
                  child: RichText(
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: text,
                      style: TextStyles.bodyBold16(context).copyWith(
                        color: textColor ?? AppColors.white85,
                        fontSize: textSize?.sp,
                        fontFamily: fontFamily,
                      ),
                    ),
                  ),
                ),
                if (exchange) ...[
                  ?iconWidget,
                  if (icon != null)
                    SvgPicture.asset(
                      icon!,
                      width: iconSize.w,
                      height: iconSize.h,
                      fit: BoxFit.contain,
                      colorFilter: iconColor != null
                          ? ColorFilter.mode(
                              iconColor ?? AppColors.white,
                              BlendMode.srcIn,
                            )
                          : null,
                    ),
                ],
              ],
            ],
          ),
        ),
      ),
    );

    /*return Expanded(
        child: OutlinedButton(
          onPressed: loading
              ? () {}
              : !waiting
              ? waitOnPressed ?? () {}
              : onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: outlined
                ? Colors.transparent
                : loading
                ? nullColor.withOpacity(.8)
                : !waiting
                ? nullColor.withOpacity(.5)
                : nullColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.r),
            ),
            side: BorderSide(
              color: nullColor,
              width: 1.w,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              */ /*if (loading) ...[
                  LoadingAnimationWidget.beat(
                    color: AppColors.white,
                    size: 16.sp,
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                ],*/ /*
              RichText(
                text: TextSpan(
                  text: text,
                  style: TextStyles.bodySemiBold16(context).copyWith(
                    color: textColor ?? AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        )
      */ /*child: Material(
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: loading
              ? () {}
              : !waiting
                  ? waitOnPressed ?? () {}
                  : onPressed,
          borderRadius: BorderRadius.circular(12.r),
          child: Ink(
            height: 50.h,
            // width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: 12.h,
              horizontal: 10.w,
            ),
            decoration: BoxDecoration(
              color: outlined
                  ? Colors.transparent
                  : loading
                      ? nullColor.withOpacity(.8)
                      : !waiting
                          ? nullColor.withOpacity(.5)
                          : nullColor,
              borderRadius: BorderRadius.circular(100.r),
              border: Border.all(
                width: 1.w,
                color: nullColor,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                */ /* */ /*if (loading) ...[
                  LoadingAnimationWidget.beat(
                    color: AppColors.white,
                    size: 16.sp,
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                ],*/ /* */ /*
                RichText(
                  text: TextSpan(
                    text: text,
                    style: TextStyles.bodySemiBold16(context).copyWith(
                      color: textColor ?? AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),*/ /*
    );*/
  }
}
