import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'location_event.dart';
import 'location_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<Position>? _positionSubscription;

  LocationBloc() : super(const LocationState(loading: true)) {
    on<StartLocationTracking>(_onStart);
    on<StopLocationTracking>(_onStop);
    on<LocationUpdated>(_onLocationUpdated);
  }

  Future<void> _onStart(
    StartLocationTracking event,
    Emitter<LocationState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(state.copyWith(error: 'Layanan lokasi tidak aktif', loading: false));
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(state.copyWith(error: 'Izin lokasi ditolak', loading: false));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(
        state.copyWith(error: 'Izin lokasi ditolak permanen', loading: false),
      );
      return;
    }

    _positionSubscription?.cancel();

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((position) async {
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final city =
              placemarks[0].subAdministrativeArea ?? 'Kota tidak diketahui';
          add(LocationUpdated(city: city));
        }
      } catch (e) {
        add(LocationUpdated(error: 'Gagal mendapatkan lokasi: $e'));
      }
    });
  }

  void _onLocationUpdated(LocationUpdated event, Emitter<LocationState> emit) {
    emit(
      state.copyWith(
        city: event.city ?? state.city,
        error: event.error,
        loading: false,
      ),
    );
  }

  Future<void> _onStop(
    StopLocationTracking event,
    Emitter<LocationState> emit,
  ) async {
    await _positionSubscription?.cancel();
    emit(state.copyWith(loading: false));
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    return super.close();
  }
}
