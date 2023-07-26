import 'package:book_lending_note/src/dao/book_dao.dart';
import 'package:book_lending_note/src/dao/borrower_dao.dart';
import 'package:book_lending_note/src/dao/loan_dao.dart';
import 'package:book_lending_note/src/dao/news_dao.dart';
import 'package:book_lending_note/src/pages/tabpage.dart';
import 'package:book_lending_note/src/repositories/book_repository.dart';
import 'package:book_lending_note/src/repositories/news_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => BookRepository(BookDao(), LoanDao(), BorrowerDao())),
        RepositoryProvider(create: (context) => NewsRepository(NewsDao())),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TabPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}