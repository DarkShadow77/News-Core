import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_core/featured/home/presentation/pages/home_page.dart';
import 'package:news_core/featured/profile/presentation/pages/profile_page.dart';

import '../../../../app/theme/bloc/theme_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/utils/helpers.dart';
import '../bloc/dashboard_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, required this.param});

  final DashboardPageParam param;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(
      PageChangedEvent(index: widget.param.index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeMode>(
      builder: (context, state) {
        return BlocBuilder<DashboardBloc, int>(
          builder: (context, dashState) {
            return Scaffold(
              extendBody: true,
              body: Stack(
                children: [
                  // Main content
                  IndexedStack(
                    index: dashState,
                    children: [
                      NewsHomePage(),
                      Center(child: Text("Explore")),
                      Center(child: Text("Favorite")),
                      ProfilePage(),
                    ],
                  ),

                  // Bottom gradient overlay (optional - makes content fade behind nav)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: IgnorePointer(
                      child: Container(
                        height: 120.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              (isDark() ? Colors.black : Colors.white)
                                  .withValues(alpha: 0.8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: Container(
                height: 68.h,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  bottom: 20.h + MediaQuery.of(context).viewPadding.bottom,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(40.r),
                ),
                child: Row(
                  spacing: 10.w,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(Lists.navBar.length, (idx) {
                    final value = Lists.navBar[idx];
                    return BottomNavIcon(
                      value: value,
                      selected: idx == dashState,
                      onTap: () {
                        context.read<DashboardBloc>().add(
                          PageChangedEvent(index: idx),
                        );
                      },
                    );
                  }),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class BottomNavIcon extends StatelessWidget {
  const BottomNavIcon({
    super.key,
    required this.onTap,
    required this.value,
    required this.selected,
  });

  final VoidCallback onTap;
  final Map<String, dynamic> value;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: selected ? AppColors.black : null,
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: SvgPicture.asset(
          value["icon"]!,
          height: 24.h,
          width: 24.w,
          fit: BoxFit.contain,
          colorFilter: selected
              ? ColorFilter.mode(AppColors.white, BlendMode.srcIn)
              : ColorFilter.mode(AppColors.white70, BlendMode.srcIn),
        ),
      ),
    );
  }
}

class DashboardPageParam {
  final int index;

  DashboardPageParam({required this.index});
}
