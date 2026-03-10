// lib/features/news/presentation/widgets/news_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../app/styles/text_styles.dart';
import '../../../../app/view/widgets/cached_image_widget.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/news_article_model.dart';

class NewsTile extends StatelessWidget {
  final NewsArticleModel article;
  final VoidCallback onTap;

  const NewsTile({super.key, required this.article, required this.onTap});

  String _getCategoryFromSource(String source) {
    // Map sources to categories (simplified)
    if (source.toLowerCase().contains('sport')) return 'Sports';
    if (source.toLowerCase().contains('tech')) return 'Technology';
    if (source.toLowerCase().contains('business')) return 'Business';
    return 'General';
  }

  @override
  Widget build(BuildContext context) {
    final category = _getCategoryFromSource(article.source.name);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        child: Column(
          spacing: 8.h,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 170.h,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image
                  if (article.urlToImage != null)
                    CachedImageSize(
                      imageUrl: article.urlToImage!,
                      width: double.infinity,
                      height: 170,
                      fit: BoxFit.cover,
                      color: AppColors.dynamic10,
                      borderRadius: 18,
                    )
                  else
                    Container(
                      height: 170.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.dynamic10,
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image,
                          size: 50,
                          color: AppColors.dynamic,
                        ),
                      ),
                    ),

                  // Content
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(
                          category,
                        ).withValues(alpha: .3),
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: category.capitalize,
                          style: TextStyles.smallMedium12(
                            context,
                          ).copyWith(color: AppColors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              spacing: 10.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: article.title,
                      style: TextStyles.bodyBold16(context),
                    ),
                  ),
                ),
                Column(
                  spacing: 3.h,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 24.r,
                      height: 24.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.dynamic,
                      ),
                      child: Center(
                        child: Transform.rotate(
                          angle: 49.5,
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 18.sp,
                            color: AppColors.inverseDynamic,
                          ),
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: timeago.format(
                          DateTime.parse(article.publishedAt),
                        ),
                        style: TextStyles.smallRegular12(context, opacity: .4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'sports':
        return Colors.green;
      case 'politics':
        return Colors.blue;
      case 'entertainment':
        return Colors.purple;
      case 'technology':
        return Colors.orange;
      case 'business':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
