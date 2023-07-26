part of 'news_bloc.dart';

@immutable
abstract class NewsEvent {}

class LoadNewsEvent extends NewsEvent {}

class AddNewsEvent extends NewsEvent {}

class EditNewsEvent extends NewsEvent {
  final int index;

  EditNewsEvent(this.index);
}

class DeleteNewsEvent extends NewsEvent {
  final int index;

  DeleteNewsEvent(this.index);
}

class RefreshNewsEvent extends NewsEvent {
  final bool isRefresh;

  RefreshNewsEvent(this.isRefresh);
}

class OpenWebViewPageEvent extends NewsEvent {
  final int index;

  OpenWebViewPageEvent(this.index);
}
