part of 'news_bloc.dart';

@immutable
abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class FetchTopHeadlinesEvent extends NewsEvent {
  final String? category;

  const FetchTopHeadlinesEvent({this.category});

  @override
  List<Object?> get props => [category];
}

class SearchNewsEvent extends NewsEvent {
  final String query;

  const SearchNewsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ChangeNewsCategoryEvent extends NewsEvent {
  final String category;

  const ChangeNewsCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}
