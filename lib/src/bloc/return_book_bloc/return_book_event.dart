part of 'return_book_bloc.dart';

@immutable
abstract class ReturnBookEvent {}

class NoteChangeEvent extends ReturnBookEvent {
  final String note;

  NoteChangeEvent(this.note);
}

class SubmitEvent extends ReturnBookEvent {}

class BackFromErrorDialogEvent  extends ReturnBookEvent {}