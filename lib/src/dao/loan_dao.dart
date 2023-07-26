import 'package:book_lending_note/src/dao/dao.dart';
import 'package:book_lending_note/src/database/db_manager.dart';
import 'package:book_lending_note/src/models/book.dart';
import 'package:book_lending_note/src/models/borrower.dart';
import 'package:book_lending_note/src/models/loan.dart';
import 'package:book_lending_note/src/models/loan_history.dart';

class LoanDao implements Dao<Loan, int> {
  @override
  Future<int> deleteItem(int key) async {
    return await (await DbManager().database).delete(Loan.tableName, where: '${Loan.columnId} = ?', whereArgs: [key]);
  }

  @override
  Future<List<Loan>> getAll() async {
    final maps = await (await DbManager().database).query(Loan.tableName);
    if (maps.isNotEmpty) {
      return maps.map((item) => Loan.fromMap(item)).toList();
    }
    throw("Don't have this News");
  }

  @override
  Future<Loan> getItem(int key) async {
     final maps = await (await DbManager().database).query(Loan.tableName, where: '${Loan.columnId} = ?', whereArgs: [key]);
    if (maps.isNotEmpty) {
      return Loan.fromMap(maps[0]);
    }
    throw("Don't have this News");
  }

  @override
  Future<int> insert(Loan item) async {
    return await (await DbManager().database).insert(Loan.tableName, item.toMap());
  }

  @override
  Future<int> updateItem(Loan item) async {
    return await (await DbManager().database).update(Loan.tableName, item.toMap(), where: '${Loan.columnId} = ?', whereArgs: [item.id]);
  }

  Future<List<LoanHistory>> getLoanHistory(bool isReturn) async { // true แสดงหนังสือที่คืนแล้ว
    final db = await DbManager().database;
    final condition = isReturn ? '<>' : '=';
    final maps = await db.rawQuery('SELECT l.*, bk.${Book.columnName} AS bookName, bk.${Book.columnVol} AS bookVol, br.${Borrower.columnName} AS borrowerName, br.${Borrower.columnContact} AS borrowerContact FROM ${Loan.tableName} l LEFT JOIN ${Book.tableName} bk ON l.${Loan.columnIsbn} = bk.${Book.columnIsbn} LEFT JOIN ${Borrower.tableName} br ON l.${Loan.columnBorrowerId} = br.${Borrower.columnId} WHERE l.${Loan.columnReturnDate} $condition "" ');
    if (maps.isNotEmpty) {
      return maps.map((row) => LoanHistory(Book(isbn: row[Loan.columnIsbn] as String, name: row['bookName'] as String, vol: row['bookVol'] as int), Loan.fromMap(row), Borrower(id: row[Loan.columnBorrowerId] as int, name: row['borrowerName'] as String, contact: row['borrowerContact'] as String))).toList();
    }
    return [];
  }
}