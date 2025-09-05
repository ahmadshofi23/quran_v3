import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'dart:async';

class LocationService {
  final StreamController<String> _cityController =
      StreamController<String>.broadcast();
  StreamSubscription<Position>? _positionSubscription;

  Stream<String> get cityStream => _cityController.stream;

  Future<void> startCityTracking({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int intervalSeconds = 30,
  }) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _cityController.addError('Layanan lokasi tidak aktif');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _cityController.addError('Izin lokasi ditolak');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _cityController.addError('Izin lokasi ditolak permanen');
      return;
    }

    _positionSubscription?.cancel(); // hentikan stream sebelumnya jika ada

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: 10, // minimum 10 meter perubahan posisi
        timeLimit: Duration(seconds: intervalSeconds), // setiap 30 detik
      ),
    ).listen((Position position) async {
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final city =
              placemarks[0].subAdministrativeArea ?? 'Kota tidak diketahui';
          _cityController.add(city);
        } else {
          _cityController.add('Tidak ditemukan');
        }
      } catch (e) {
        _cityController.addError('Gagal mendapatkan kota: $e');
      }
    });
  }

  void stopCityTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  void dispose() {
    _cityController.close();
    _positionSubscription?.cancel();
  }
}
