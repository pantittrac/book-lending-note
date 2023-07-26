import 'package:book_lending_note/src/dao/dao.dart';
import 'package:book_lending_note/src/database/db_manager.dart';
import 'package:book_lending_note/src/models/borrower.dart';

class BorrowerDao implements Dao<Borrower, int> {
  @override
  Future<int> deleteItem(int key) async {
    return await (await DbManager().database).delete(Borrower.tableName, where: '${Borrower.columnId} = ?', whereArgs: [key]);
  }

  @override
  Future<List<Borrower>> getAll() async {
    final maps = await (await DbManager().database).query(Borrower.tableName);
    if (maps.isNotEmpty) {
      return maps.map((item) => Borrower.fromMap(item)).toList();
    }
    return [];
  }

  @override
  Future<Borrower> getItem(int key) async {
    final maps = await (await DbManager().database).query(Borrower.tableName, where: '${Borrower.columnId} = ?', whereArgs: [key]);
    if (maps.isNotEmpty) {
      return Borrower.fromMap(maps[0]);
    }
    throw("Don't have this borrower");
  }

  @override
  Future<int> insert(Borrower item) async {
    return await (await DbManager().database).insert(Borrower.tableName, item.toMap());
  }

  @override
  Future<int> updateItem(Borrower item) async {
    return await (await DbManager().database).update(Borrower.tableName, item.toMap(), where: '${Borrower.columnId} = ?', whereArgs: [item.id]);
  }

}