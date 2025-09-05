import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:surah/domain/entities/surah_entities.dart';
import 'package:surah/domain/usecase/quran_usecase.dart';

part 'quran_event.dart';
part 'quran_state.dart';

class QuranBloc extends Bloc<QuranEvent, QuranState> {
  final QuranUseCase useCase;
  QuranBloc({required this.useCase}) : super(const QuranState()) {
    on<QuranEvent>((event, emit) async {
      if (event is GetAllSurah) {
        try {
          emit(state.copyWith(isLoading: true));
          final response = await useCase.getAllSurah();
          if (response.isNotEmpty) {
            emit(state.copyWith(dataSurah: response, isLoading: false));
          }
        } catch (e) {
          emit(state.copyWith(errorMessage: e.toString()));
        }
      }
    });
  }
}
