import 'package:book_lending_note/src/bloc/note_bloc/note_bloc.dart';
import 'package:book_lending_note/src/pages/note/widgets/note_item.dart';
import 'package:book_lending_note/src/repositories/book_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => NoteBloc(
            repo: RepositoryProvider.of<BookRepository>(context),
            isHistory: true)
          ..add(LoadNoteEvent()),
        child: Scaffold(
          appBar: AppBar(title: const Text('History')),
          body: BlocBuilder<NoteBloc, NoteState>(
            builder: (context, state) {
              if (state is NoteLoadedState) {
                return (state.loanHistory.isEmpty)
                    ? const Center(
                        child: Text('No Data'),
                      )
                    : ListView.builder(
                        itemCount: state.loanHistory.length,
                        itemBuilder: (context, index) => NoteItem(
                            note: state.loanHistory[index],
                            isHistory: true,
                            index: index),
                      );
              } else if (state is NoteLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return const Center(
                child: Text('Error'),
              );
            },
          ),
        ));
  }
}
