import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage>
    with SingleTickerProviderStateMixin {
  double? _qiblaDirection;
  double? _heading;
  bool _isCalibrating = false;
  bool _hasError = false;
  StreamSubscription<CompassEvent>? _compassStream;

  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _initLocationAndCompass();
  }

  @override
  void dispose() {
    _compassStream?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initLocationAndCompass() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Izin lokasi diperlukan untuk menentukan arah kiblat',
            ),
          ),
        );
      }
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      _qiblaDirection = _calculateQiblaDirection(
        position.latitude,
        position.longitude,
      );

      _compassStream = FlutterCompass.events?.listen((event) {
        if (event == null) return;

        final accuracy = event.accuracy ?? -1;
        final heading = event.heading;

        if (accuracy < 0 || heading == null) {
          setState(() => _isCalibrating = true);
          return;
        }

        setState(() {
          _heading = heading;
          _isCalibrating = false;
        });
      });

      setState(() => _hasError = false);
    } catch (e) {
      setState(() => _hasError = true);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal mendapatkan lokasi: $e')));
      }
    }
  }

  double _calculateQiblaDirection(double lat, double lon) {
    const kaabaLat = 21.4225;
    const kaabaLon = 39.8262;
    final userLatRad = lat * pi / 180;
    final userLonRad = lon * pi / 180;
    final kaabaLatRad = kaabaLat * pi / 180;
    final kaabaLonRad = kaabaLon * pi / 180;

    double qibla = atan2(
      sin(kaabaLonRad - userLonRad),
      cos(userLatRad) * tan(kaabaLatRad) -
          sin(userLatRad) * cos(kaabaLonRad - userLonRad),
    );

    double qiblaDegrees = qibla * 180 / pi;
    if (qiblaDegrees < 0) qiblaDegrees += 360;

    return qiblaDegrees;
  }

  @override
  Widget build(BuildContext context) {
    final heading = _heading;
    final qibla = _qiblaDirection;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1727),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Arah Kiblat", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child:
            _hasError
                ? const Text(
                  "Terjadi kesalahan saat mengambil lokasi.",
                  style: TextStyle(color: Colors.red),
                )
                : (heading == null || qibla == null)
                ? const CircularProgressIndicator(color: Colors.white)
                : AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, _) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF23395B), Color(0xFF11203E)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.tealAccent.withOpacity(
                                  _isCalibrating ? 0.2 : 0.4,
                                ),
                                blurRadius:
                                    30 * _glowAnimation.value, // efek glow
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Compass background
                              Transform.rotate(
                                angle: (heading * (pi / 180) * -1),
                                child: Image.asset(
                                  'assets/compass_bg.png',
                                  width: 260,
                                  height: 260,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),

                              // Qibla arrow
                              Transform.rotate(
                                angle: ((qibla - heading) * (pi / 180) * -1),
                                child: Image.asset(
                                  'assets/qibla_arrow.png',
                                  width: 110,
                                  height: 110,
                                  color: Colors.tealAccent,
                                ),
                              ),

                              // Center circle
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: Colors.tealAccent,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.tealAccent.withOpacity(0.8),
                                      blurRadius: 15,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Info text
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child:
                              _isCalibrating
                                  ? Column(
                                    key: const ValueKey("calibrating"),
                                    children: const [
                                      Icon(
                                        Icons.warning_amber_rounded,
                                        color: Colors.orangeAccent,
                                        size: 32,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Kalibrasi dibutuhkan\nGerakkan ponsel membentuk angka 8",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.orangeAccent,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )
                                  : Column(
                                    key: const ValueKey("ready"),
                                    children: [
                                      Text(
                                        "🕋 Arah Kiblat: ${qibla.toStringAsFixed(2)}°",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "Kompas: ${heading.toStringAsFixed(2)}°",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                        ),
                      ],
                    );
                  },
                ),
      ),
    );
  }
}
