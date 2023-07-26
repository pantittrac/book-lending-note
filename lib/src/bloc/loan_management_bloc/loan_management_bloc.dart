import 'package:bloc/bloc.dart';
import 'package:book_lending_note/src/models/borrower.dart';
import 'package:book_lending_note/src/models/loan.dart';
import 'package:book_lending_note/src/repositories/book_repository.dart';
import 'package:book_lending_note/src/utils/submit_state.dart';
import 'package:meta/meta.dart';

part 'loan_management_event.dart';
part 'loan_management_state.dart';

class LoanManagementBloc extends Bloc<LoanManagementEvent, LoanManagementState> {
  final BookRepository repo;
  bool isChange = false;

  LoanManagementBloc({required this.repo}) : super(const LoanManagementState()) {
    on<BookChangeEvent>((event, emit) => 
      emit(state.copyWith(isbn: event.isbn))
    );

    on<BorrowerNameChangeEvent>((event, emit) {
      isChange = false; // เผื่อเปลี่ยน
      emit(state.copyWith(borrower: event.borrower));
    });

    on<BorrowerContactChangeEvent>((event, emit) {
      isChange = true;
      emit(state.copyWith(borrower: state.borrower?.copyWith(contact: event.borrowerContact)));
    });

    on<SubmitLoanEvent>((event, emit) async {
      if (state.isbn != null && state.borrower != null && state.borrower!.contact.isNotEmpty) {
        emit(state.copyWith(state: SubmitState.inProgress));
        var result = 0;
        if (state.borrower!.id == null) {
          final id = await repo.insertBorrower(state.borrower!);
          if (id > 0) {
            result = await repo.insertLoan(Loan(loanDate: DateTime.now(), borrowerId: id, isbn: state.isbn!));
          }
        } else if (isChange) {
          final bResult = await repo.editBorrower(state.borrower!);
          if (bResult > 0) {
            isChange = false;
            result = await repo.insertLoan(Loan(loanDate: DateTime.now(), borrowerId: state.borrower!.id!, isbn: state.isbn!));
          }
        } else {
          result = await repo.insertLoan(Loan(loanDate: DateTime.now(), borrowerId: state.borrower!.id!, isbn: state.isbn!));
        }

        if (result > 0) {
          emit(state.copyWith(state: SubmitState.success));
        } else {
          emit(state.copyWith(state: SubmitState.failure));
        }
      }
    });
  }
}
