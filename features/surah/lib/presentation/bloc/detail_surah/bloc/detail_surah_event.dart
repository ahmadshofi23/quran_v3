part of 'detail_surah_bloc.dart';

@immutable
abstract class DetailSurahEvent {}

class GetDetailSurah extends DetailSurahEvent {
  final int? numberOfSurah;
  GetDetailSurah({this.numberOfSurah});
}
