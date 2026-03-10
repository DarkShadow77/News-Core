// lib/features/news/presentation/widgets/category_chip.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_core/app/styles/text_styles.dart';

import '../../../../core/constants/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.dynamic05,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: RichText(
          text: TextSpan(
            text: label,
            style: TextStyles.normalMedium14(context).copyWith(
              color: isSelected ? AppColors.white : AppColors.dynamic70,
            ),
          ),
        ),
      ),
    );
  }
}
