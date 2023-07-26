part of 'note_bloc.dart';

@immutable
abstract class NoteState {}

class NoteLoadingState extends NoteState {}

class NoteLoadedState extends NoteState {
  final List<LoanHistory> loanHistory;

  NoteLoadedState(this.loanHistory);
}

class ShowManagementDialogState extends NoteState {
  final String title;
  final DbOp op;
  final LoanHistory? note;

  ShowManagementDialogState({required this.title, required this.op, this.note});
}

class ShowDeleteDialogState extends NoteState {
  final String type;
  final int id;
  final Function func;

  ShowDeleteDialogState({this.type = 'Note', required this.id, required this.func});
}

class ShowReturnBookDialogState extends NoteState {
  final LoanHistory note;

  ShowReturnBookDialogState(this.note);
}

class ShowHistoryPageState extends NoteState {}
