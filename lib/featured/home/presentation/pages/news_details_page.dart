// lib/features/news/presentation/pages/news_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:news_core/app/view/widgets/cached_image_widget.dart';
import 'package:news_core/core/utils/helpers.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../app/styles/text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/news_article_model.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsDetailPageParam param;

  const NewsDetailPage({super.key, required this.param});

  String _formatTime(String publishedAt) {
    final dateTime = DateTime.parse(publishedAt);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inHours < 1) {
      return timeago.format(dateTime);
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(dateTime);
    } else {
      return DateFormat('d/M/yyyy').format(dateTime);
    }
  }

  NewsArticleModel get article => param.article;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300.h,
            pinned: true,
            automaticallyImplyLeading: false,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 32.r,
                    height: 32.r,
                    decoration: BoxDecoration(
                      color: AppColors.dynamic,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18.sp,
                        color: AppColors.inverseDynamic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: article.urlToImage != null
                  ? CachedImageSize(
                      imageUrl: article.urlToImage!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      color: AppColors.dynamic10,
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 100),
                    ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Container(
              color: surfaceColor(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 20.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title
                        RichText(
                          text: TextSpan(
                            text: article.title,
                            style: TextStyles.bigTitleBold24(context),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Time and Reporter Row
                        Row(
                          spacing: 16.w,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                spacing: 4.w,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 16.sp,
                                    color: Colors.grey[600],
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: _formatTime(article.publishedAt),
                                      style: TextStyles.smallMedium12(
                                        context,
                                        opacity: .5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: "Reporter: ",
                                      style: TextStyles.smallRegular12(
                                        context,
                                        opacity: .5,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: RichText(
                                      maxLines: 1,
                                      textAlign: TextAlign.end,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        text:
                                            article.author ??
                                            article.source.name,
                                        style: TextStyles.smallMedium12(
                                          context,
                                          opacity: .5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),

                        // Divider
                        Divider(color: AppColors.dynamic10),
                        SizedBox(height: 16.h),

                        // Content/Description
                        if (article.description != null) ...[
                          RichText(
                            text: TextSpan(
                              text: article.description!,
                              style: TextStyles.normalMedium14(
                                context,
                                opacity: .75,
                              ).copyWith(height: 1.6.sp),
                            ),
                          ),

                          SizedBox(height: 24.h),
                        ],

                        // Main Content
                        if (article.content != null) ...[
                          RichText(
                            text: TextSpan(
                              text: article.content!,
                              style: TextStyles.normalMedium14(
                                context,
                                opacity: .75,
                              ).copyWith(height: 1.6.sp),
                            ),
                          ),

                          SizedBox(height: 24.h),
                        ],

                        // Source
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: AppColors.dynamic075,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.source,
                                size: 20.sp,
                                color: AppColors.dynamic70,
                              ),
                              SizedBox(width: 8.w),
                              RichText(
                                text: TextSpan(
                                  text: 'Source: ',
                                  style: TextStyles.normalRegular14(
                                    context,
                                    opacity: .5,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: article.source.name,
                                    style: TextStyles.normalSemibold14(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height:
                              60.h + MediaQuery.of(context).viewPadding.bottom,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewsDetailPageParam {
  final NewsArticleModel article;

  NewsDetailPageParam({required this.article});
}
