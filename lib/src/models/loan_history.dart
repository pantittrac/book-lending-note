import 'package:book_lending_note/src/models/book.dart';
import 'package:book_lending_note/src/models/borrower.dart';
import 'package:book_lending_note/src/models/loan.dart';

class LoanHistory {
  final Book book;
  final Loan loan;
  final Borrower borrower;

  LoanHistory(this.book, this.loan, this.borrower);
}