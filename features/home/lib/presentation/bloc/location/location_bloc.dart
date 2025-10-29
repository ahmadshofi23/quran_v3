import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<Position>? _positionSubscription;
  Timer? _debounce;
  String? _lastCity; // simpan kota terakhir untuk mencegah emit berulang

  LocationBloc() : super(const LocationState(loading: true)) {
    on<StartLocationTracking>(_onStartTracking);
    on<StopLocationTracking>(_onStopTracking);
    on<LocationUpdated>(_onLocationUpdated);
  }

  /// 🔹 Mulai melacak lokasi pengguna
  Future<void> _onStartTracking(
    StartLocationTracking event,
    Emitter<LocationState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    // Pastikan layanan lokasi aktif
    final permissionGranted = await _handlePermission(emit);
    if (!permissionGranted) return;

    // Batalkan stream sebelumnya jika ada
    await _positionSubscription?.cancel();

    // Dengarkan perubahan posisi
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // update setiap 10 meter
      ),
    ).listen(
      (position) => _handlePositionChange(position),
      onError: (e) {
        add(LocationUpdated(error: 'Gagal mendapatkan lokasi: $e'));
      },
    );
  }

  /// 🔹 Menghentikan pelacakan lokasi
  Future<void> _onStopTracking(
    StopLocationTracking event,
    Emitter<LocationState> emit,
  ) async {
    await _positionSubscription?.cancel();
    emit(state.copyWith(loading: false));
  }

  /// 🔹 Memperbarui lokasi berdasarkan hasil geocoding
  void _onLocationUpdated(LocationUpdated event, Emitter<LocationState> emit) {
    if (event.city == null && event.error == null) return;

    // Jika kota sama dengan sebelumnya → tidak perlu emit ulang
    if (event.city != null && event.city == _lastCity) return;

    _lastCity = event.city;

    emit(
      state.copyWith(
        city: event.city ?? state.city,
        error: event.error,
        loading: false,
      ),
    );
  }

  /// 🔹 Handle perubahan posisi dengan debounce (hindari panggilan beruntun)
  void _handlePositionChange(Position position) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 2), () async {
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
        add(LocationUpdated(error: 'Gagal mendapatkan nama kota: $e'));
      }
    });
  }

  /// 🔹 Cek & minta izin lokasi, return false jika gagal
  Future<bool> _handlePermission(Emitter<LocationState> emit) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(state.copyWith(error: 'Layanan lokasi tidak aktif', loading: false));
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(state.copyWith(error: 'Izin lokasi ditolak', loading: false));
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(
        state.copyWith(error: 'Izin lokasi ditolak permanen', loading: false),
      );
      return false;
    }

    return true;
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _debounce?.cancel();
    return super.close();
  }
}
