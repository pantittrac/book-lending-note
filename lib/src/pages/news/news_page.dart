import 'package:book_lending_note/src/bloc/news_bloc/news_bloc.dart';
import 'package:book_lending_note/src/models/news.dart';
import 'package:book_lending_note/src/pages/web_view_page.dart';
import 'package:book_lending_note/src/repositories/news_repository.dart';
import 'package:book_lending_note/src/pages/news/widgets/news_management_dialog.dart';
import 'package:book_lending_note/src/widgets/delete_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NewsBloc(RepositoryProvider.of<NewsRepository>(context))
            ..add(LoadNewsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('News'),
        ),
        body: BlocConsumer<NewsBloc, NewsState>(
          listener: (context, state) {
            if (state is ShowManagementDialog) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => NewsManagementDialog(
                        title: state.title,
                        op: state.op,
                        news: state.news,
                      )).then((value) =>
                  context.read<NewsBloc>().add(RefreshNewsEvent(value)));
            } else if (state is ShowDeleteConfimationDialog) {
              showDialog(
                  context: context,
                  builder: (context) => DeleteConfirmationDialog(
                        id: state.id,
                        deleteFunc: state.deleteFunc,
                        type: state.type,
                      )).then((value) =>
                  context.read<NewsBloc>().add(RefreshNewsEvent(value)));
            } else if (state is OpenWebViewPageState) {
               Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewPage(url: state.url)));
            }
          },
          buildWhen: (_, state) => (state is! ShowManagementDialog && state is! ShowDeleteConfimationDialog && state is! OpenWebViewPageState),
          builder: (context, state) {
            if (state is NewsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NewsLoadedState) {
              return state.newsList.isEmpty
                  ? const Center(child: Text('No Data'))
                  : NewsList(
                      newsList:
                          state.newsList); //_createNewsList(state.newsList);
            } else if (state is NewsErrorState) {
              return Center(child: Text(state.error.toString()));
            }
            return const Center(child: Text('error'));
          },
        ),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              context.read<NewsBloc>().add(AddNewsEvent());
            },
            child: const Icon(Icons.add_rounded),
          );
        }),
      ),
    );
  }
}

class NewsList extends StatelessWidget {
  final List<News> newsList;

  const NewsList({Key? key, required this.newsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: newsList.length,
      itemBuilder: (buildContext, index) => Card(
        child: ListTile(
          title: Text(newsList[index].title),
          onTap: () => context.read<NewsBloc>().add(OpenWebViewPageEvent(index)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () =>
                      context.read<NewsBloc>().add(EditNewsEvent(index)),
                  icon: const Icon(Icons.edit_outlined)),
              IconButton(
                  onPressed: () {
                    context.read<NewsBloc>().add(DeleteNewsEvent(index));
                  },
                  icon: const Icon(Icons.delete_outline)),
            ],
          ),
        ),
      ),
    );
  }
}
