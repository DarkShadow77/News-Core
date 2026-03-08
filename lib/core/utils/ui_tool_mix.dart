import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/styles/text_styles.dart';
import '../constants/app_colors.dart';
import 'helpers.dart';

mixin UIToolMixin {
  void showMessage(
    BuildContext context,
    String message, {
    String? subText,
    bool status = false,
  }) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10.h,
        left: 20.w,
        right: 20.w,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.dynamic10,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
              color: !status ? surfaceColor() : lighten(AppColors.primary, .9),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              spacing: 8.w,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: status ? 32.r : 24.r,
                  width: status ? 32.r : 24.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: status ? AppColors.primary10 : AppColors.green,
                  ),
                  child: status
                      ? Icon(
                          Icons.close_rounded,
                          size: 18.sp,
                          color: AppColors.primary,
                        )
                      : Icon(
                          Icons.check,
                          size: 18.sp,
                          color: AppColors.inverseDynamic,
                        ),
                ),
                Expanded(
                  child: Column(
                    spacing: 8.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: message,
                          style: TextStyles.bodyMedium16(context),
                        ),
                      ),
                      if (subText != null)
                        RichText(
                          text: TextSpan(
                            text: subText,
                            style: TextStyles.smallRegular12(
                              context,
                              opacity: .4,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 3)).then((_) => entry.remove());
  }
}
