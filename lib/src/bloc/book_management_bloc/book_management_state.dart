part of 'book_management_bloc.dart';

@immutable
class BookManagementState {
  final String isbn;
  final String name;
  final int vol;
  final SubmitState submitState;

  const BookManagementState({
    this.isbn = '',
    this.name = '',
    this.vol = 0,
    this.submitState = SubmitState.idle,
  });

  BookManagementState copyWith({
    String? isbn,
    String? name,
    int? vol,
    SubmitState? submitState,
  }) =>
      BookManagementState(
          isbn: isbn ?? this.isbn,
          name: name ?? this.name,
          vol: vol ?? this.vol,
          submitState: submitState ?? this.submitState);

  String? isIsbnValid() => (isbn.isNotEmpty) ? null : 'Enter ISBN';
  String? isNameValid() => (name.isNotEmpty) ? null : 'Enter book name';
  String? isVolValid() => (vol >= 0) ? null : 'Vol is invalid';
}
