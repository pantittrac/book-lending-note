part of 'borrower_info_bloc.dart';

@immutable
abstract class BorrowerInfoState {}

class BorrowerInfoLoadingState extends BorrowerInfoState {}

class BorrowerInfoLoadedState extends BorrowerInfoState {
  final List<Borrower> borrowers;

  BorrowerInfoLoadedState(this.borrowers);
}
