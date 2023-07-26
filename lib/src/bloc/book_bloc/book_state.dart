part of 'book_bloc.dart';

@immutable
abstract class BookState {}

class BookLoadingState extends BookState {}

class BookLoadedState extends BookState {
  final List<BookStatus> books;

  BookLoadedState(this.books);
}

class ShowManagementDialogState extends BookState {
  final String title;
  final DbOp op;

  ShowManagementDialogState({required this.title, required this.op});
}

class ShowDeleteDialogState extends BookState {
  final String type;
  final String isbn;
  final Function func;

  ShowDeleteDialogState({required this.type, required this.isbn, required this.func});
}
