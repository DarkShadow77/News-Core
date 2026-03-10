import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../core/services/api_service.dart';
import '../models/news_article_model.dart';
import 'news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final ApiService _apiService = ApiService.instance!;

  @override
  Future<Either<String, List<NewsArticleModel>>> fetchTopHeadlines({
    String? category,
    String? country,
  }) async {
    try {
      final String apiKey = dotenv.env['NEWS_API_KEY'] ?? '';

      String endpoint =
          'top-headlines?apiKey=$apiKey&country=${country ?? 'us'}';

      if (category != null && category.toLowerCase() != 'all') {
        endpoint += '&category=${category.toLowerCase()}';
      }

      final response = await _apiService
          .getRequestHandler<List<NewsArticleModel>>(
            endpoint,
            transform: (data) {
              // NewsAPI returns articles in 'articles' field
              if (data is Map<String, dynamic> &&
                  data.containsKey('articles')) {
                final articles = data['articles'] as List<dynamic>;
                return articles
                    .map(
                      (article) => NewsArticleModel.fromJson(
                        article as Map<String, dynamic>,
                      ),
                    )
                    .where(
                      (article) => article.urlToImage != null,
                    ) // Filter out articles without images
                    .toList();
              }
              return [];
            },
          );

      if (response.responseSuccessful == true &&
          response.responseBody != null) {
        return Right(response.responseBody!);
      } else {
        return Left(response.responseMessage ?? 'Failed to fetch news');
      }
    } catch (e) {
      return Left('Error: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<NewsArticleModel>>> searchNews({
    required String query,
  }) async {
    try {
      final String apiKey = dotenv.env['NEWS_API_KEY'] ?? '';

      final String endpoint =
          'everything?q=$query&apiKey=$apiKey&sortBy=publishedAt';

      final response = await _apiService
          .getRequestHandler<List<NewsArticleModel>>(
            endpoint,
            transform: (data) {
              if (data is Map<String, dynamic> &&
                  data.containsKey('articles')) {
                final articles = data['articles'] as List<dynamic>;
                return articles
                    .map(
                      (article) => NewsArticleModel.fromJson(
                        article as Map<String, dynamic>,
                      ),
                    )
                    .where((article) => article.urlToImage != null)
                    .toList();
              }
              return [];
            },
          );

      if (response.responseSuccessful == true &&
          response.responseBody != null) {
        return Right(response.responseBody!);
      } else {
        return Left(response.responseMessage ?? 'Failed to search news');
      }
    } catch (e) {
      return Left('Error: ${e.toString()}');
    }
  }
}
