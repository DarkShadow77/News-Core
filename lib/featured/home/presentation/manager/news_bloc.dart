import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/models/news_article_model.dart';
import '../../data/repository/news_repository.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository repository;
  String selectedCategory = 'All';

  NewsBloc({required this.repository})
    : super(
        const NewsInitialState(
          topHeadlines: [],
          categoryNews: [],
          searchResults: [],
        ),
      ) {
    on<FetchTopHeadlinesEvent>(_onFetchTopHeadlines);
    on<SearchNewsEvent>(_onSearchNews);
    on<ChangeNewsCategoryEvent>(_onChangeCategory);
  }

  Future<void> _onFetchTopHeadlines(
    FetchTopHeadlinesEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(
      NewsLoadingState(
        type: NewsType.fetchTopNews,
        topHeadlines: state.topHeadlines,
        categoryNews: state.categoryNews,
        searchResults: state.searchResults,
      ),
    );

    final result = await repository.fetchTopHeadlines(category: event.category);

    result.fold(
      (error) => emit(
        NewsFailureState(
          message: error,
          type: NewsType.fetchTopNews,
          topHeadlines: state.topHeadlines,
          categoryNews: state.categoryNews,
          searchResults: state.searchResults,
        ),
      ),
      (articles) {
        if (event.category == null || event.category == 'All') {
          // Top headlines for carousel + all news
          emit(
            state.copyWith(
              topHeadlines: articles.take(5).toList(),
              categoryNews: articles,
            ),
          );
          emit(
            NewsSuccessState(
              message: 'Top headlines fetched successfully',
              type: NewsType.fetchTopNews,
              topHeadlines: articles.take(5).toList(),
              categoryNews: articles,
              searchResults: state.searchResults,
            ),
          );
        } else {
          // Category-specific news
          emit(state.copyWith(categoryNews: articles));
          emit(
            NewsSuccessState(
              message: 'News fetched successfully',
              type: NewsType.fetchTopNews,
              topHeadlines: state.topHeadlines,
              categoryNews: articles,
              searchResults: state.searchResults,
            ),
          );
        }
      },
    );
  }

  Future<void> _onSearchNews(
    SearchNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(
      NewsLoadingState(
        type: NewsType.searchNews,
        topHeadlines: state.topHeadlines,
        categoryNews: state.categoryNews,
        searchResults: state.searchResults,
      ),
    );

    final result = await repository.searchNews(query: event.query);

    result.fold(
      (error) => emit(
        NewsFailureState(
          message: error,
          type: NewsType.searchNews,
          topHeadlines: state.topHeadlines,
          categoryNews: state.categoryNews,
          searchResults: state.searchResults,
        ),
      ),
      (articles) {
        emit(state.copyWith(searchResults: articles));
        emit(
          NewsSuccessState(
            message: 'Search completed successfully',
            type: NewsType.searchNews,
            topHeadlines: state.topHeadlines,
            categoryNews: state.categoryNews,
            searchResults: articles,
          ),
        );
      },
    );
  }

  Future<void> _onChangeCategory(
    ChangeNewsCategoryEvent event,
    Emitter<NewsState> emit,
  ) async {
    selectedCategory = event.category;

    emit(
      NewsLoadingState(
        type: NewsType.fetchTopNews,
        topHeadlines: state.topHeadlines,
        categoryNews: state.categoryNews,
        searchResults: state.searchResults,
      ),
    );

    add(FetchTopHeadlinesEvent(category: event.category));
  }
}
