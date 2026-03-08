import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../app/styles/text_styles.dart';
import '../../../../app/view/widgets/news_core_icon.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/pages/authentication_page.dart';

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
  }

  @override
  void dispose() {
    super.dispose();
  }

  /*Widget nextScreen() {
    final hasProfile = context.read<ProfileBloc>().state is ProfileSuccessState;
    if (hasProfile) {
      return const WelcomeBackPage();
    } else {
      return const OnboardingPage();
    }
  }*/

  @override
  Widget build(BuildContext context) {
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
          nextScreen: const AuthenticationPage(),
        ),
      ),
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
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 20),
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
      // t=2.4–4.0s: slide from under the logo → fully visible to the right
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 0.1,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 10,
      ),
    ]).animate(_ctrl);

    // Logo slides up after animation completes (at ~2.4s onwards)
    _logoSlideUp = TweenSequence([
      TweenSequenceItem(
        tween: ConstantTween(0.0),
        weight: 80,
      ), // 0-2.4s: stay at 0
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: -7.0.h, // Move up by 20 pixels
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15, // 2.4-3.0s: slide up
      ),
      TweenSequenceItem(tween: ConstantTween(-7.h), weight: 25), // Stay up
    ]).animate(_ctrl);

    // Text slides down and fades in after logo slides up
    _textSlideDown = TweenSequence([
      TweenSequenceItem(
        tween: ConstantTween(-30.0),
        weight: 80,
      ), // Hidden above
      TweenSequenceItem(
        tween: Tween(
          begin: -30.0,
          end: 0.0, // Slide to final position
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15, // 2.4-3.0s: slide down
      ),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 25), // Stay in place
    ]).animate(_ctrl);

    // Text opacity (hidden during rotation, appears after)
    _textOpacity = TweenSequence([
      TweenSequenceItem(
        tween: ConstantTween(0.0),
        weight: 80,
      ), // Hidden until 2.4s
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 15, // Fade in 2.4-3.0s
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 25), // Fully visible
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            /*FadeTransition(
              opacity: _bgOpacity,
              child: Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  color: AppColors.white10,
                ),
              ),
            ),*/
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _ctrl,
                    builder: (context, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo with rotation, scale, and slide up
                          Transform.translate(
                            offset: Offset(0, _logoSlideUp.value),
                            child: Transform.rotate(
                              angle: _rotation.value,
                              child: Transform.scale(
                                scale: _scale.value,
                                child: NewsCoreIcon(
                                  width: 40.r,
                                  height: 40.r,
                                  iconColor: AppColors.white,
                                  bgColor: AppColors.white.withValues(
                                    alpha: (_bgOpacity.value),
                                  ),
                                  radius: 14.r,
                                ),
                              ),
                            ),
                          ),
                          // Text with slide down and fade in
                          Transform.translate(
                            offset: Offset(0, _textSlideDown.value),
                            child: Opacity(
                              opacity: _textOpacity.value,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: "News Core",
                                  style: TextStyles.bigTitleMedium24(context)
                                      .copyWith(
                                        fontSize: 28.sp,
                                        color: AppColors.white,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
