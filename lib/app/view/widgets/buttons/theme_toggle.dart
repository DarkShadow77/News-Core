import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../theme/bloc/theme_bloc.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<ThemeBloc>().add(ThemeChanged(!isDark()));
      },
      borderRadius: BorderRadius.circular(12.r),
      child: SvgPicture.asset(
        isDark() ? AssetsSvgIcons.sun : AssetsSvgIcons.moon,
        width: isDark() ? 24.w : 20.w,
        height: isDark() ? 24.h : 20.h,
        colorFilter: ColorFilter.mode(AppColors.dynamic, BlendMode.srcIn),
      ),
    );
  }
}
