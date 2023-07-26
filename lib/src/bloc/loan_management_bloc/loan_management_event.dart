part of 'loan_management_bloc.dart';

@immutable
abstract class LoanManagementEvent {}

class BookChangeEvent extends LoanManagementEvent {
  final String? isbn;

  BookChangeEvent(this.isbn);
}

class BorrowerNameChangeEvent extends LoanManagementEvent {
  final Borrower borrower;

  BorrowerNameChangeEvent(this.borrower);
}

// เรียก event นี้แปลว่ามีการ update หรือ create Borrower
class BorrowerContactChangeEvent extends LoanManagementEvent {
  final String borrowerContact;

  BorrowerContactChangeEvent(this.borrowerContact);
}

class SubmitLoanEvent extends LoanManagementEvent {}
