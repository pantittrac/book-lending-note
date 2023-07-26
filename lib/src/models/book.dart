// nameing use snake case
class Book {
  static const tableName = 'book';
  static const columnIsbn = 'isbn';
  static const columnName = 'name';
  static const columnVol = 'vol';

  final String isbn;
  final String name;
  final int vol;

  Book({required this.isbn, required this.name, required this.vol});

  Book.fromMap(Map<String, dynamic> data)
      : isbn = data[columnIsbn],
        name = data[columnName],
        vol = data[columnVol];

  Map<String, dynamic> toMap() {
    return {columnIsbn: isbn, columnName: name, columnVol: vol};
  }
}
