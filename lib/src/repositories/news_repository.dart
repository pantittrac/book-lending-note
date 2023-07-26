import 'package:book_lending_note/src/dao/news_dao.dart';
import 'package:book_lending_note/src/models/news.dart';

class NewsRepository {
  final NewsDao _newsDao;

  NewsRepository(this._newsDao);

  Future<int> insertNews(News news) => _newsDao.insert(news);

  Future<int> editNews(News news) => _newsDao.updateItem(news);

  Future<int> deleteNews(int id) => _newsDao.deleteItem(id);

  Future<List<News>> getAllNews() => _newsDao.getAll();
}