part of 'news_bloc.dart';

enum NewsType { fetchTopNews, searchNews }

@immutable
class NewsState {
  final List<NewsArticleModel> topHeadlines;
  final List<NewsArticleModel> categoryNews;
  final List<NewsArticleModel> searchResults;

  const NewsState({
    required this.topHeadlines,
    required this.categoryNews,
    required this.searchResults,
  });

  NewsState copyWith({
    List<NewsArticleModel>? topHeadlines,
    List<NewsArticleModel>? categoryNews,
    List<NewsArticleModel>? searchResults,
  }) {
    return NewsState(
      topHeadlines: topHeadlines ?? this.topHeadlines,
      categoryNews: categoryNews ?? this.categoryNews,
      searchResults: searchResults ?? this.searchResults,
    );
  }
}

class NewsInitialState extends NewsState {
  const NewsInitialState({
    required super.topHeadlines,
    required super.categoryNews,
    required super.searchResults,
  });
}

class NewsLoadingState extends NewsState {
  final NewsType type;
  const NewsLoadingState({
    required this.type,
    required super.topHeadlines,
    required super.categoryNews,
    required super.searchResults,
  });
}

class NewsFailureState extends NewsState {
  final String message;
  final NewsType type;
  const NewsFailureState({
    required this.message,
    required this.type,
    required super.topHeadlines,
    required super.categoryNews,
    required super.searchResults,
  });
}

class NewsSuccessState extends NewsState {
  final String message;
  final NewsType type;
  const NewsSuccessState({
    required this.message,
    required this.type,
    required super.topHeadlines,
    required super.categoryNews,
    required super.searchResults,
  });
}
