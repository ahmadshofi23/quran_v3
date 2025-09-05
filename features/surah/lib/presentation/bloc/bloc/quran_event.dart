part of 'quran_bloc.dart';

abstract class QuranEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetAllSurah extends QuranEvent {}
