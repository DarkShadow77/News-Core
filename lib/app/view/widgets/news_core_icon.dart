import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';

class NewsCoreIcon extends StatelessWidget {
  const NewsCoreIcon({
    super.key,
    this.width = 80,
    this.height = 80,
    this.radius = 14,
    this.bgColor = Colors.transparent,
    this.iconColor = AppColors.primary,
  });

  final double width;
  final double height;
  final double radius;
  final Color bgColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius.r),
        color: bgColor,
      ),
      child: SvgPicture.asset(
        AssetsLogo.logoIcon,
        width: width.r,
        height: height.r,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      ),
    );
  }
}
