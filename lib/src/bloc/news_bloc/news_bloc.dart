import 'package:bloc/bloc.dart';
import 'package:book_lending_note/src/models/news.dart';
import 'package:book_lending_note/src/repositories/news_repository.dart';
import 'package:book_lending_note/src/utils/db_operation.dart';
import 'package:meta/meta.dart';

part 'news_event.dart';

part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository repo;

  List<News> _newsList = [];

  NewsBloc(this.repo) : super(NewsInitial()) {
    on<LoadNewsEvent>((event, emit) => _loadNews(emit));

    on<AddNewsEvent>((event, emit) =>
        emit(ShowManagementDialog(title: 'Add News', op: DbOp.create)));

    on<EditNewsEvent>((event, emit) => emit(ShowManagementDialog(
        title: 'Edit News', op: DbOp.update, news: _newsList[event.index])));
    
    on<RefreshNewsEvent>((event, emit) async {
      if (event.isRefresh) {
        await _loadNews(emit);
      }
    });

    on<DeleteNewsEvent>((event, emit) => emit(ShowDeleteConfimationDialog(id: _newsList[event.index].id!, deleteFunc: repo.deleteNews)));

    on<OpenWebViewPageEvent>((event, emit) => emit(OpenWebViewPageState(_newsList[event.index].url)));
  }

  Future<void> _loadNews(Emitter<NewsState> emit) async {
    emit(NewsLoadingState());
    try {
      _newsList = await repo.getAllNews();
      emit(NewsLoadedState(newsList: _newsList));
    } catch (e) {
      emit(NewsErrorState(e.toString()));
    }
  }
}
