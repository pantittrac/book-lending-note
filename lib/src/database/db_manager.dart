import 'package:book_lending_note/src/models/book.dart';
import 'package:book_lending_note/src/models/borrower.dart';
import 'package:book_lending_note/src/models/loan.dart';
import 'package:book_lending_note/src/models/news.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbManager {  

  static final DbManager _instance = DbManager._internal();

  Database? _database;

  factory DbManager() => _instance;

  DbManager._internal();

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'book_lending.db');
    return openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int ver) async {
    await db.execute('CREATE TABLE ${Book.tableName} (${Book.columnIsbn} VARCHAR(13) PRIMARY KEY , ${Book.columnName} TEXT, ${Book.columnVol} INTEGER)');
    await db.execute('CREATE TABLE ${Borrower.tableName} (${Borrower.columnId} INTEGER PRIMARY KEY AUTOINCREMENT, ${Borrower.columnName} TEXT, ${Borrower.columnContact} TEXT)');
    await db.execute('CREATE TABLE ${Loan.tableName} (${Loan.columnId} INTEGER PRIMARY KEY AUTOINCREMENT, ${Loan.columnLoanDate} VARCHAR(10), ${Loan.columnReturnDate} VARCHAR(10), ${Loan.columnNote} TEXT, ${Loan.columnBorrowerId} INTEGER, ${Loan.columnIsbn} VARCHAR(13), FOREIGN KEY (${Loan.columnBorrowerId}) REFERENCES ${Borrower.tableName} (${Borrower.columnId}) ON DELETE CASCADE ON UPDATE CASCADE, FOREIGN KEY (${Loan.columnIsbn}) REFERENCES ${Book.tableName} (${Book.columnIsbn}) ON DELETE CASCADE ON UPDATE CASCADE)');
    await db.execute('CREATE TABLE ${News.tableName} (${News.columnId} INTEGER PRIMARY KEY AUTOINCREMENT, ${News.columnTitle} TEXT, ${News.columnUrl} TEXT)');
  }
}