part of 'book_info_bloc.dart';

@immutable
class BookInfoState {
  final LoadStatus loadNameStatus;
  final List<String> bookNameList;
  final LoadStatus loadVolStatus;
  final List<VolStatus> volList;

  const BookInfoState(
      {required this.loadNameStatus,
      this.bookNameList = const [],
      this.loadVolStatus = LoadStatus.inactive,
      this.volList = const []});

  BookInfoState copyWith(
          {LoadStatus? loadNameStatus,
          List<String>? bookNameList,
          LoadStatus? loadVolStatus,
          List<VolStatus>? volList}) =>
      BookInfoState(
          loadNameStatus: loadNameStatus ?? this.loadNameStatus,
          bookNameList: bookNameList ?? this.bookNameList,
          loadVolStatus: loadVolStatus ?? this.loadVolStatus,
          volList: volList ?? this.volList);
}

enum LoadStatus { inactive, loading, loaded }
