import 'package:book_lending_note/src/bloc/news_management_bloc/news_management_bloc.dart';
import 'package:book_lending_note/src/models/news.dart';
import 'package:book_lending_note/src/repositories/news_repository.dart';
import 'package:book_lending_note/src/utils/db_operation.dart';
import 'package:book_lending_note/src/utils/submit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsManagementDialog extends StatefulWidget {
  final String title;
  final DbOp op;
  final News? news;

  const NewsManagementDialog(
      {super.key, required this.title, required this.op, this.news});

  @override
  State<NewsManagementDialog> createState() => _NewsManagementDialogState();
}

class _NewsManagementDialogState extends State<NewsManagementDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsManagementBloc(
          repo: RepositoryProvider.of<NewsRepository>(context),
          op: widget.op,
          news: widget.news),
      child: SimpleDialog(
        title: Text(widget.title),
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: BlocConsumer<NewsManagementBloc, NewsManagementState>(
              listenWhen: (previous, current) => current.submitState == SubmitState.success,
              listener: (context, state) => Navigator.pop(context, true),
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: widget.news?.title,
                        validator: (value) => state.isTitleValid(),
                        onChanged: (value) => context
                            .read<NewsManagementBloc>()
                            .add(NewsTitleChangedEvent(title: value)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Url',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: widget.news?.url,
                        keyboardType: TextInputType.url,
                        validator: (value) => state.isUrlValid(),
                        onChanged: (value) => context
                            .read<NewsManagementBloc>()
                            .add(NewsUrlChangedEvent(url: value)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel')),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                context
                                    .read<NewsManagementBloc>()
                                    .add(NewsSubmitEvent());
                              }
                            },
                            child: const Text('Confirm'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
