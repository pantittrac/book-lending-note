import 'package:bloc/bloc.dart';
import 'package:book_lending_note/src/models/loan_history.dart';
import 'package:book_lending_note/src/repositories/book_repository.dart';
import 'package:book_lending_note/src/utils/db_operation.dart';
import 'package:meta/meta.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final BookRepository repo;
  final bool isHistory;
  List<LoanHistory> _notes = [];

  NoteBloc({required this.repo, this.isHistory = false}) : super(NoteLoadingState()) {
    on<LoadNoteEvent>((event, emit) async => await _loadNote(emit));

    on<RefreshNoteEvent>((event, emit) async {
      if (event.isRefresh) {
        await _loadNote(emit);
      }
    });

    on<AddNoteEvent>((event, emit) => emit(ShowManagementDialogState(title: 'create', op: DbOp.create)));

    on<EditNoteEvent>((event, emit) => emit(ShowManagementDialogState(title: 'edit', op: DbOp.update, note: _notes[event.index])));

    on<DeleteNoteEvent>((event, emit) => emit(ShowDeleteDialogState(id: _notes[event.index].loan.id!, func: repo.deleteLoan)));

    on<ReturnBookEvent>((event, emit) => emit(ShowReturnBookDialogState(_notes[event.index])));

    on<ShowHistoryEvent>((event, emit) => emit(ShowHistoryPageState()));
  }

  Future<void> _loadNote(Emitter<NoteState> emit) async {
    emit(NoteLoadingState());
    
    _notes = await repo.getLoanRecords(isReturn: isHistory);
    emit(NoteLoadedState(_notes));
  }
}
