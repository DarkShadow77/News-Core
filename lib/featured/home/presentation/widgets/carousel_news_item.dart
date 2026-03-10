// lib/features/news/presentation/widgets/carousel_news_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_core/app/styles/text_styles.dart';
import 'package:news_core/app/view/widgets/cached_image_widget.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/news_article_model.dart';

class CarouselNewsItem extends StatelessWidget {
  final NewsArticleModel article;
  final VoidCallback onTap;

  const CarouselNewsItem({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
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
                        color: AppColors.white20,
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: '🔥 Hot News',
                          style: TextStyles.smallMedium12(
                            context,
                          ).copyWith(color: AppColors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: article.title,
                style: TextStyles.bigTitleBold24(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
