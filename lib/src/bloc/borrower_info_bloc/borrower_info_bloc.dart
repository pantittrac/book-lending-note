import 'package:bloc/bloc.dart';
import 'package:book_lending_note/src/models/borrower.dart';
import 'package:book_lending_note/src/repositories/book_repository.dart';
import 'package:meta/meta.dart';

part 'borrower_info_event.dart';
part 'borrower_info_state.dart';

class BorrowerInfoBloc extends Bloc<BorrowerInfoEvent, BorrowerInfoState> {
  final BookRepository repo;

  BorrowerInfoBloc({required this.repo}) : super(BorrowerInfoLoadingState()) {
    on<FetchBorrowerInfoEvent>((event, emit) async {
      emit(BorrowerInfoLoadedState(await repo.getBorrower()));
    });
  }
}
