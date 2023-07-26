part of 'book_bloc.dart';

@immutable
abstract class BookEvent {}

class LoadBookEvent extends BookEvent {}

class RefreshBookEvent extends BookEvent {
  final bool isRefresh;

  RefreshBookEvent(this.isRefresh);
}

class AddBookEvent extends BookEvent {}

class DeleteBookEvent extends BookEvent {
  final String isbn;

  DeleteBookEvent(this.isbn);
}

class SearchBookEvent extends BookEvent {
  final String search;

  SearchBookEvent(this.search);
}
