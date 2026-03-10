// lib/features/profile/presentation/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_core/app/styles/text_styles.dart';
import 'package:news_core/app/theme/bloc/theme_bloc.dart';
import 'package:news_core/app/view/widgets/buttons/theme_toggle.dart';
import 'package:news_core/core/constants/app_colors.dart';
import 'package:news_core/core/constants/navigators/route_name.dart';
import 'package:news_core/core/services/hive_storage_service.dart';
import 'package:news_core/core/utils/helpers.dart';
import 'package:news_core/featured/auth/data/models/session_model.dart';
import 'package:news_core/featured/auth/presentation/bloc/auth_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  SessionModel? userProfile;

  @override
  void initState() {
    super.initState();
    userProfile = HiveStorageService().getSession();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: surfaceColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text('Logout', style: TextStyles.bigTitleBold24(context)),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyles.bodyRegular16(context),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyles.bodyMedium16(
                  context,
                ).copyWith(color: AppColors.dynamic60),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<AuthBloc>().add(LogoutEvent());
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteName.authenticationPage,
                  (route) => false,
                );
              },
              child: Text(
                'Logout',
                style: TextStyles.bodyBold16(
                  context,
                ).copyWith(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        userProfile = state.session;
        return Scaffold(
          backgroundColor: surfaceColor(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20.h),

                  // Profile Header
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        // Profile Picture
                        Container(
                          width: 100.r,
                          height: 100.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primary.withValues(alpha: 0.7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: _buildDefaultAvatar(),
                        ),
                        SizedBox(height: 16.h),

                        // Username
                        Text(
                          userProfile?.username ?? 'Guest User',
                          style: TextStyles.bigTitleBold24(context),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4.h),

                        // Email
                        Text(
                          userProfile?.email ?? 'guest@email.com',
                          style: TextStyles.bodyRegular16(
                            context,
                          ).copyWith(color: AppColors.dynamic60),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),

                        // Edit Profile Button
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary10,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 16.sp,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                'Edit Profile',
                                style: TextStyles.normalMedium14(
                                  context,
                                ).copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Theme Toggle Section
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppColors.dynamic05,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: BlocBuilder<ThemeBloc, ThemeMode>(
                      builder: (context, themeMode) {
                        return Row(
                          children: [
                            ThemeToggle(),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Theme',
                                    style: TextStyles.bodyBold16(context),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    isDark() ? 'Dark Mode' : 'Light Mode',
                                    style: TextStyles.normalRegular14(
                                      context,
                                    ).copyWith(color: AppColors.dynamic60),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: isDark(),
                              onChanged: (value) {
                                context.read<ThemeBloc>().add(
                                  ThemeChanged(!isDark()),
                                );
                              },
                              activeThumbColor: AppColors.primary,
                              activeTrackColor: AppColors.primary35,
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Menu Items
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          icon: Icons.settings_outlined,
                          iconColor: AppColors.primary,
                          iconBgColor: AppColors.primary10,
                          title: 'Settings',
                          subtitle: 'App preferences and configurations',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Settings coming soon!'),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 12.h),

                        _buildMenuItem(
                          icon: Icons.info_outline,
                          iconColor: AppColors.orange,
                          iconBgColor: AppColors.orange.withValues(alpha: 0.1),
                          title: 'About Us',
                          subtitle: 'Learn more about News Core',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('About Us coming soon!'),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 12.h),

                        _buildMenuItem(
                          icon: Icons.help_outline,
                          iconColor: AppColors.green,
                          iconBgColor: AppColors.green.withValues(alpha: 0.1),
                          title: 'Help & Support',
                          subtitle: 'Get help and contact us',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Help & Support coming soon!'),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 12.h),

                        _buildMenuItem(
                          icon: Icons.privacy_tip_outlined,
                          iconColor: AppColors.error,
                          iconBgColor: AppColors.error11,
                          title: 'Privacy Policy',
                          subtitle: 'Read our privacy policy',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Privacy Policy coming soon!'),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Logout Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: GestureDetector(
                      onTap: _showLogoutDialog,
                      child: Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48.r,
                              height: 48.r,
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.logout_rounded,
                                color: AppColors.error,
                                size: 24.sp,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Logout',
                                    style: TextStyles.bodyBold16(
                                      context,
                                    ).copyWith(color: AppColors.error),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    'Sign out of your account',
                                    style: TextStyles.normalRegular14(
                                      context,
                                    ).copyWith(color: AppColors.dynamic60),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16.sp,
                              color: AppColors.error,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // App Version
                  Text(
                    'Version 1.0.0',
                    style: TextStyles.smallRegular12(
                      context,
                    ).copyWith(color: AppColors.dynamic40),
                  ),

                  SizedBox(
                    height: 100.h + MediaQuery.of(context).viewPadding.bottom,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefaultAvatar() {
    return Center(
      child: Text(
        userProfile?.username.substring(0, 1).toUpperCase() ?? 'G',
        style: TextStyle(
          fontSize: 40.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.dynamic05,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: iconColor, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyles.bodyBold16(context)),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyles.normalRegular14(
                      context,
                    ).copyWith(color: AppColors.dynamic60),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: AppColors.dynamic40,
            ),
          ],
        ),
      ),
    );
  }
}
