import 'package:asmaulhusna/domain/entity/asmaulhusna_entity.dart';
import 'package:asmaulhusna/domain/usecase/asmaulhusna_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'asmaul_husna_event.dart';
part 'asmaul_husna_state.dart';

class AsmaulHusnaBloc extends Bloc<AsmaulHusnaEvent, AsmaulHusnaState> {
  final AsmaulHusnaUsecase usecase;
  AsmaulHusnaBloc({required this.usecase}) : super(AsmaulHusnaState()) {
    on<AsmaulHusnaEvent>((event, emit) async {
      if (event is FetchAsmaulHusnaEvent) {
        try {
          emit(state.copyWith(isLoading: true));
          final response = await usecase.getAsmaulHusna();
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
