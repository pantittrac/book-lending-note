import 'package:bloc/bloc.dart';
import 'package:book_lending_note/src/models/news.dart';
import 'package:book_lending_note/src/repositories/news_repository.dart';
import 'package:book_lending_note/src/utils/db_operation.dart';
import 'package:book_lending_note/src/utils/submit_state.dart';
import 'package:meta/meta.dart';

part 'news_management_event.dart';
part 'news_management_state.dart';

class NewsManagementBloc extends Bloc<NewsManagementEvent, NewsManagementState> {
  final NewsRepository repo;
  final DbOp op;
  final News? news;
  
  NewsManagementBloc({required this.repo, required this.op, required this.news}) : super(NewsManagementState(title: news?.title ?? '', url: news?.url ?? '')) {
    on<NewsTitleChangedEvent>((event, emit) => emit(state.copyWith(title: event.title)));

    on<NewsUrlChangedEvent>((event, emit) => emit(state.copyWith(url: event.url)));

    on<NewsSubmitEvent>((event, emit) async {
      emit(state.copyWith(submitState: SubmitState.inProgress));
      
      if (state.isTitleValid() == null && state.isUrlValid() == null) {
        switch (op) {
          case DbOp.create:
            ((await repo.insertNews(News(title: state.title, url: state.url))) > 0) ?
            emit(state.copyWith(submitState: SubmitState.success)) :
            emit(state.copyWith(submitState: SubmitState.failure));
            break;
          case DbOp.update:
            ((await repo.editNews(news!.copyWith(title: state.title, url: state.url))) > 0) ?
            emit(state.copyWith(submitState: SubmitState.success)) :
            emit(state.copyWith(submitState: SubmitState.failure));
            break;
        }
      }
    });
  }
}
