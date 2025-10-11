import 'package:bloc/bloc.dart';
import 'package:hadist/domain/entity/hadist_entity.dart';
import 'package:hadist/domain/usecase/hadist_usecase.dart';
import 'package:meta/meta.dart';

part 'hadist_event.dart';
part 'hadist_state.dart';

class HadistBloc extends Bloc<HadistEvent, HadistState> {
  final HadistUsecase hadistUsecase;

  HadistBloc(this.hadistUsecase) : super(HadistInitial()) {
    on<FetchHadistEvent>(_onFetchHadist);
  }

  Future<void> _onFetchHadist(
    FetchHadistEvent event,
    Emitter<HadistState> emit,
  ) async {
    emit(HadistLoading());
    try {
      print('🔍 Fetching hadist...');
      final hadistList = await hadistUsecase.getAllHadist();
      print('✅ Hadist loaded: $hadistList');
      emit(HadistLoaded(hadistList));
    } catch (e) {
      print('❌ Error fetching hadist: $e');
      emit(HadistError(e.toString()));
    }
  }
}
