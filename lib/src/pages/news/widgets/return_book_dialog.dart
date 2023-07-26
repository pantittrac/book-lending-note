import 'package:book_lending_note/src/bloc/return_book_bloc/return_book_bloc.dart';
import 'package:book_lending_note/src/models/loan_history.dart';
import 'package:book_lending_note/src/repositories/book_repository.dart';
import 'package:book_lending_note/src/utils/submit_state.dart';
import 'package:book_lending_note/src/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReturnBookDialog extends StatelessWidget {
  final LoanHistory note;

  const ReturnBookDialog({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReturnBookBloc(
          repo: RepositoryProvider.of<BookRepository>(context),
          loan: note.loan),
      child: BlocConsumer<ReturnBookBloc, ReturnBookState>(
        listener: (context, state) {
          if (state.state == SubmitState.success) {
            Navigator.pop(context, true);
          }
        },
        buildWhen: (previous, current) => previous.state != current.state,
        builder: (context, state) {
          if (state.state != SubmitState.failure) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      _createTitle('Book: '),
                      const SizedBox(
                        width: 10,
                      ),
                      Text((note.book.vol == 0)
                          ? 'เล่มเดียวจบ'
                          : 'เล่มที่ ${note.book.vol}'),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _createTitle('Borrower: '),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Text(
                        note.borrower.name,
                        maxLines: 2,
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      label: Text('Note'),
                    ),
                    maxLines: 2,
                    onChanged: (value) => context
                        .read<ReturnBookBloc>()
                        .add(NoteChangeEvent(value)),
                  )
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel')),
                ElevatedButton(onPressed: () => context.read<ReturnBookBloc>().add(SubmitEvent()), child: const Text('Confirm'))
              ],
            );
          } else {
            return ErrorDialog(message: 'Something went wrong', func: () => context.read<ReturnBookBloc>().add(BackFromErrorDialogEvent()));
          }
        },
      ),
    );
  }

  Text _createTitle(String msg) => Text(
        msg,
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
}
