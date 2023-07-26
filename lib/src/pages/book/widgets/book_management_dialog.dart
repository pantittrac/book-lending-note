import 'package:book_lending_note/src/bloc/book_info_bloc/book_info_bloc.dart';
import 'package:book_lending_note/src/bloc/book_management_bloc/book_management_bloc.dart';
import 'package:book_lending_note/src/models/book.dart';
import 'package:book_lending_note/src/repositories/book_repository.dart';
import 'package:book_lending_note/src/utils/db_operation.dart';
import 'package:book_lending_note/src/utils/submit_state.dart';
import 'package:book_lending_note/src/widgets/error_dialog.dart';
import 'package:book_lending_note/src/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookManagementDialog extends StatefulWidget {
  final String title;
  final DbOp op;
  final Book? book;

  const BookManagementDialog(
      {super.key, required this.title, required this.op, this.book});

  @override
  State<BookManagementDialog> createState() => _BookManagementDialogState();
}

class _BookManagementDialogState extends State<BookManagementDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => BookManagementBloc(
                  repo: RepositoryProvider.of<BookRepository>(context),
                  op: widget.op,
                  book: widget.book)),
          BlocProvider(
              create: (context) => BookInfoBloc(
                  repo: RepositoryProvider.of<BookRepository>(context))
                ..add(LoadBookNameEvent()))
        ],
        child: BlocBuilder<BookInfoBloc, BookInfoState>(
            builder: (context, bookInfoState) =>
                BlocConsumer<BookManagementBloc, BookManagementState>(
                  listenWhen: (previous, current) => current.submitState == SubmitState.success,
                  listener: (context, state) => Navigator.pop(context, true),
                  builder: (context, state) {
                    if (bookInfoState.loadNameStatus == LoadStatus.loaded) {
                      if (state.submitState == SubmitState.failure) {
                        return ErrorDialog(
                            message: 'Something went wrong',
                            func: () => context
                                .read<BookManagementBloc>()
                                .add(BackFromErrorDialogEvent()));
                      }
                      return AlertDialog(
                          scrollable: true,
                          title: Text(widget.title),
                          content: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'ISBN',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) => state.isIsbnValid(),
                                    onChanged: (value) => context
                                        .read<BookManagementBloc>()
                                        .add(BookIsbnChangedEvent(isbn: value)),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Autocomplete(
                                    optionsBuilder: (textEditingValue) =>
                                        bookInfoState.bookNameList.where(
                                      (element) => element
                                          .contains(textEditingValue.text),
                                    ),
                                    fieldViewBuilder: (context,
                                            textEditingController,
                                            focusNode,
                                            onFieldSubmitted) =>
                                        TextFormField(
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      decoration: const InputDecoration(
                                          label: Text('Name')),
                                      validator: (value) => state.isNameValid(),
                                      onChanged: (value) => context
                                          .read<BookManagementBloc>()
                                          .add(BookNameChangedEvent(
                                              name: value)),
                                    ),
                                    onSelected:(value) => context
                                          .read<BookManagementBloc>()
                                          .add(BookNameChangedEvent(
                                              name: value)),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        label: Text('Vol')),
                                    validator: (value) => state.isVolValid(),
                                    onChanged: (value) => context
                                        .read<BookManagementBloc>()
                                        .add(BookVolChangedEvent(vol: value)),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          context
                                              .read<BookManagementBloc>()
                                              .add(BookSubmitEvent());
                                        }
                                      },
                                      child: const Text('Add'))
                                ],
                              )));
                    }
                    return const LoadingDialog();
                  },
                )));
  }
}
