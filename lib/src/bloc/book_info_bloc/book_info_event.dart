part of 'book_info_bloc.dart';

@immutable
abstract class BookInfoEvent {}

class LoadBookNameEvent extends BookInfoEvent {}

class LoadBookVolEvent extends BookInfoEvent {
  final String bookName;

  LoadBookVolEvent(this.bookName);
}
