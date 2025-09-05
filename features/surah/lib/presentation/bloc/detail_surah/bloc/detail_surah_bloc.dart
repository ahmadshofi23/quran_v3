import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:surah/domain/entities/ayat_entities.dart';
import 'package:equatable/equatable.dart';
import 'package:surah/domain/usecase/quran_usecase.dart';

part 'detail_surah_event.dart';
part 'detail_surah_state.dart';

class DetailSurahBloc extends Bloc<DetailSurahEvent, DetailSurahState> {
  final QuranUseCase quranUseCase;

  DetailSurahBloc({required this.quranUseCase})
    : super(const DetailSurahState()) {
    on<DetailSurahEvent>((event, emit) async {
      if (event is GetDetailSurah) {
        emit(state.copyWith(isLoading: true));
        final response = await quranUseCase.getDetailSurah(
          event.numberOfSurah!,
        );
        emit(state.copyWith(dataAyat: response, isLoading: false));
      }
    });
  }
}
