import 'package:bloc/bloc.dart';
import 'package:book_lending_note/src/models/loan.dart';
import 'package:book_lending_note/src/repositories/book_repository.dart';
import 'package:book_lending_note/src/utils/submit_state.dart';
import 'package:meta/meta.dart';

part 'return_book_event.dart';
part 'return_book_state.dart';

class ReturnBookBloc extends Bloc<ReturnBookEvent, ReturnBookState> {
  final BookRepository repo;
  final Loan loan;

  ReturnBookBloc({required this.repo, required this.loan})
      : super(const ReturnBookState(state: SubmitState.idle)) {
    on<NoteChangeEvent>(
        (event, emit) => emit(state.copyWith(note: event.note)));

    on<SubmitEvent>((event, emit) async {
      emit(state.copyWith(state: SubmitState.inProgress));

      (await repo.editLoan(loan.returnBook(
                  returnDate: DateTime.now(), note: state.note)) >
              0)
          ? emit(state.copyWith(state: SubmitState.success))
          : emit(state.copyWith(state: SubmitState.failure));
    });

    on<BackFromErrorDialogEvent>((event, emit) => emit(state.copyWith(state: SubmitState.idle)));
  }
}
