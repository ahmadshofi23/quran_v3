import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/domain/usecase/home_usecase.dart';
import 'package:home/presentation/bloc/home/home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeUsecase homeUsecase;

  HomeBloc({required this.homeUsecase})
    : super(const HomeState(loading: true)) {
    on<GetIdCity>(_getIdCity);
  }

  Future<void> _getIdCity(GetIdCity event, Emitter<HomeState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final response = await homeUsecase.getJadwalHarian(event.city);

      emit(
        state.copyWith(
          city: event.city,
          loading: false,
          jadwalHarian: response,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }
}
