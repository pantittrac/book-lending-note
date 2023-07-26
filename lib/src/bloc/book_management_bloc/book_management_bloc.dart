import 'package:bloc/bloc.dart';
import 'package:book_lending_note/src/models/book.dart';
import 'package:book_lending_note/src/repositories/book_repository.dart';
import 'package:book_lending_note/src/utils/db_operation.dart';
import 'package:book_lending_note/src/utils/submit_state.dart';
import 'package:meta/meta.dart';

part 'book_management_event.dart';
part 'book_management_state.dart';

class BookManagementBloc extends Bloc<BookManagementEvent, BookManagementState> {
  final BookRepository repo;
  final DbOp op;
  final Book? book;

  BookManagementBloc({required this.repo, required this.op, this.book}) : super(const BookManagementState()) {
    on<BookIsbnChangedEvent>((event, emit) {
      emit(state.copyWith(isbn: event.isbn));
    });

    on<BookNameChangedEvent>((event, emit) {
      emit(state.copyWith(name: event.name));
    });

    on<BookVolChangedEvent>((event, emit) {
      final vol = int.tryParse(event.vol) ?? -1;
      emit(state.copyWith(vol: vol));
    });

    on<BookSubmitEvent>((event, emit) async {
      emit(state.copyWith(submitState: SubmitState.inProgress));

      if(state.isIsbnValid() == null && state.isNameValid() == null && state.isVolValid() == null) {
        switch(op) {
          case DbOp.create:
            ((await repo.insertBook(Book(isbn: state.isbn, name: state.name, vol: state.vol))) > 0) ?
            emit(state.copyWith(submitState: SubmitState.success)) :
            emit(state.copyWith(submitState: SubmitState.failure));
            break;
          case DbOp.update:
            ((await repo.editBook(Book(isbn: state.isbn, name: state.name, vol: state.vol))) > 0) ?
            emit(state.copyWith(submitState: SubmitState.success)) :
            emit(state.copyWith(submitState: SubmitState.failure));
            break;
        }
      }
    });

    on<BackFromErrorDialogEvent>((event, emit) => emit(state.copyWith(submitState: SubmitState.idle)));
  }
}
