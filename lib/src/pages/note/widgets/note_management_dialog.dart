import 'package:book_lending_note/src/bloc/book_info_bloc/book_info_bloc.dart';
import 'package:book_lending_note/src/bloc/borrower_info_bloc/borrower_info_bloc.dart';
import 'package:book_lending_note/src/bloc/loan_management_bloc/loan_management_bloc.dart';
import 'package:book_lending_note/src/models/book_status.dart';
import 'package:book_lending_note/src/models/borrower.dart';
import 'package:book_lending_note/src/repositories/book_repository.dart';
import 'package:book_lending_note/src/utils/db_operation.dart';
import 'package:book_lending_note/src/utils/submit_state.dart';
import 'package:book_lending_note/src/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteManagementDialog extends StatelessWidget {
  final String title;
  final DbOp op;

  const NoteManagementDialog({super.key, required this.title, required this.op});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => BookInfoBloc(
                repo: RepositoryProvider.of<BookRepository>(context))
              ..add(LoadBookNameEvent())),
        BlocProvider(
            create: (context) => BorrowerInfoBloc(
                repo: RepositoryProvider.of<BookRepository>(context))
              ..add(FetchBorrowerInfoEvent())),
        BlocProvider(
            create: (context) => LoanManagementBloc(
                repo: RepositoryProvider.of<BookRepository>(context)))
      ],
      child: BlocBuilder<BookInfoBloc, BookInfoState>(
        builder: (context, bookInfoState) =>
            BlocBuilder<BorrowerInfoBloc, BorrowerInfoState>(
          builder: (context, borrowerInfoState) =>
              BlocConsumer<LoanManagementBloc, LoanManagementState>(
            listenWhen: (previous, current) =>
                current.state == SubmitState.success,
            listener: (context, state) => Navigator.pop(context, true),
            buildWhen: (previous, current) =>
                (previous.state == SubmitState.failure ||
                    current.state == SubmitState.failure),
            builder: (context, loanManagementState) {
              if (bookInfoState.loadNameStatus == LoadStatus.loaded &&
                  borrowerInfoState is BorrowerInfoLoadedState) {
                return NoteManagementForm(
                  title: title,
                  op: op,
                  bookNameList: bookInfoState.bookNameList,
                  volStatus: bookInfoState.loadVolStatus,
                  volList: bookInfoState.volList,
                  borrowerList: borrowerInfoState.borrowers,
                );
              } else {
                return const LoadingDialog();
              }
            },
          ),
        ),
      ),
    );
  }
}

class NoteManagementForm extends StatefulWidget {
  final String title;
  final DbOp op;
  final List<String> bookNameList;
  final LoadStatus volStatus;
  final List<VolStatus> volList;
  final List<Borrower> borrowerList;

  const NoteManagementForm({
    super.key,
    required this.title,
    required this.op,
    required this.bookNameList,
    required this.volStatus,
    required this.volList,
    required this.borrowerList,
  });

  @override
  State<NoteManagementForm> createState() => _NoteManagementFormState();
}

class _NoteManagementFormState extends State<NoteManagementForm> {
  final _formKey = GlobalKey<FormState>();
  final _dropdownKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoanManagementBloc, LoanManagementState>(
      builder: (context, state) {
        final controller = TextEditingController(text: (state.borrower == null ||
            state.borrower?.contact == '')
            ? null
            : state.borrower!.contact);
        return AlertDialog(
          scrollable: true,
          title: Text(widget.title),
          content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField(
                      hint: const Text("Book's Name"),
                      validator: (value) => (value == null)
                          ? 'Please select Book'
                          : null, // EDIT อาจจะต้องแก้ทีหลังให้เป็น bloc
                      items: widget.bookNameList
                          .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              ))
                          .toList(),
                      onChanged: (value) {
                        _dropdownKey.currentState
                            ?.reset(); // ต้อง reset ตรงนี้ก่อนเลยไม่อย่างนั้นจะ error
                        context
                            .read<LoanManagementBloc>()
                            .add(BookChangeEvent(null));
                        context
                            .read<BookInfoBloc>()
                            .add(LoadBookVolEvent(value!));
                      }),
                  DropdownButtonFormField(
                    key: _dropdownKey,
                    hint: const Text("Book's Vol"),
                    validator: (value) => state.isBookValid(),
                    decoration: InputDecoration(
                        prefixIcon: (widget.volStatus == LoadStatus.loading)
                            ? const CircularProgressIndicator()
                            : null,
                        prefixIconConstraints:
                            const BoxConstraints(maxHeight: 20, maxWidth: 20)),
                    items: widget.volList
                        .map((item) => DropdownMenuItem(
                              value: item.isbn,
                              child: (item.vol == 0)
                                  ? const Text('เล่มเดียวจบ')
                                  : Text(item.vol.toString()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      context
                          .read<LoanManagementBloc>()
                          .add(BookChangeEvent(value));
                    },
                  ),
                  Autocomplete(
                    initialValue: (state.borrower?.name == null)
                        ? null
                        : TextEditingValue(text: state.borrower!.name),
                    optionsBuilder: (textEditingValue) => widget.borrowerList
                        .where((element) =>
                            element.name.startsWith(textEditingValue.text)),
                    displayStringForOption: (borrower) => borrower.name,
                    fieldViewBuilder: (context, textEditingController,
                            focusNode, onFieldSubmitted) =>
                        TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      validator: (value) => state.isBorrowerNameValid(),
                      onChanged: (value) => context
                          .read<LoanManagementBloc>()
                          .add(BorrowerNameChangeEvent(
                              Borrower(name: value, contact: ''))),
                    ),
                    onSelected: (borrower) => context
                        .read<LoanManagementBloc>()
                        .add(BorrowerNameChangeEvent(borrower)),
                  ),
                  TextFormField(
                    // initialValue: (state.borrower == null ||
                    //         state.borrower?.contact == '')
                    //     ? null
                    //     : state.borrower!.contact,
                    controller: controller,
                    validator: (value) => state.isBorrowerContactValid(),
                    onChanged: (value) => context
                        .read<LoanManagementBloc>()
                        .add(BorrowerContactChangeEvent(value)),
                  ),
                ],
              )),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel')),
            ElevatedButton(
                onPressed: () =>
                    context.read<LoanManagementBloc>().add(SubmitLoanEvent()),
                child: const Text('Confirm')),
          ],
        );
      },
    );
  }
}
