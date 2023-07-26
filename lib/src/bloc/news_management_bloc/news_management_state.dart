part of 'news_management_bloc.dart';

@immutable
class NewsManagementState {
  final String title;
  final String url;
  final SubmitState submitState;

  const NewsManagementState(
      {this.title = '', this.url = '', this.submitState = SubmitState.idle});

  NewsManagementState copyWith({String? title, String? url, SubmitState? submitState}) {
    return NewsManagementState(
        title: title ?? this.title,
        url: url ?? this.url,
        submitState: submitState ?? this.submitState);
  }

  String? isTitleValid() => title.isNotEmpty ? null : 'Please enter title';

  String? isUrlValid() => (RegExp(r'^(https://)(www.)?[a-z0-9]+\.[a-z]+(/[a-zA-Z0-9#]+/?)*$').hasMatch(url)) ? null : 'Invalid url';
}
