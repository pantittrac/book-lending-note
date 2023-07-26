import 'package:bloc/bloc.dart';
import 'package:book_lending_note/src/models/book.dart';
import 'package:book_lending_note/src/models/book_status.dart';
import 'package:book_lending_note/src/models/loan.dart';
import 'package:book_lending_note/src/repositories/book_repository.dart';
import 'package:meta/meta.dart';

part 'book_info_event.dart';
part 'book_info_state.dart';

class BookInfoBloc extends Bloc<BookInfoEvent, BookInfoState> {
  final BookRepository repo;

  BookInfoBloc({required this.repo}) : super(const BookInfoState(loadNameStatus: LoadStatus.loaded)) {
    on<LoadBookNameEvent>((event, emit) async {
      emit(state.copyWith(loadNameStatus: LoadStatus.loaded, bookNameList: await repo.getBookName()));
    });

    on<LoadBookVolEvent>((event, emit) async {
      emit(state.copyWith(loadVolStatus: LoadStatus.loading));
      emit(state.copyWith(loadVolStatus: LoadStatus.loaded, volList: await repo.getBookVols(event.bookName)));
    });
  }
}
