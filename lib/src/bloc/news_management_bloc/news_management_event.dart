part of 'news_management_bloc.dart';

@immutable
abstract class NewsManagementEvent {}

class NewsTitleChangedEvent extends NewsManagementEvent {
  final String title;

  NewsTitleChangedEvent({required this.title});
}

class NewsUrlChangedEvent extends NewsManagementEvent {
  final String url;

  NewsUrlChangedEvent({required this.url});
}

class NewsSubmitEvent extends NewsManagementEvent {}