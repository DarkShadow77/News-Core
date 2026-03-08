import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/styles/text_styles.dart';
import '../../../../app/theme/bloc/theme_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/strings.dart';
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
    _fetchDetails();
  }

  _fetchDetails() {
    /* context.read<ProfileBloc>().add(GetProfileEvent());
    context.read<NotificationBloc>().add(GetNotificationEvent());
    context.read<ReferralBloc>().add(GetReferralEvent());
    context.read<WalletBloc>().add(GetSummaryEvent());
    context.read<WalletBloc>().add(GetTransactionHistoryEvent());*/
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeMode>(
      builder: (context, state) {
        return BlocBuilder<DashboardBloc, int>(
          builder: (context, dashState) {
            return Scaffold(
              body: [
                Center(child: Text("Home")),
                Center(child: Text("Home")),
                Center(child: Text("Home")),
                Center(child: Text("Home")),
                /* HomePage(),
                ReferralPage(),
                WalletPage(),
                ProfilePage(),*/
              ][dashState],
              bottomNavigationBar: Container(
                height: 80.h + MediaQuery.of(context).viewPadding.bottom,
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  bottom: MediaQuery.of(context).viewPadding.bottom,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.dynamic10,
                      blurRadius: 8.r,
                      offset: Offset(0, -1.h),
                    ),
                  ],
                ),
                child: Row(
                  spacing: 10.w,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(Lists.navBar.length, (idx) {
                    final value = Lists.navBar[idx];
                    return BottomNavIcon(
                      value: value,
                      selected: idx == dashState,
                      onTap: () {
                        context.read<DashboardBloc>().add(
                          PageChangedEvent(index: idx),
                        );

                        _fetchDetails();
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
      child: Column(
        spacing: 10.h,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            value["icon"]!,
            height: 24.h,
            width: 24.w,
            fit: BoxFit.contain,
            colorFilter: selected
                ? ColorFilter.mode(AppColors.primary, BlendMode.srcIn)
                : ColorFilter.mode(AppColors.dynamic80, BlendMode.srcIn),
          ),
          RichText(
            maxLines: 1,
            textAlign: TextAlign.center,
            text: TextSpan(
              text: value["label"],
              style: TextStyles.normalRegular14(context).copyWith(
                color: selected
                    ? AppColors.primary
                    : TextStyles.cardMedium10(context).color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardPageParam {
  final int index;

  DashboardPageParam({required this.index});
}
