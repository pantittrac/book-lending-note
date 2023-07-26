import 'package:book_lending_note/src/bloc/note_bloc/note_bloc.dart';
import 'package:book_lending_note/src/models/loan_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteItem extends StatelessWidget {
  final LoanHistory note;
  final bool isHistory;
  final int index;

  const NoteItem(
      {super.key,
      required this.note,
      required this.isHistory,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
                child: Text(note.book.name, overflow: TextOverflow.ellipsis)),
            if (note.book.vol != 0) ...[
              const SizedBox(
                width: 15,
              ),
              Text(note.book.vol.toString())
            ]
          ],
        ),
        subtitle: Row(
          children: [
            Expanded(
                child: Text(
              note.borrower.name,
              overflow: TextOverflow.ellipsis,
            )),
            const SizedBox(
              width: 15,
            ),
            Text(note.loan.loanDate)
          ],
        ),
        childrenPadding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
        children: [
          Row(
            children: [
              Expanded(child: Text(note.borrower.contact)),
              if (isHistory) Text(note.loan.returnDate),
            ],
          ),
          if (isHistory && note.loan.note != '') Text(note.loan.note),
          if (!isHistory)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () =>
                      context.read<NoteBloc>().add(ReturnBookEvent(index)),
                  child: const Text('Return'),
                ),
                const SizedBox(
                  width: 15,
                ),
                IconButton(
                  onPressed: () =>
                      context.read<NoteBloc>().add(EditNoteEvent(index)),
                  icon: const Icon(Icons.edit_rounded),
                ),
                const SizedBox(
                  width: 15,
                ),
                IconButton(
                  onPressed: () =>
                      context.read<NoteBloc>().add(DeleteNoteEvent(index)),
                  icon: const Icon(Icons.delete_rounded),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
