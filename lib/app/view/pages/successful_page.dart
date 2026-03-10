import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_core/core/constants/navigators/route_name.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../core/constants/app_assets.dart';
import '../../../featured/dashboard/presentation/pages/dashboard_page.dart';
import '../widgets/buttons/icon_text_button.dart';

class SuccessfulPage extends StatefulWidget {
  const SuccessfulPage({super.key});

  @override
  State<SuccessfulPage> createState() => _SuccessfulPageState();
}

class _SuccessfulPageState extends State<SuccessfulPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (canPop, result) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteName.dashboardPage,
              arguments: DashboardPageParam(index: 0),
              (route) => false,
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 154.h),
                SvgPicture.asset(
                  AssetsSvgImages.check,
                  width: 203.w,
                  height: 203.h,
                ),
                SizedBox(height: 24.h),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Account Created",
                    style: TextStyles.bigTitleSemiBold24(
                      context,
                    ).copyWith(fontSize: 28.sp, color: AppColors.white),
                  ),
                ),
                SizedBox(height: 8.h),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Your news account has been \nsuccessfully created",
                    style: TextStyles.bodyRegular16(
                      context,
                    ).copyWith(color: AppColors.white),
                  ),
                ),
                SizedBox(height: 152.h),
                IconTextButton(
                  spacing: 10,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteName.dashboardPage,
                      arguments: DashboardPageParam(index: 0),
                      (route) => false,
                    );
                  },
                  text: "Continue to Feed",
                  color: AppColors.black,
                  textColor: AppColors.white,
                  exchange: true,
                  iconWidget: Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.white,
                    size: 20.sp,
                  ),
                ),
                SizedBox(height: 20.h + MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
