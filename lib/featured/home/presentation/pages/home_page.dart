// lib/features/news/presentation/pages/news_home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_core/app/styles/text_styles.dart';
import 'package:news_core/app/view/widgets/buttons/theme_toggle.dart';
import 'package:news_core/app/view/widgets/input/search_text_input.dart';
import 'package:news_core/core/constants/app_assets.dart';
import 'package:news_core/core/constants/navigators/route_name.dart';
import 'package:news_core/core/services/hive_storage_service.dart';
import 'package:news_core/core/utils/helpers.dart';
import 'package:news_core/featured/auth/data/models/session_model.dart';
import 'package:news_core/featured/home/presentation/pages/news_details_page.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../manager/news_bloc.dart';
import '../widgets/carousel_news_item.dart';
import '../widgets/category_chip.dart';
import '../widgets/news_tile.dart';

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({super.key});

  @override
  State<NewsHomePage> createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final _pageController = PageController(viewportFraction: 1);

  double _currentPage = 0;
  int currentPage = 0;

  late SessionModel? userProfile;

  final List<String> categories = [
    'All',
    'Business',
    'Entertainment',
    'Health',
    'Science',
    'Sports',
    'Technology',
  ];

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
    userProfile = HiveStorageService().getSession();
    context.read<NewsBloc>().add(const FetchTopHeadlinesEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() => _isSearching = true);
      context.read<NewsBloc>().add(SearchNewsEvent(query));
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _isSearching = false);
    context.read<NewsBloc>().add(const FetchTopHeadlinesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        userProfile = state.session;
        return Scaffold(
          backgroundColor: surfaceColor(),
          extendBody: true,
          body: SafeArea(
            bottom: false,
            child: BlocConsumer<NewsBloc, NewsState>(
              listener: (context, state) {
                if (state is NewsFailureState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is NewsLoadingState;
                final selectedCategory = context
                    .read<NewsBloc>()
                    .selectedCategory;

                return CustomScrollView(
                  slivers: [
                    // App Bar
                    SliverAppBar(
                      floating: true,
                      backgroundColor: surfaceColor(),
                      elevation: 0,
                      title: Row(
                        spacing: 16.w,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 32.r,
                            height: 32.r,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: AppColors.dynamic10,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Image.asset(
                                AssetsPngImages.profilePic,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: 'Hi, ',
                                style: TextStyles.bigTitleBold24(context),
                                children: [
                                  TextSpan(
                                    text: userProfile?.username ?? "Guest",
                                    style: TextStyles.bigTitleBold24(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            spacing: 12.w,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ThemeToggle(),
                              SizedBox(
                                width: 24.w,
                                height: 24.h,
                                child: Stack(
                                  children: [
                                    SvgPicture.asset(
                                      AssetsSvgIcons.notification,
                                      width: 24.w,
                                      height: 24.h,
                                      fit: BoxFit.contain,
                                      colorFilter: ColorFilter.mode(
                                        AppColors.dynamic,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    Positioned(
                                      top: 5.h,
                                      right: 2.w,
                                      child: Container(
                                        width: 6.r,
                                        height: 6.r,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Top Headlines Carousel (hide when searching)
                    if (!_isSearching && state.topHeadlines.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12.h),
                            // PageView of cards
                            SizedBox(
                              height: 250.h,
                              child: Center(
                                child: PageView.builder(
                                  padEnds: true,
                                  controller: _pageController,
                                  physics: BouncingScrollPhysics(),
                                  allowImplicitScrolling: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: state.topHeadlines.length,
                                  onPageChanged: (index) {
                                    setState(() {
                                      currentPage = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    double scaleFactor = .8;
                                    double height = 230.h;
                                    Matrix4 matrix = Matrix4.identity();

                                    if (index == _currentPage.floor()) {
                                      var currScale =
                                          1 -
                                          (_currentPage - index) *
                                              (1 - scaleFactor);
                                      var currTrans =
                                          height * (1 - currScale) / 2;
                                      matrix = Matrix4.diagonal3Values(
                                        1.0,
                                        currScale,
                                        1.0,
                                      )..setTranslationRaw(0, currTrans, 0);
                                    } else if (index ==
                                        _currentPage.floor() + 1) {
                                      var currScale =
                                          scaleFactor +
                                          (_currentPage - index + 1) *
                                              (1 - scaleFactor);

                                      var currTrans =
                                          height * (1 - currScale) / 2;
                                      matrix = Matrix4.diagonal3Values(
                                        1.0,
                                        currScale,
                                        1.0,
                                      )..setTranslationRaw(0, currTrans, 0);
                                    } else if (index ==
                                        _currentPage.floor() - 1) {
                                      var currScale =
                                          1 -
                                          (_currentPage - index) *
                                              (1 - scaleFactor);
                                      var currTrans =
                                          height * (1 - currScale) / 2;
                                      matrix = Matrix4.diagonal3Values(
                                        1.0,
                                        currScale,
                                        1.0,
                                      )..setTranslationRaw(0, currTrans, 0);
                                    } else {
                                      var currScale = .8;
                                      matrix =
                                          Matrix4.diagonal3Values(
                                            1.0,
                                            currScale,
                                            1.0,
                                          )..setTranslationRaw(
                                            0,
                                            height * (1 - scaleFactor) / 2,
                                            0,
                                          );
                                    }

                                    final article = state.topHeadlines[index];

                                    return Transform(
                                      transform: matrix,
                                      child: CarouselNewsItem(
                                        article: article,
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            RouteName.newsDetailsPage,
                                            arguments: NewsDetailPageParam(
                                              article: article,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            // Page Indicator
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List.generate(
                                state.topHeadlines.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    _pageController.animateToPage(
                                      index,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                    ),
                                    width: index == currentPage ? 24.w : 8.w,
                                    height: 8.h,
                                    decoration: BoxDecoration(
                                      color: index == currentPage
                                          ? AppColors.primary
                                          : AppColors.primary15,
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Search Bar
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 32.h,
                        ),
                        child: SearchTextInput(
                          controller: _searchController,
                          hintText: "Trending, Sport, etc",
                          onChanged: (value) {
                            setState(() {});
                          },
                          onSubmitted: (_) => _onSearch(),
                          // prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: _clearSearch,
                                )
                              : null,
                        ),
                      ),
                    ),
                    // Category Chips (hide when searching)
                    if (!_isSearching)
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 40.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              final isSelected = selectedCategory == category;
                              return CategoryChip(
                                label: category,
                                isSelected: isSelected,
                                onTap: () {
                                  context.read<NewsBloc>().add(
                                    ChangeNewsCategoryEvent(category),
                                  );
                                },
                              );
                            },
                            separatorBuilder: (_, _) => SizedBox(width: 12.w),
                          ),
                        ),
                      ),

                    SliverToBoxAdapter(child: SizedBox(height: 32.h)),

                    // Loading Indicator
                    if (isLoading)
                      SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(),
                              SizedBox(height: 16.h),
                              Text(
                                'Loading news...',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    // News List
                    else
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final articles = _isSearching
                                  ? state.searchResults
                                  : state.categoryNews;

                              if (articles.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(32.w),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.search_off,
                                          size: 64.sp,
                                          color: Colors.grey[400],
                                        ),
                                        SizedBox(height: 16.h),
                                        Text(
                                          _isSearching
                                              ? 'No results found'
                                              : 'No news available',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              final article = articles[index];

                              return NewsTile(
                                article: article,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    RouteName.newsDetailsPage,
                                    arguments: NewsDetailPageParam(
                                      article: article,
                                    ),
                                  );
                                },
                              );
                            },
                            childCount: _isSearching
                                ? (state.searchResults.isEmpty
                                      ? 1
                                      : state.searchResults.length)
                                : (state.categoryNews.isEmpty
                                      ? 1
                                      : state.categoryNews.length),
                          ),
                        ),
                      ),

                    SliverToBoxAdapter(child: SizedBox(height: 40.h)),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
