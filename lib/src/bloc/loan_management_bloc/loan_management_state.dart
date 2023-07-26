part of 'loan_management_bloc.dart';

@immutable
class LoanManagementState {
  final String? isbn;
  final Borrower? borrower;
  final SubmitState state;

  const LoanManagementState(
      {this.isbn, this.borrower, this.state = SubmitState.idle});

  LoanManagementState copyWith({
    String? isbn,
    Borrower? borrower,
    SubmitState? state,
  }) =>
      LoanManagementState(
          isbn: isbn ?? this.isbn,
          borrower: borrower ?? this.borrower,
          state: state ?? this.state);

  String? isBookValid() => (isbn == null || isbn!.isEmpty) ? 'Please select Book' : null;

  String? isBorrowerNameValid() => (borrower == null || borrower!.name.isEmpty) ? 'Enter Borrower\'s Name' : null;
  String? isBorrowerContactValid() => (borrower == null || borrower!.contact.isEmpty) ? 'Enter Borrower\'s Contact' : null;
  
}
