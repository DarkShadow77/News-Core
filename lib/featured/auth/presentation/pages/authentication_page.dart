import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_core/core/constants/app_assets.dart';
import 'package:news_core/core/utils/helpers.dart';
import 'package:news_core/featured/dashboard/presentation/pages/dashboard_page.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/input/text_input_field.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../app/view/widgets/buttons/icon_text_button.dart';
import '../../../../app/view/widgets/input/input_title.dart';
import '../../../../app/view/widgets/news_core_icon.dart';
import '../../../../core/constants/enums/app_enum.dart';
import '../../../../core/constants/navigators/route_name.dart';
import '../../../../core/utils/ui_tool_mix.dart';
import '../bloc/auth_bloc.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>
    with UIToolMixin, TickerProviderStateMixin {
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
  bool _hasAnimatedOnce = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _isInit = true);
      }
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
      if (_isLogin) {
        context.read<AuthBloc>().add(
          LoginEvent(
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ),
        );
      } else {
        context.read<AuthBloc>().add(
          SignUpEvent(
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ),
        );
      }
    }
  }

  Widget _buildBackgroundLayer(
    double height,
    double margin,
    double alpha,
    int delayMs,
  ) {
    // After first animation, just show the container without animation
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      margin: EdgeInsets.symmetric(horizontal: margin),
      decoration: BoxDecoration(
        color: surfaceColor().withValues(alpha: alpha),
        borderRadius: BorderRadius.circular(40.r),
      ),
    ).fadeInUp(
      curve: Curves.easeInOut,
      delay: Duration(milliseconds: delayMs),
      duration: Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          if (_isLogin) {
            // Navigate to home screen
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteName.dashboardPage,
              arguments: DashboardPageParam(index: 0),
              (route) => false,
            );
          } else {
            // Navigate to Sign Up Success
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteName.successfulPage,
              (route) => false,
            );
          }
        } else if (state.status == AuthStatus.error) {
          setState(() => loading = false);
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'An error occurred')),
          );
        } else if (state.status == AuthStatus.loading) {
          setState(() => loading = true);
        } else {
          setState(() => loading = false);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 47.h + MediaQuery.of(context).padding.top),
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
                  SizedBox(height: 10.h),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "News Core",
                      style: TextStyles.bigTitleMedium24(
                        context,
                      ).copyWith(fontSize: 28.sp, color: AppColors.white),
                    ),
                  ),
                ],
              ).slideUp(from: 270.h),
              if (_isInit) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // Background layer 1
                          _buildBackgroundLayer(
                            _isLogin ? 500.h : 572.h,
                            20.w,
                            .1,
                            800,
                          ),
                          // Background layer 2
                          _buildBackgroundLayer(
                            _isLogin ? 490.h : 562.h,
                            10.w,
                            .15,
                            600,
                          ),
                          // Main content container
                          AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            width: double.infinity,
                            height: _isLogin ? 480.h : 552.h,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 20.h,
                            ),
                            decoration: BoxDecoration(
                              color: surfaceColor(),
                              borderRadius: BorderRadius.circular(40.r),
                            ),
                            child: _buildFormContent(),
                          ).fadeInUp(
                            curve: Curves.easeInOut,
                            delay: Duration(milliseconds: 400),
                            duration: Duration(milliseconds: 400),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h + MediaQuery.of(context).viewPadding.bottom,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_hasAnimatedOnce)
            JelloIn(
              delay: Duration(milliseconds: 800),
              controller: (controller) {
                controller.forward().then((_) {
                  if (mounted) {
                    setState(() => _hasAnimatedOnce = true);
                  }
                });
              },
              child: NewsCoreIcon(
                width: 24.r,
                height: 24.r,
                iconColor: AppColors.dynamic,
                bgColor: Colors.transparent,
                radius: 14.r,
              ),
            )
          else
            NewsCoreIcon(
              width: 24.r,
              height: 24.r,
              iconColor: AppColors.dynamic,
              bgColor: Colors.transparent,
              radius: 14.r,
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
          InputTitle(text: "User name"),
          TextInputField(
            enabled: !loading,
            errorBool: !_isFormValid && !_isUsernameValid,
            controller: _usernameController,
            hintText: 'Enter your user name',
            textInputType: TextInputType.text,
            onChanged: (value) => _validateForm(),
          ),
          SizedBox(height: 20.h),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: !_isLogin
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputTitle(text: "Email"),
                      TextInputField(
                        enabled: !loading,
                        errorBool: !_isFormValid && !_isEmailValid,
                        controller: _emailController,
                        hintText: 'Enter your email',
                        textInputType: TextInputType.emailAddress,
                        onChanged: (value) => _validateForm(),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  )
                : SizedBox.shrink(),
          ),
          InputTitle(text: "Password"),
          TextInputField(
            enabled: !loading,
            isPassword: true,
            errorBool: !_isFormValid && !_isPassValid,
            controller: _passwordController,
            hintText: 'Enter your password',
            textInputType: TextInputType.visiblePassword,
            onChanged: (value) => _validateForm(),
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
          SizedBox(height: 35.h),
          if (_isLogin)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!loading)
                  RichText(
                    text: TextSpan(
                      text: "Sign Up",
                      style: TextStyles.bodyMedium16(context),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(() => _isLogin = !_isLogin);
                        },
                    ),
                  ),
                Flexible(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: !loading ? 148.w : double.infinity,
                    child: IconTextButton(
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
                    ),
                  ),
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: !loading ? 148.w : double.infinity,
                    child: IconTextButton(
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
                          setState(() => _isLogin = !_isLogin);
                        },
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
