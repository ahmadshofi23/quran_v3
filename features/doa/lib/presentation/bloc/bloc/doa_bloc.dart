import 'package:bloc/bloc.dart';
import 'package:doa/domain/entity/doa_entity.dart';
import 'package:doa/domain/usecase/doa_usecase.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'doa_event.dart';
part 'doa_state.dart';

class DoaBloc extends Bloc<DoaEvent, DoaState> {
  final DoaUsecase usecase;
  DoaBloc({required this.usecase}) : super(DoaState()) {
    on<DoaEvent>((event, emit) async {
      if (event is FetchDoaEvent) {
        try {
          emit(state.copyWith(isLoading: true));
          final response = await usecase.getAllDoa();
          if (response.isNotEmpty) {
            emit(state.copyWith(dataDoa: response, isLoading: false));
          }
        } catch (e) {
          emit(state.copyWith(errorMessage: e.toString()));
        }
      }
    });
  }
}
