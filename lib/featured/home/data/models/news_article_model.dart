// lib/features/news/data/models/news_article_model.dart
import 'package:equatable/equatable.dart';

class NewsArticleModel extends Equatable {
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final String publishedAt;
  final String? content;
  final NewsSourceModel source;

  const NewsArticleModel({
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.content,
    required this.source,
  });

  factory NewsArticleModel.fromJson(Map<String, dynamic> json) {
    return NewsArticleModel(
      author: json['author'] as String?,
      title: json['title'] as String? ?? 'No Title',
      description: json['description'] as String?,
      url: json['url'] as String? ?? '',
      urlToImage: json['urlToImage'] as String?,
      publishedAt:
          json['publishedAt'] as String? ?? DateTime.now().toIso8601String(),
      content: json['content'] as String?,
      source: NewsSourceModel.fromJson(json['source'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
      'source': source.toJson(),
    };
  }

  @override
  List<Object?> get props => [
    author,
    title,
    description,
    url,
    urlToImage,
    publishedAt,
    content,
    source,
  ];
}

class NewsSourceModel extends Equatable {
  final String? id;
  final String name;

  const NewsSourceModel({this.id, required this.name});

  factory NewsSourceModel.fromJson(Map<String, dynamic> json) {
    return NewsSourceModel(
      id: json['id'] as String?,
      name: json['name'] as String? ?? 'Unknown Source',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  @override
  List<Object?> get props => [id, name];
}
