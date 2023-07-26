class Borrower {
  static const tableName = 'borrower';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnContact = 'contact';

  final int? id;
  final String name;
  final String contact;

  Borrower({this.id, required this.name, required this.contact});

  Borrower.fromMap(Map<String, dynamic> data)
      : id = data[columnId],
        name = data[columnName],
        contact = data[columnContact];

  Map<String, dynamic> toMap() =>
      {columnId: id, columnName: name, columnContact: contact};

  Borrower copyWith({
    int? id,
    String? name,
    String? contact,
  }) =>
      Borrower(
          id: id ?? this.id,
          name: name ?? this.name,
          contact: contact ?? this.name);
}
