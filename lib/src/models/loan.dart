import 'package:intl/intl.dart';

class Loan {
  static const tableName = 'loan';
  static const columnId = 'id';
  static const columnLoanDate = 'loan_date';
  static const columnReturnDate = 'return_date';
  static const columnNote = 'note';
  static const columnBorrowerId = 'borrower_id';
  static const columnIsbn = 'isbn';

  final int? id;
  final String loanDate;
  final String returnDate;
  final String note;
  final int borrowerId;
  final String isbn;

  Loan({this.id, required DateTime loanDate, this.returnDate = '', this.note = '', required this.borrowerId,
      required this.isbn}) : loanDate = DateFormat('yyyy/MM/dd').format(loanDate);

  Loan._init({required this.id, required this.loanDate, required this.returnDate, required this.note, required this.borrowerId,
      required this.isbn});

  Loan.fromMap(Map<String, dynamic> data)
      : id = data[columnId],
        loanDate = data[columnLoanDate],
        returnDate = data[columnReturnDate],
        note = data[columnNote],
        borrowerId = data[columnBorrowerId],
        isbn = data[columnIsbn];

  Map<String, dynamic> toMap() => {
        columnId: id,
        columnLoanDate: loanDate,
        columnReturnDate: returnDate,
        columnNote: note,
        columnBorrowerId: borrowerId,
        columnIsbn: isbn
      };

  Loan returnBook({required DateTime returnDate, String? note}) => Loan._init(id: id, loanDate: loanDate, returnDate: DateFormat('yyyy/MM/dd').format(returnDate), note: note ?? this.note, borrowerId: borrowerId, isbn: isbn);
}
