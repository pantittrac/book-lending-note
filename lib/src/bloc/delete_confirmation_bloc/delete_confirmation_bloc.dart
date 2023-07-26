import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:book_lending_note/src/repositories/news_repository.dart';
import 'package:meta/meta.dart';

part 'delete_confirmation_event.dart';
part 'delete_confirmation_state.dart';

class DeleteConfirmationBloc extends Bloc<DeleteConfirmationEvent, DeleteConfirmationState> {
  final dynamic id;
  Function deleteFunc;

  DeleteConfirmationBloc({required this.id, required this.deleteFunc}) : super(DeleteConfirmationInitial()) {
    on<ConfirmDeleteEvent>((event, emit) async {
      emit(LoadingState());
      final int status = await deleteFunc(id);
      if (status > 0) {
        emit(CompleteState());
      } else {
        emit(ErrorState());
      }
    });
  }
}
