import 'package:flutter/material.dart';
import 'package:book_lending_note/src/models/tabmodel.dart';
import 'package:book_lending_note/src/pages/book/book_page.dart';
import 'package:book_lending_note/src/pages/news/news_page.dart';
import 'package:book_lending_note/src/pages/note/note_page.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {

  final _tabTestData = [
    TabModel('Books', Icons.book, const BookPage()),
    TabModel('Notes', Icons.note, const NotePage()),
    TabModel('News', Icons.newspaper, const NewsPage()),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabTestData[_selectedIndex].page,
      bottomNavigationBar: BottomNavigationBar(
        items: _tabTestData.map((item) => 
        BottomNavigationBarItem(
          icon: Icon(item.icon),
          label: item.title,
          ),
        ).toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) => setState(() {
    _selectedIndex = index;
  });
}