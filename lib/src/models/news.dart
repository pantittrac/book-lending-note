class News {
  static const tableName = 'news';
  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnUrl = 'url';

  final int? id;
  final String title;
  final String url;

  News({this.id, required this.title, required this.url});

  News.fromMap(Map<String, dynamic> data)
      : id = data[columnId],
        title = data[columnTitle],
        url = data[columnUrl];

  Map<String, dynamic> toMap() =>
      {columnId: id, columnTitle: title, columnUrl: url};

  News copyWith({id, title, url}) =>
      News(id: id ?? this.id, title: title ?? this.title, url: url ?? this.url);
}
