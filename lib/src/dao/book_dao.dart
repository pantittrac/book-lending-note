import 'package:book_lending_note/src/bloc/book_info_bloc/book_info_bloc.dart';
import 'package:book_lending_note/src/dao/dao.dart';
import 'package:book_lending_note/src/database/db_manager.dart';
import 'package:book_lending_note/src/models/book.dart';
import 'package:book_lending_note/src/models/book_status.dart';
import 'package:book_lending_note/src/models/loan.dart';

class BookDao implements Dao<Book, String> {
  @override
  Future<int> deleteItem(String key) async {
    final db = await DbManager().database;
    return await db.delete(Book.tableName,
        where: '${Book.columnIsbn} = ?', whereArgs: [key]);
  }

  @override
  Future<List<Book>> getAll() async {
    final db = await DbManager().database;
    final maps = await db.query(Book.tableName);
    if (maps.isNotEmpty) {
      return maps.map((item) => Book.fromMap(item)).toList();
    }
    return [];
  }

  @override
  Future<Book> getItem(String key) async {
    final db = await DbManager().database;
    final maps = await db.query(Book.tableName,
        where: '${Book.columnIsbn} = ?', whereArgs: [key]);
    if (maps.isNotEmpty) {
      return Book.fromMap(maps.first);
    }
    throw ("Don't have this book");
  }

  @override
  Future<int> insert(Book item) async {
    final db = await DbManager().database;
    return await db.insert(Book.tableName, item.toMap());
  }

  @override
  Future<int> updateItem(Book item) async {
    final db = await DbManager().database;
    return await db.update(Book.tableName, item.toMap(),
        where: '${Book.columnIsbn} = ?', whereArgs: [item.isbn]);
  }

  Future<List<String>> getBookName() async {
    final db = await DbManager().database;
    final maps = await db.query(Book.tableName,
        columns: [Book.columnName], groupBy: Book.columnName);
    if (maps.isNotEmpty) {
      return maps.map((item) => item[Book.columnName].toString()).toList();
    }
    return [];
  }

  Future<List<BookStatus>> getBookStatus() async {
    final db = await DbManager().database;
    const loanSql =
        '(SELECT ${Loan.columnIsbn}, "Y" AS status FROM ${Loan.tableName} WHERE ${Loan.columnReturnDate} = "" )'; // สถานะยืมอยู่แปลว่ายังไม่มีวันที่คืน
    const sql = 'SELECT bk.*, coalesce(l.status, "") AS status FROM ${Book.tableName} bk LEFT JOIN $loanSql l ON bk.${Book.columnIsbn} = l.${Loan.columnIsbn} ORDER BY bk.${Book.columnName}, bk.${Book.columnVol}';
    final maps = await db.rawQuery(sql);
    if (maps.isNotEmpty) {
      List<BookStatus> bookStatusList = [];
      String bookName = '';
      for (var row in maps) {
        // int vol = row[Book.columnVol] as int;
        // bool status = (row['status'] as String) == 'Y' ? true : false;
        VolStatus volStatus = VolStatus(isbn: row[Book.columnIsbn] as String, vol: row[Book.columnVol] as int, onLoan: (row['status'] as String) == 'Y' ? true : false);
        String newBookName = row[Book.columnName].toString();
        if (bookName == newBookName) {
          // bookStatusList.last.volStatus[vol] = status;
          bookStatusList.last.volStatusList.add(volStatus);
        } else {
          bookName = newBookName;
          // var map = {vol: status};
          // var bookStatus = BookStatus(bookName, map);
          // bookStatusList.add(bookStatus);
          bookStatusList.add(BookStatus(bookName, [volStatus]));
        }
      }
      return bookStatusList;
    }
    return [];
  }

  Future<List<VolStatus>> getBookVols(String name) async {
    const loanSql = 'SELECT ${Loan.columnIsbn} FROM ${Loan.tableName} WHERE ${Loan.columnReturnDate} = "" '; // ยังไม่มีวันคืน -> ยังไม่คืน
    final maps = await(await DbManager().database).rawQuery('SELECT ${Loan.columnIsbn}, ${Book.columnVol} FROM ${Book.tableName} WHERE ${Book.columnName} = ? AND ${Book.columnIsbn} NOT IN ($loanSql)', [name]);
    //final maps = await (await DbManager().database).query(Book.tableName, columns: [Book.columnVol], where: '${Book.columnName} = ?', whereArgs: [name]);
    final List<VolStatus> data = maps.map((item) => VolStatus.fromMap(item)).toList();
    return data;
  }
}
