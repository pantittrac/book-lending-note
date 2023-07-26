import 'package:book_lending_note/src/dao/dao.dart';
import 'package:book_lending_note/src/database/db_manager.dart';
import 'package:book_lending_note/src/models/news.dart';

class NewsDao implements Dao<News, int> {
  @override
  Future<int> deleteItem(int key) async {
    return await (await DbManager().database).delete(News.tableName, where: '${News.columnId} = ?', whereArgs: [key]);
  }

  @override
  Future<List<News>> getAll() async {
    final maps = await (await DbManager().database).query(News.tableName);
    if (maps.isNotEmpty) {
      return maps.map((item) => News.fromMap(item)).toList();
    }
    return [];
  }

  @override
  Future<News> getItem(int key) async {
    final maps = await (await DbManager().database).query(News.tableName, where: '${News.columnId} = ?', whereArgs: [key]);
    if (maps.isNotEmpty) {
      return News.fromMap(maps[0]);
    }
    throw("Don't have this News");
  }

  @override
  Future<int> insert(News item) async {
     return await (await DbManager().database).insert(News.tableName, item.toMap());
  }

  @override
  Future<int> updateItem(News item) async {
     return await (await DbManager().database).update(News.tableName, item.toMap(), where: '${News.columnId} = ?', whereArgs: [item.id]);
  }

}