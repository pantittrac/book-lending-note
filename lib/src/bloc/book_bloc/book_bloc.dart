import 'package:bloc/bloc.dart';
import 'package:book_lending_note/src/models/book_status.dart';
import 'package:book_lending_note/src/repositories/book_repository.dart';
import 'package:book_lending_note/src/utils/db_operation.dart';
import 'package:meta/meta.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository repo;

  List<BookStatus> _bookStatusList = [];

  BookBloc({required this.repo}) : super(BookLoadingState()) {
    on<LoadBookEvent>((event, emit) async => await _loadBook(emit));

    on<RefreshBookEvent>((event, emit) async {
      if (event.isRefresh) {
        await _loadBook(emit);
      }
    });

    on<AddBookEvent>((event, emit) => emit(ShowManagementDialogState(title: 'Add Book', op: DbOp.create)));

    on<DeleteBookEvent>((event, emit) => emit(ShowDeleteDialogState(type: 'Book', isbn: event.isbn, func: repo.deleteBook)));

    on<SearchBookEvent>((event, emit) {
      final search = event.search;
      if (search.isEmpty) {
        emit(BookLoadedState(_bookStatusList));
      } else {
        emit(BookLoadedState(_bookStatusList.where((element) => element.name.toLowerCase().startsWith(search.toLowerCase())).toList()));
      }
    });
  }

  Future<void> _loadBook(Emitter<BookState> emit) async {
    emit(BookLoadingState());

    _bookStatusList = await repo.getBookStatus();
    emit(BookLoadedState(_bookStatusList));
  }
}
