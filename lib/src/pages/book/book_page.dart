import 'package:book_lending_note/src/bloc/book_bloc/book_bloc.dart';
import 'package:book_lending_note/src/models/book_status.dart';
import 'package:book_lending_note/src/pages/book/widgets/book_management_dialog.dart';
import 'package:book_lending_note/src/repositories/book_repository.dart';
import 'package:book_lending_note/src/widgets/delete_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BookBloc(repo: RepositoryProvider.of<BookRepository>(context))
            ..add(LoadBookEvent()),
      child: Scaffold(
        //backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: const Text('Books'),
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Builder(
                builder: (context) {
                  return TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      fillColor: Colors.white.withAlpha(50),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: "Book's Name",
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          context.read<BookBloc>().add(SearchBookEvent(''));
                        },
                      )
                    ),
                    onSubmitted:(value) => context.read<BookBloc>().add(SearchBookEvent(value)),
                  );
                }
              ),
            ),
          ),
        ),
        body: BlocConsumer<BookBloc, BookState>(
          listener: (context, state) async {
            bool isRefresh = false;
            if (state is ShowManagementDialogState) {
              isRefresh = await showDialog(context: context, builder: (context) => BookManagementDialog(title: state.title, op: state.op,));
            } else if (state is ShowDeleteDialogState) {
              isRefresh = await showDialog(context: context, builder: (context) => DeleteConfirmationDialog(type: state.type, id: state.isbn, deleteFunc: state.func));
            }

            if (context.mounted) {
              context.read<BookBloc>().add(RefreshBookEvent(isRefresh));
            }
          },
          buildWhen: (previous, current) => (current is! ShowManagementDialogState && current is! ShowDeleteDialogState),
          builder: (context, state) {
            if (state is BookLoadedState) {
              final books = state.books;
              return (books.isNotEmpty)
                  ? ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) =>
                          BookItem(bookStatus: state.books[index], bookIndex: index,),
                    )
                  : const Center(child: Text('No Data'));
            } else if (state is BookLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const Center(
              child: Text('Error'),
            );
          },
        ),
        floatingActionButton: Builder(
          builder: (context) { 
            return FloatingActionButton(
              onPressed: () => context.read<BookBloc>().add(AddBookEvent()),
              tooltip: 'Add Book',
              child: const Icon(Icons.menu_book_rounded), //const Icon(Icons.add_outlined),
            );
          }
        ),
      ),
    );
  }
}

class BookItem extends StatelessWidget {
  final BookStatus bookStatus;
  final int bookIndex;

  const BookItem({super.key, required this.bookStatus, required this.bookIndex});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(bookStatus.name),
        children: [_createGridVol(context, bookStatus.volStatusList)],
      ),
    );
  }

  GridView _createGridVol(BuildContext context, List<VolStatus> volStatusList) {
    return GridView.extent(
      shrinkWrap: true,
      maxCrossAxisExtent: 50,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: const EdgeInsets.all(5),
      children: volStatusList
          .map(
            (volStatus) => OutlinedButton(
              onPressed: (volStatus.onLoan) ? null : () => context.read<BookBloc>().add(DeleteBookEvent(volStatus.isbn)),
              child: Text(
                volStatus.vol.toString(),
              ),
            ),
          )
          .toList(),
    );
  }
}


// FOR TEST

// DATA
// final testData = [
  //   BookInfo('test', [BookStatus(1, 0), BookStatus(2, 1), BookStatus(20, 1), BookStatus(120, 1)]),
  //   BookInfo('test2', [BookStatus(0, 1)]),
  //   BookInfo('test3', [BookStatus(0, 1)]),
  //   BookInfo('test4', [BookStatus(0, 1)]),
  //   BookInfo('test5', [BookStatus(0, 1)]),
  //   BookInfo('test6', [BookStatus(0, 1)]),
  //   BookInfo('test7', [BookStatus(0, 1)]),
  // ];

// class BookStatus {
//   final int vol;
//   final int status;

//   BookStatus(this.vol, this.status);
// }

// class BookInfo {
//   final String bookName;
//   final List<BookStatus> volStatus;

//   BookInfo(this.bookName, this.volStatus);
// }
