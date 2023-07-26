part of 'news_bloc.dart';

@immutable
abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoadingState extends NewsState {}

class NewsLoadedState extends NewsState {
  final List<News> newsList;

  NewsLoadedState({required this.newsList});
}

class NewsErrorState extends NewsState {
  final String error;

  NewsErrorState(this.error);
}

class ShowManagementDialog extends NewsState {
  final String title;
  final DbOp op;
  final News? news;

  ShowManagementDialog({required this.title, required this.op, this.news});
}

class ShowDeleteConfimationDialog extends NewsState {
  final int id;
  final Function deleteFunc;
  final String type;

  ShowDeleteConfimationDialog({required this.id, required this.deleteFunc, this.type = 'News'});
}

class OpenWebViewPageState extends NewsState {
  final String url;

  OpenWebViewPageState(this.url);
}