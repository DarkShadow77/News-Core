import 'package:dartz/dartz.dart';

import '../models/news_article_model.dart';

abstract class NewsRepository {
  Future<Either<String, List<NewsArticleModel>>> fetchTopHeadlines({
    String? category,
    String? country,
  });

  Future<Either<String, List<NewsArticleModel>>> searchNews({
    required String query,
  });
}
