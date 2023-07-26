part of 'return_book_bloc.dart';

@immutable
class ReturnBookState {
  final String note;
  final SubmitState state;

  const ReturnBookState({required this.state, this.note = ''});

  ReturnBookState copyWith({String? note, SubmitState? state}) =>
      ReturnBookState(state: state ?? this.state, note: note ?? this.note);
}
