import 'dart:developer';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../app/styles/text_styles.dart';
import '../../../../app/view/widgets/news_core_icon.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/authentication_page.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    // Check auth status on app start
    context.read<AuthBloc>().add(CheckAuthStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        bool isAuthenticated = state.status == AuthStatus.authenticated;
        log("Profile ${state.session}");
        return Scaffold(
          backgroundColor: AppColors.primary,
          body: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: AnimatedSplashScreen(
              splash: Splash(),
              splashIconSize: double.infinity,
              duration: 10000,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              animationDuration: Duration(milliseconds: 600),
              pageTransitionType: PageTransitionType.bottomToTop,
              splashTransition: SplashTransition.fadeTransition,
              nextScreen: isAuthenticated
                  ? DashboardPage(param: DashboardPageParam(index: 0))
                  : AuthenticationPage(),
            ),
          ),
        );
      },
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _rotation;
  late Animation<double> _scale;
  late Animation<double> _bgOpacity;
  late Animation<double> _logoSlideUp;
  late Animation<double> _textSlideDown;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..forward();

    _rotation = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 20),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 3.4,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 10,
      ),
      TweenSequenceItem(tween: ConstantTween(3.4), weight: 10),
      TweenSequenceItem(
        tween: Tween(
          begin: 3.4,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 10,
      ),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 50),
    ]).animate(_ctrl);

    _scale = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 20),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.5,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 10,
      ),
      TweenSequenceItem(tween: ConstantTween(1.5), weight: 10),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.5,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 10,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 50),
    ]).animate(_ctrl);

    _bgOpacity = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 40),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 0.1,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 10,
      ),
    ]).animate(_ctrl);

    _logoSlideUp = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 80),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: -7.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(tween: ConstantTween(-7.0), weight: 5),
    ]).animate(_ctrl);

    _textSlideDown = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(-30.0), weight: 80),
      TweenSequenceItem(
        tween: Tween(
          begin: -30.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 5),
    ]).animate(_ctrl);

    _textOpacity = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 80),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 15,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 5),
    ]).animate(_ctrl);
  }

  @override
  dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.primary,
      child: Center(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: Offset(0, _logoSlideUp.value.h),
                  child: Transform.rotate(
                    angle: _rotation.value,
                    child: Transform.scale(
                      scale: _scale.value,
                      child: NewsCoreIcon(
                        width: 40.r,
                        height: 40.r,
                        iconColor: AppColors.white,
                        bgColor: AppColors.white.withValues(
                          alpha: _bgOpacity.value,
                        ),
                        radius: 14.r,
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, _textSlideDown.value),
                  child: Opacity(
                    opacity: _textOpacity.value,
                    child: Padding(
                      padding: EdgeInsets.only(top: 7.h),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "News Core",
                          style: TextStyles.bigTitleMedium24(
                            context,
                          ).copyWith(fontSize: 28.sp, color: AppColors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
