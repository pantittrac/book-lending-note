part of 'book_management_bloc.dart';

@immutable
abstract class BookManagementEvent {}

class BookIsbnChangedEvent extends BookManagementEvent {
  final String isbn;

  BookIsbnChangedEvent({required this.isbn});
}

class BookNameChangedEvent extends BookManagementEvent {
  final String name;

  BookNameChangedEvent({required this.name});
}

class BookVolChangedEvent extends BookManagementEvent {
  final String vol;

  BookVolChangedEvent({required this.vol});
}

class BookSubmitEvent extends BookManagementEvent {}

class BackFromErrorDialogEvent extends BookManagementEvent {}