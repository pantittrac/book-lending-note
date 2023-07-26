import 'package:book_lending_note/src/models/book.dart';

class BookStatus {
  final String name;
  final List<VolStatus> volStatusList;  // <vol, onLoan>

  BookStatus(this.name, this.volStatusList);
}

// vol แตกต่าง isbn แตกต่าง
class VolStatus {
  final String isbn;
  final int vol;
  final bool onLoan;

  VolStatus({required this.isbn, required this.vol, this.onLoan = false});

  VolStatus.fromMap(Map<String, dynamic> maps)
      : isbn = maps[Book.columnIsbn],
        vol = maps[Book.columnVol],
        onLoan = false;
}