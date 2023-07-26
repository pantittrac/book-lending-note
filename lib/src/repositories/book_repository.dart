import 'package:book_lending_note/src/bloc/book_info_bloc/book_info_bloc.dart';
import 'package:book_lending_note/src/dao/book_dao.dart';
import 'package:book_lending_note/src/dao/borrower_dao.dart';
import 'package:book_lending_note/src/dao/loan_dao.dart';
import 'package:book_lending_note/src/models/book.dart';
import 'package:book_lending_note/src/models/book_status.dart';
import 'package:book_lending_note/src/models/borrower.dart';
import 'package:book_lending_note/src/models/loan.dart';
import 'package:book_lending_note/src/models/loan_history.dart';

class BookRepository {

  final BookDao _bookDao;
  final LoanDao _loanDao;
  final BorrowerDao _borrowerDao;

  BookRepository(this._bookDao, this._loanDao, this._borrowerDao);

  Future<int> insertBook(Book book) => _bookDao.insert(book);

  Future<int> insertBorrower(Borrower borrower) => _borrowerDao.insert(borrower);

  Future<int> insertLoan(Loan loan) => _loanDao.insert(loan);

  Future<int> editBook(Book book) => _bookDao.updateItem(book);

  Future<int> editBorrower(Borrower borrower) => _borrowerDao.updateItem(borrower);

  Future<int> editLoan(Loan loan) => _loanDao.updateItem(loan);

  Future<int> deleteBook(String isbn) => _bookDao.deleteItem(isbn);

  Future<int> deleteBorrower(int id) => _borrowerDao.deleteItem(id);

  Future<int> deleteLoan(int id) => _loanDao.deleteItem(id);

  Future<List<Borrower>> getBorrower() => _borrowerDao.getAll();

  // for note page
  Future<List<LoanHistory>> getLoanRecords({bool isReturn = false}) => _loanDao.getLoanHistory(isReturn);

  // for book page
  Future<List<BookStatus>> getBookStatus() => _bookDao.getBookStatus();

  Future<List<String>> getBookName() => _bookDao.getBookName();

  Future<List<VolStatus>> getBookVols(String bookName) => _bookDao.getBookVols(bookName);

}