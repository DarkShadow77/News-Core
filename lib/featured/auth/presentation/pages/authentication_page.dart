import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_core/core/constants/app_assets.dart';
import 'package:news_core/core/utils/helpers.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/input/text_input_field.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../app/view/widgets/buttons/icon_text_button.dart';
import '../../../../app/view/widgets/input/input_title.dart';
import '../../../../app/view/widgets/news_core_icon.dart';
import '../../../../core/constants/enums/app_enum.dart';
import '../../../../core/utils/ui_tool_mix.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>
    with UIToolMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isUsernameValid = false;
  bool _isEmailValid = false;
  bool _isPassValid = false;
  bool _isFormValid = true;

  bool loading = false;
  bool waitingProfile = false;
  bool _isInit = false;
  bool _isLogin = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() => _isInit = true);
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    setState(() {
      _isUsernameValid = username.length > 1;
      _isEmailValid = GetUtils.isEmail(email);
      _isPassValid = password.length > 1;
    });
  }

  bool _formValidation() {
    if (_isLogin) {
      return _isUsernameValid && _isPassValid;
    }
    return _isUsernameValid && _isEmailValid && _isPassValid;
  }

  void _submit() {
    _validateForm();
    _isFormValid = _formValidation();
    if (_isFormValid) {
      setState(() => loading = true);

      Future.delayed((Duration(seconds: 2)), () {
        setState(() => loading = false);
      });
    }
  }

  /*void _loadingAuthState(BuildContext context, AuthLoadingState state) {
    if (state.type == AuthType.login) {
      setState(() => loading = true);
    }
  }

  void _successAuthState(BuildContext context, AuthSuccessState state) {
    if (state.type == AuthType.login) {
      setState(() => loading = true);
      Future.delayed((Duration(seconds: 1)), () {
        setState(() => loading = false);
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(RouteName.dashboardPage, (route) => false);
      });
    }
  }

  void _failedAuthState(BuildContext context, AuthFailureState state) {
    if (state.type == AuthType.login) {
      setState(() => loading = false);
      showMessage(context, state.message, status: true);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 47.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NewsCoreIcon(
                    width: 40.r,
                    height: 40.r,
                    iconColor: AppColors.white,
                    bgColor: AppColors.white10,
                    radius: 14.r,
                  ),
                ],
              ),
              SizedBox(height: 7.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "News Core",
                  style: TextStyles.bigTitleMedium24(
                    context,
                  ).copyWith(fontSize: 28.sp, color: AppColors.white),
                ),
              ),
              if (_isInit) ...[
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AnimatedContainer(
                        duration: Duration(seconds: 1),
                        curve: Curves.easeInOut,
                        width: double.infinity,
                        height: _isInit
                            ? _isLogin
                                  ? 528.h
                                  : 602.h
                            : 0.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 24.h,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          color: surfaceColor().withValues(alpha: .08),
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                      ).fadeInUp(delay: Duration(milliseconds: 400)),
                      AnimatedContainer(
                        duration: Duration(seconds: 1),
                        curve: Curves.easeInOut,
                        width: double.infinity,
                        height: _isInit
                            ? _isLogin
                                  ? 518.h
                                  : 592.h
                            : 0.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 24.h,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: surfaceColor().withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                      ).fadeInUp(delay: Duration(milliseconds: 200)),
                      AnimatedContainer(
                        duration: Duration(seconds: 1),
                        curve: Curves.easeInOut,
                        width: double.infinity,
                        height: _isInit
                            ? _isLogin
                                  ? 508.h
                                  : 582.h
                            : 0.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 24.h,
                        ),
                        decoration: BoxDecoration(
                          color: surfaceColor(),
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NewsCoreIcon(
                              width: 24.r,
                              height: 24.r,
                              iconColor: AppColors.dynamic,
                              bgColor: Colors.transparent,
                              radius: 14.r,
                            ).jelloIn(
                              delay: Duration(seconds: 2, milliseconds: 200),
                            ),
                            SizedBox(height: 5.h),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: _isLogin ? "Login" : "Create Account",
                                style: TextStyles.bigTitleBold24(context),
                              ),
                            ),
                            SizedBox(height: 24.h),
                            Row(
                              spacing: 16.w,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: IconTextButton(
                                    onPressed: () {},
                                    height: 48,
                                    text: "Google",
                                    spacing: 10,
                                    color: AppColors.dynamic05,
                                    textColor: AppColors.dynamic,
                                    icon: AssetsSvgIcons.google,
                                    iconSize: 22,
                                  ),
                                ),
                                Expanded(
                                  child: IconTextButton(
                                    onPressed: () {},
                                    height: 48,
                                    text: "Facebook",
                                    spacing: 10,
                                    color: AppColors.dynamic05,
                                    textColor: AppColors.dynamic,
                                    icon: AssetsSvgIcons.facebook,
                                    iconSize: 22,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            InputTitle(
                              text: "User name",
                            ).fadeInLeft(delay: Duration(seconds: 3)),
                            TextInputField(
                              enabled: !loading,
                              errorBool: !_isFormValid && !_isUsernameValid,
                              controller: _usernameController,
                              hintText: 'Enter your user name',
                              textInputType: TextInputType.text,
                              onChanged: (value) => _validateForm(),
                            ).fadeInLeft(
                              delay: Duration(seconds: 3, milliseconds: 200),
                            ),
                            SizedBox(height: 20.h),
                            if (!_isLogin) ...[
                              InputTitle(text: "Email").fadeInLeft(
                                delay: Duration(seconds: 3, milliseconds: 400),
                              ),
                              TextInputField(
                                enabled: !loading,
                                errorBool: !_isFormValid && !_isEmailValid,
                                controller: _emailController,
                                hintText: 'Enter your email',
                                textInputType: TextInputType.emailAddress,
                                onChanged: (value) => _validateForm(),
                              ).fadeInLeft(
                                delay: Duration(seconds: 3, milliseconds: 600),
                              ),
                              SizedBox(height: 20.h),
                            ],
                            InputTitle(text: "Password").fadeInLeft(
                              delay: Duration(
                                seconds: 3,
                                milliseconds: _isLogin ? 400 : 800,
                              ),
                            ),
                            TextInputField(
                              enabled: !loading,
                              isPassword: true,
                              errorBool: !_isFormValid && !_isPassValid,
                              controller: _passwordController,
                              hintText: 'Enter your password',
                              textInputType: TextInputType.visiblePassword,
                              onChanged: (value) => _validateForm(),
                            ).fadeInLeft(
                              delay: Duration(
                                seconds: 3,
                                milliseconds: _isLogin ? 600 : 1000,
                              ),
                            ),
                            if (_isLogin) ...[
                              SizedBox(height: 4.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  RichText(
                                    textAlign: TextAlign.end,
                                    text: TextSpan(
                                      text: "Forgot Password?",
                                      style: TextStyles.normalMedium14(context),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            SizedBox(height: 40.h),
                            if (_isLogin)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (!loading)
                                    RichText(
                                      text: TextSpan(
                                        text: "Sign Up",
                                        style: TextStyles.bodyMedium16(context),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            setState(
                                              () => _isLogin = !_isLogin,
                                            );
                                          },
                                      ),
                                    ),
                                  Flexible(
                                    child: AnimatedContainer(
                                      duration: Duration(seconds: 1),
                                      curve: Curves.easeInOut,
                                      width: !loading ? 148.w : double.infinity,
                                      child:
                                          IconTextButton(
                                            height: 56,
                                            onPressed: _submit,
                                            text: "Login",
                                            buttonState: loading
                                                ? AppButtonState.loading
                                                : AppButtonState.idle,
                                            spacing: 10,
                                            color: _formValidation()
                                                ? AppColors.dynamic
                                                : AppColors.dynamic,
                                            textColor: AppColors.inverseDynamic,
                                            exchange: true,
                                            iconWidget: Icon(
                                              Icons.arrow_forward_rounded,
                                              color: AppColors.white,
                                              size: 20.sp,
                                            ),
                                          ).fadeInLeft(
                                            delay: Duration(
                                              seconds: 4,
                                              milliseconds: 100,
                                            ),
                                          ),
                                    ),
                                  ),
                                ],
                              )
                            else
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: AnimatedContainer(
                                      duration: Duration(seconds: 1),
                                      curve: Curves.easeInOut,
                                      width: !loading ? 148.w : double.infinity,
                                      child:
                                          IconTextButton(
                                            height: 56,
                                            onPressed: _submit,
                                            text: "Sign Up",
                                            buttonState: loading
                                                ? AppButtonState.loading
                                                : AppButtonState.idle,

                                            spacing: 10,
                                            color: _formValidation()
                                                ? AppColors.dynamic
                                                : AppColors.dynamic,
                                            textColor: AppColors.inverseDynamic,
                                            exchange: true,
                                            iconWidget: Icon(
                                              Icons.arrow_forward_rounded,
                                              color: AppColors.white,
                                              size: 20.sp,
                                            ),
                                          ).fadeInLeft(
                                            delay: Duration(
                                              seconds: 4,
                                              milliseconds: 100,
                                            ),
                                          ),
                                    ),
                                  ),
                                  if (!loading)
                                    RichText(
                                      text: TextSpan(
                                        text: "Login",
                                        style: TextStyles.bodyMedium16(context),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            setState(
                                              () => _isLogin = !_isLogin,
                                            );
                                          },
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ).fadeInUp(),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ],
          ),
        ),
      ),
    );
    /*return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          _loadingAuthState(context, state);
        } else if (state is AuthSuccessState) {
          _successAuthState(context, state);
        } else if (state is AuthFailureState) {
          _failedAuthState(context, state);
        }
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedContainer(
              duration: Duration(seconds: 3),
              curve: Curves.easeInOut,
              height: (_isInit
                  ? 170.h + MediaQuery.of(context).padding.top
                  : AppSize.height),
              decoration: BoxDecoration(
                color: AppColors.navyBlue,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(_isInit ? 32.r : 0.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isInit)
                    SizedBox(height: 4.h + MediaQuery.of(context).padding.top),
                  TweenAnimationBuilder<double>(
                    duration: Duration(seconds: 3),
                    curve: Curves.easeInOut,
                    tween: Tween(begin: 80.0, end: _isInit ? 64.0 : 80.0),
                    builder: (context, size, child) {
                      return TweenAnimationBuilder<double>(
                        duration: Duration(seconds: 3),
                        curve: Curves.easeInOut,
                        tween: Tween(begin: 14.0, end: _isInit ? 24.0 : 14.0),
                        builder: (context, radius, child) {
                          return ThessfordIcon(
                            width: size.r,
                            height: size.r,
                            iconColor: AppColors.white,
                            bgColor: AppColors.primary,
                            radius: radius.r,
                          );
                        },
                      );
                    },
                  ),
                  if (_isInit) ...[
                    SizedBox(height: 16.h),
                    RichText(
                      text: TextSpan(
                        text: "Admin Portal",
                        style: TextStyles.bodySemiBold16(
                          context,
                        ).copyWith(color: AppColors.white),
                      ),
                    ).fadeIn(delay: Duration(seconds: 2)),
                    SizedBox(height: 4.h).fadeIn(delay: Duration(seconds: 2)),
                    RichText(
                      text: TextSpan(
                        text: "Thessford Global Control Center",
                        style: TextStyles.bodyRegular16(
                          context,
                        ).copyWith(color: AppColors.white50),
                      ),
                    ).fadeIn(delay: Duration(seconds: 2)),
                  ],
                ],
              ),
            ),
            if (_isInit)
              Expanded(
                child: CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          SizedBox(height: 64.h),
                          InputTitle(
                            text: "Admin Email Address",
                          ).fadeInLeft(delay: Duration(seconds: 2)),
                          TextInputField(
                            enabled: !loading,
                            errorBool: !_isFormValid && !_isEmailValid,
                            controller: _emailController,
                            hintText: 'Enter your email',
                            textInputType: TextInputType.emailAddress,
                            onChanged: (value) => _validateForm(),
                          ).fadeInLeft(
                            delay: Duration(seconds: 2, milliseconds: 200),
                          ),
                          SizedBox(height: 16.h),
                          InputTitle(text: "Admin Password").fadeInLeft(
                            delay: Duration(seconds: 2, milliseconds: 400),
                          ),
                          TextInputField(
                            enabled: !loading,
                            isPassword: true,
                            errorBool: !_isFormValid && !_isPassValid,
                            controller: _passwordController,
                            hintText: 'Enter your password',
                            textInputType: TextInputType.visiblePassword,
                            onChanged: (value) => _validateForm(),
                          ).fadeInLeft(
                            delay: Duration(seconds: 2, milliseconds: 600),
                          ),
                          SizedBox(height: 32.h),
                        ]),
                      ),
                    ),
                    if (_isInit)
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        sliver: SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconTextButton(
                                onPressed: _submit,
                                text: "Access Admin Panel",
                                color: _formValidation()
                                    ? AppColors.primary
                                    : AppColors.dynamic10,
                                buttonState: loading
                                    ? AppButtonState.loading
                                    : AppButtonState.idle,
                              ).fadeInLeft(
                                delay: Duration(seconds: 2, milliseconds: 800),
                              ),
                              SizedBox(
                                height:
                                    20.h +
                                    MediaQuery.of(context).viewPadding.bottom,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );*/
  }
}
