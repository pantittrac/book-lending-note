part of 'note_bloc.dart';

@immutable
abstract class NoteEvent {}

class LoadNoteEvent extends NoteEvent {}

class RefreshNoteEvent extends NoteEvent {
  final bool isRefresh;

  RefreshNoteEvent(this.isRefresh);
}

class AddNoteEvent extends NoteEvent {}

class EditNoteEvent extends NoteEvent {
  final int index;

  EditNoteEvent(this.index);
}

class DeleteNoteEvent extends NoteEvent {
  final int index;

  DeleteNoteEvent(this.index);
}

class ReturnBookEvent extends NoteEvent {
  final int index;

  ReturnBookEvent(this.index);
}

class ShowHistoryEvent extends NoteEvent {}
