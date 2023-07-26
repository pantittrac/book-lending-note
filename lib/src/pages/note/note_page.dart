import 'package:book_lending_note/src/bloc/note_bloc/note_bloc.dart';
import 'package:book_lending_note/src/pages/news/widgets/return_book_dialog.dart';
import 'package:book_lending_note/src/pages/note/history_page.dart';
import 'package:book_lending_note/src/pages/note/widgets/note_item.dart';
import 'package:book_lending_note/src/pages/note/widgets/note_management_dialog.dart';
import 'package:book_lending_note/src/repositories/book_repository.dart';
import 'package:book_lending_note/src/widgets/delete_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotePage extends StatelessWidget {
  const NotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NoteBloc(repo: RepositoryProvider.of<BookRepository>(context))
            ..add(LoadNoteEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
          actions: [
            Builder(builder: (context) {
              return TextButton(
                  onPressed: () =>
                      context.read<NoteBloc>().add(ShowHistoryEvent()),
                  child: const Text(
                    'History',
                    style: TextStyle(color: Colors.white),
                  ),);
            })
          ],
        ),
        body: BlocConsumer<NoteBloc, NoteState>(
          listener: (context, state) async {
            bool isRefresh = false;
            if (state is ShowManagementDialogState) {
              isRefresh = await showDialog(
                  context: context,
                  builder: (context) => NoteManagementDialog(
                        title: state.title,
                        op: state.op,
                      ));
            } else if (state is ShowDeleteDialogState) {
              isRefresh = await showDialog(
                  context: context,
                  builder: (context) => DeleteConfirmationDialog(
                      type: state.type, id: state.id, deleteFunc: state.func));
            } else if (state is ShowReturnBookDialogState) {
              isRefresh = await showDialog(
                  context: context,
                  builder: (context) => ReturnBookDialog(note: state.note));
            } else if (state is ShowHistoryPageState) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoryPage(),
                  ));
            }

            if (context.mounted) {
              context.read<NoteBloc>().add(RefreshNoteEvent(isRefresh));
            }
          },
          buildWhen: (previous, current) =>
              (current is! ShowManagementDialogState &&
                  current is! ShowDeleteDialogState &&
                  current is! ShowReturnBookDialogState &&
                  current is! ShowHistoryPageState),
          builder: (context, state) {
            if (state is NoteLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is NoteLoadedState) {
              final list = state.loanHistory;
              if (list.isNotEmpty) {
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) => NoteItem(
                    note: list[index],
                    isHistory: false,
                    index: index,
                  ),
                );
              } else {
                return const Center(
                  child: Text('No Data'),
                );
              }
            }
            return const Center(
              child: Text('Error'),
            );
          },
        ),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () => context.read<NoteBloc>().add(AddNoteEvent()),
            child: const Icon(Icons.note_add_rounded),
          );
        }),
      ),
    );
  }
}
